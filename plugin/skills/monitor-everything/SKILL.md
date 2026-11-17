---
name: monitor-everything
description: Set up TaskBeacon monitoring for all of a user's scheduled scripts at once. Use when the user asks to monitor all their scheduled tasks, cron jobs, Task Scheduler jobs or nightly scripts, or to "watch everything that runs on this machine or server".
---

The TaskBeacon connector itself can't see the user's computer. What you can do depends on the app:
- **With local access** (Claude Code, Cowork, or another app where you may run commands and edit files, and the user allows it): you find the scheduled jobs and edit the scripts yourself.
- **Without it** (a chat on claude.ai or in ChatGPT): the user pastes the scheduler's list and the scripts, and you return the changed scripts for them to save.
Say which mode you are in before you start.

To set up monitoring for every scheduled script:

1. Find the scheduled jobs. With local access, and after the user agrees, run:
   - Windows: `schtasks /query /fo csv /v` lists Task Scheduler tasks with their program, arguments, schedule and last result. Skip Microsoft's own tasks (task names under `\Microsoft\`).
   - Linux or macOS: `crontab -l` and the files in `/etc/cron.d/`.
   If you can't run commands, ask the user to paste that output or the list of their scripts.
2. Show a short table: job name you propose, script path, language, schedule, machine. Ask the user to confirm or remove rows. Call `list_jobs` first and mark scripts that already have a TaskBeacon job, so nothing is created twice.
3. For each confirmed row, call `create_job` with the name, `language`, the same schedule as the scheduler and `machine` (the computer's name). The user confirms each call in their app.
   For a program whose code can't or shouldn't be changed (.bat, .exe, SAS, a script someone else owns), offer the wrapper instead: call `get_wrapper` with the task's program and arguments. It returns a small script and the new Task Scheduler action (or cron line); the program itself stays unchanged.
4. Show each change before saving it, and save only after the user agrees. For a wrapper, save the script and change the task's action (or the crontab line) only after the user agrees. Put the reporting lines from each answer's `code` into that script: the top part at the start, the end part where it finishes, the user's code in the middle. Keep their own error handling and add the failure report inside it. If you can't edit files, show each changed script.
5. Offer to run one script by hand, then call `check_setup` for it to confirm the first report arrived. The others are confirmed after their next scheduled run; tell the user they can ask "is everything reporting?" later.
6. Call `get_alert_settings` and say where alerts will go (for example "to your email right away"). If only email is set and the user works in Slack or Teams, mention they can add it in Settings → Alerts on taskbeacon.io.
7. End with one line per job: name, schedule, link (`url`). Mention that after about a week of runs `suggest_timing` can propose a better grace time.

Never change a scheduler's own settings, and never post a job's address anywhere except the user's own script.
