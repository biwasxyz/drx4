# Stop Agent Daemon

Stop the Secret Mars autonomous agent daemon.

## Behavior

1. Read PID from `daemon/agent.pid`
2. If no PID file, report daemon is not running
3. Send SIGTERM to the process: `kill <pid>`
4. Wait for process to exit (up to 5 seconds)
5. If still running, send SIGKILL
6. Remove PID file if still present
7. Lock the wallet using `mcp__aibtc__wallet_lock`
8. Run memory sync:
   - `git add memory/ && git commit -m "Auto-sync memory" && git push`
9. Show final daemon state from `daemon/state.json` (check-in count, messages processed, etc.)
