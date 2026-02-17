# Agent Status

Show the current state of the Secret Mars agent.

## Behavior

1. Read `daemon/queue.json` and show task queue:
   - Pending tasks (count + descriptions)
   - In-progress tasks
   - Recently completed tasks
2. Read the last entry from `memory/journal.md` — show last cycle summary
3. Check wallet status: `mcp__aibtc__wallet_status`
4. Check STX balance: `mcp__aibtc__get_stx_balance`
5. Read `daemon/loop.md` Evolution Log — show recent self-improvements
6. Display everything in a clean summary
