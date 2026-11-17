# TaskBeacon: Claude plugin and script snippets

[TaskBeacon](https://taskbeacon.io) watches scheduled scripts and data jobs (Python, R, Stata, SAS, SPSS, PowerShell,
Batch, Node.js, cron, Task Scheduler, Excel VBA, SQL Server Agent) and alerts you when a job fails, doesn't run, runs
late or sends odd data, such as zero rows from a script that still exited with code 0.

This repository is the open part of TaskBeacon:

- **`plugin/`**: the TaskBeacon plugin for Claude. It connects Claude to your TaskBeacon account through the remote
  MCP server at `https://taskbeacon.io/mcp` and adds skills to check what failed, add monitoring to a script, monitor
  every scheduled script on a machine, review which jobs are flaky and catch up after missed runs.
  See [plugin/README.md](plugin/README.md).
- **`snippets/`**: the exact lines TaskBeacon generates for each language, so you can see everything that runs in
  your script before you use it. On taskbeacon.io the Code tab fills in your job's own address and your choices.

## Use it with Claude or ChatGPT

Add `https://taskbeacon.io/mcp` as a custom connector (Claude) or custom MCP server (ChatGPT) and sign in with your
TaskBeacon account, then ask "What failed last night?" or "Monitor all my scheduled scripts". Step by step:
https://taskbeacon.io/docs/ai-assistants/

## What the snippets send

Only small web requests to your job's address: start, finish (optionally with numbers such as a row count) and
failure (with the error and the last output lines). No data from your tables or files. Details:
https://taskbeacon.io/docs/reporting/

## License and contact

MIT (see [LICENSE](LICENSE)). The TaskBeacon service itself is not open source. Questions: support@taskbeacon.io.
Privacy notice: https://taskbeacon.io/privacy/
