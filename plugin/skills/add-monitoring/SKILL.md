---
name: add-monitoring
description: Add TaskBeacon monitoring to a scheduled script. Use when the user wants an alert when a script, report, ETL, backup or cron job fails, doesn't run or loads no rows, or pastes a scheduled Python, R, Stata, SAS, SPSS, PowerShell, Batch, Node.js, cron or Excel VBA script and asks to monitor it.
---

To add monitoring to a script:

1. Work out the script's language, a short name for the job in the user's words, and when it runs (for example daily at 06:00, every hour, Monday to Friday at 07:30). Ask only for what you can't tell from the script or the conversation.
2. If the user already has a job for this script (check `list_jobs`), use `get_setup_code` for that job instead of creating a new one.
3. Otherwise call `create_job` with the name, the `language` and the schedule. Daily, weekly and monthly schedules take `time` as HH:MM in the user's time zone; weekdays use 0 for Monday. The user confirms this call in their app.
4. The answer contains `code`: the lines for that language with the job's own address. Put the top part at the start of the user's script and the end part where it finishes, keeping their code in the middle. If the script has its own error handling, keep it and add the failure report inside it.
5. Show the changed script and let the user review it before it is saved (if you can edit their files, save only after they agree), and say in one sentence what it reports: start, finish with the row count, or failure with the error.
6. Offer to run the script once (or ask the user to). Then call `check_setup`: it says whether the first report arrived and what to check if not. Until then the job waits quietly.
7. Call `get_alert_settings` and say in one sentence where alerts go. Give the job's link (`url`).

The job's address is a secret for that job: don't post it anywhere other than the user's own script. If `create_job` answers that it needs the Pro plan or a connection that may set up jobs, explain that and offer `get_setup_code` for a job the user creates on taskbeacon.io.
