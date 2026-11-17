# TaskBeacon for Claude

TaskBeacon watches scheduled scripts and data jobs (Python, R, Stata, SAS, SPSS, PowerShell, Batch, Node.js, cron, Excel VBA) and integrations such as Power BI and dbt Cloud, and alerts you when a job fails, doesn't run, runs late or sends odd data. This plugin connects Claude to your TaskBeacon account.

## Use it

- Ask "What failed last night?" and Claude lists the jobs with a problem, the reason and the error text your script sent.
- Ask "Why did the CRM import load only 12 rows today?" and Claude compares the latest run with earlier ones.
- Paste a scheduled script and ask "Add monitoring to this". Claude creates the job (you confirm it) and puts the reporting lines into your script.
- Ask "Which jobs were flaky this month?" or "What didn't run while the server was down?".
- Ask "Monitor all my scheduled scripts". Where Claude may run commands and edit files on your computer (Claude Code, Cowork), it lists your Task Scheduler or cron jobs, and after you confirm the list it creates one job per script, adds the lines (you review each change) and checks that the first report arrives. In a chat without that access, you paste the list and the scripts and get the changed scripts back.

## What's inside

- The TaskBeacon connector: the remote MCP server at `https://taskbeacon.io/mcp`. You sign in with your TaskBeacon account and choose whether Claude may only read or also set up jobs. Reading works on every plan; creating jobs, pausing or resuming them and changing a schedule are on Pro and Team. Nothing can be deleted through it.
- Five skills: `check-failures` (what failed and why), `add-monitoring` (one script), `monitor-everything` (all scheduled scripts on a machine, with a wrapper for programs you don't want to change), `review-stability` (which jobs are flaky or slower) and `catch-up-missed` (what didn't run while a machine was off).

## Data

The plugin runs nothing on its own. When you ask to monitor everything and allow it, Claude reads your scheduler's list (`schtasks /query` or `crontab -l`) and edits your scripts on your computer; that list stays in your conversation, and TaskBeacon receives only the jobs you confirm. Claude sends your questions' tool calls to taskbeacon.io over HTTPS with your sign-in token, and receives your jobs' names, statuses, schedules, run times, the numbers and error text your scripts sent, and the code to add to a script. TaskBeacon stores nothing from your conversation. Disconnect any time in Settings → AI assistants on taskbeacon.io. Privacy notice: https://taskbeacon.io/privacy/

Docs: https://taskbeacon.io/docs/ai-assistants/ · Support: support@taskbeacon.io
