# Save as C:\jobs\taskbeacon-run.ps1
# Task Scheduler > Action: Start a program
#   Program:   powershell.exe
#   Arguments: -NoProfile -ExecutionPolicy Bypass -File C:\jobs\taskbeacon-run.ps1 "C:\path\to\program.exe" "arg1" "arg2"
# Runs the program, then reports success or failure from its exit code.
# A .ps1 script as the program is run with powershell.exe -NoProfile -ExecutionPolicy Bypass -File script.ps1
# (an execution policy set by Group Policy still wins over Bypass).

$tb = "https://taskbeacon.io/ping/YOUR-JOB-ADDRESS"
$program, $programArgs = $args
# a .ps1 file is not a program Windows can start on its own ("not a valid Win32 application")
if ($program -match '\.ps1$') {
    $programArgs = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $program) + @($programArgs | Where-Object { $null -ne $_ })
    $program = 'powershell.exe'
}
function Send-TaskBeacon($path, $text) {
    $send = @{ UseBasicParsing = $true; TimeoutSec = 10; Uri = ($tb + $path) }
    if ($text) { $send.Method = 'Post'; $send.ContentType = 'text/plain; charset=utf-8'; $send.Body = [Text.Encoding]::UTF8.GetBytes($text) }
    try { Invoke-WebRequest @send | Out-Null }
    catch { Write-Host "TaskBeacon ping failed: $_" }
}
Send-TaskBeacon "/start"
# keep arguments that contain spaces together
$argLine = ($programArgs | ForEach-Object { if ($_ -eq '' -or $_ -match '[\s"]') { '"' + ($_ -replace '"', '\"') + '"' } else { $_ } }) -join ' '
# Windows PowerShell 5.1 refuses an empty -ArgumentList: pass it only when there are arguments
$run = @{ FilePath = $program; Wait = $true; PassThru = $true; NoNewWindow = $true; ErrorAction = 'Stop' }
if ($argLine) { $run.ArgumentList = $argLine }
# the program's output goes to temporary files: shown below, and its last 20 lines go with a failure
$out = [IO.Path]::GetTempFileName(); $err = [IO.Path]::GetTempFileName()
$run.RedirectStandardOutput = $out; $run.RedirectStandardError = $err
$code = 1
$note = ''
try {
    $p = Start-Process @run
    if ($null -ne $p.ExitCode) { $code = $p.ExitCode }
} catch { $note = "Could not start ${program}: $_"; Write-Host $note }
Get-Content -LiteralPath $out, $err -ErrorAction SilentlyContinue
$tail = ''
if ($code -ne 0) {
    $lines = @(Get-Content -LiteralPath $out, $err -Tail 20 -ErrorAction SilentlyContinue) + @($note)
    $tail = ($lines | Where-Object { $_ } | ForEach-Object { if ($_.Length -gt 300) { $_.Substring(0, 300) } else { $_ } }) -join "`n"
}
# the exit code goes at the end of the address: /0 = OK, any other number = failed
Send-TaskBeacon "/$code" $tail
Remove-Item -LiteralPath $out, $err -ErrorAction SilentlyContinue
exit $code    # not 0 when it failed, so Task Scheduler shows the failure too
