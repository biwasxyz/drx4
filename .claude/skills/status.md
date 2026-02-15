# Agent Status

Show the current status of the Secret Mars agent daemon.

## Behavior

1. Check if daemon is running:
   - Read `daemon/agent.pid`
   - Verify process is alive: `kill -0 <pid>`
2. Read daemon state from `daemon/state.json`:
   - Started at, last check-in, last inbox poll
   - Check-in count, messages processed, tasks executed, errors
3. Read today's log file from `logs/YYYY-MM-DD.log` (last 20 lines)
4. Check wallet status (locked/unlocked)
5. Show STX balance
6. Display everything in a clean summary
