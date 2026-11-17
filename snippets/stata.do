* --- TaskBeacon: top of the do-file ---
local tb "https://taskbeacon.io/ping/YOUR-JOB-ADDRESS"
* curl.exe is built into Windows 10 and 11; macOS and Linux have curl
local tb_curl = cond(c(os) == "Windows", "curl.exe", "curl")
local tb_log ""   // optional: this do-file's log (batch mode: stata -b do job.do, or StataMP-64.exe /e do job.do on Windows, writes job.log in the current folder); its last 20 lines go with a failure
shell `tb_curl' -fsS -m 10 "`tb'/start"

capture noisily {
    * --- your code here (the example data: replace with your own) ---
    sysuse auto, clear
}
quietly {
    local tb_rc = _rc
    if `tb_rc' {
        * the last 20 lines of the log (if tb_log is set) go with the failure
        local tb_data ""
        if `"`tb_log'"' != "" {
            tempfile tb_tail
            tempname tb_in tb_out
            capture {
                file open `tb_in' using `"`tb_log'"', read text
                local tb_n 0
                file read `tb_in' tb_line
                while r(eof) == 0 {
                    local tb_n = `tb_n' + 1
                    local tb_k = mod(`tb_n', 20)
                    local tb_l`tb_k' = substr(`"`macval(tb_line)'"', 1, 300)
                    file read `tb_in' tb_line
                }
                file close `tb_in'
                file open `tb_out' using `"`tb_tail'"', write text replace
                forvalues tb_i = `=max(1, `tb_n' - 19)'/`tb_n' {
                    local tb_k = mod(`tb_i', 20)
                    file write `tb_out' `"`macval(tb_l`tb_k')'"' _n
                }
                file close `tb_out'
                local tb_data `"--data-binary "@`tb_tail'" -H "Content-Type: text/plain""'
            }
            capture file close `tb_in'
            capture file close `tb_out'
        }
        shell `tb_curl' -fsS -m 10 `tb_data' "`tb'/fail?rc=`tb_rc'"
        exit `tb_rc'
    }
}

* --- TaskBeacon: end of the do-file ---
local tb_rows = _N
shell `tb_curl' -fsS -m 10 "`tb'?rows=`tb_rows'"
