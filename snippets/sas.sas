/* --- TaskBeacon: top of the program --- */
%let tb = https://taskbeacon.io/ping/YOUR-JOB-ADDRESS;
filename tb_out temp;
%macro tb_ping(path);
  proc http url="&tb.&path" method="GET" out=tb_out timeout=10; run;
%mend;
%tb_ping(%str(/start));

/* --- your code here --- */
data work.result; set sashelp.class; run;

/* --- TaskBeacon: end of the program --- */
%macro tb_end;
  /* SYSCC: 0 = fine, 4 = only warnings, above 4 = errors */
  %if &syscc > 4 %then %do;
    /* after an error, batch SAS checks only the syntax (OBS=0) and skips steps: leave that mode so the ping runs */
    options nosyntaxcheck obs=max replace;
    %tb_ping(%str(/fail?rc=&syscc));
  %end;
  %else %do;
    proc sql noprint; select count(*) into :tb_rows trimmed from work.result; quit;
    %tb_ping(%str(?rows=&tb_rows));
  %end;
%mend;
%tb_end;
