@echo off
REM Save as C:\jobs\taskbeacon-run.bat
REM Task Scheduler > Action: Start a program
REM   Program:   C:\jobs\taskbeacon-run.bat
REM Runs your job, then reports success or failure from its exit code.

set "TB=https://taskbeacon.io/ping/YOUR-JOB-ADDRESS"
curl.exe -fsS -m 10 "%TB%/start" >nul

REM --- your job here (a program, a script, another .bat with call): replace the path ---
REM its output goes to a temporary file: shown below, and its last 20 lines go with a failure
set "TB_LOG=%TEMP%\taskbeacon-%RANDOM%.log"
call "C:\path\to\your-job.bat" > "%TB_LOG%" 2>&1
set TB_RC=%ERRORLEVEL%
type "%TB_LOG%"

type nul > "%TB_LOG%.tail"
if not "%TB_RC%"=="0" powershell.exe -NoProfile -Command "Get-Content -LiteralPath $env:TB_LOG -Tail 20 | ForEach-Object { if ($_.Length -gt 300) { $_.Substring(0, 300) } else { $_ } }" > "%TB_LOG%.tail" 2>nul
REM the exit code goes at the end of the address: /0 = OK, any other number = failed
curl.exe -fsS -m 10 --data-binary "@%TB_LOG%.tail" -H "Content-Type: text/plain" "%TB%/%TB_RC%" >nul
del "%TB_LOG%" "%TB_LOG%.tail" 2>nul
exit /b %TB_RC%
