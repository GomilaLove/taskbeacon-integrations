---
name: catch-up-missed
description: Find runs that did not happen and help run them again. Use when a computer or server was off, restarted or offline, after a power or network outage, or when the user asks what did not run while they were away.
---

To catch up after missed runs:

1. Call `missed_runs` with `hours` covering the outage (ask when it started if it isn't clear) and, if the user names the computer, `machine`.
2. Show the missed runs grouped by machine: job name and when it should have run. Jobs whose `status_now` is ok have already run since: say so and leave them out of the next step.
3. For the rest, ask which ones the user wants to run again now. Some jobs shouldn't run twice or out of order (loads, emails, payments), so never run anything without the user's answer.
4. With local access to that machine and the user's go-ahead, start a Task Scheduler job with `schtasks /run /tn "<task name>"` or run the cron command by hand. Without it, list what the user should start.
5. After they ran, call `check_setup` or `recent_problems` to confirm the reports arrived.
