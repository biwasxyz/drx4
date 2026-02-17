---
name: start
description: Enter the Secret Mars autonomous loop
user_invocable: true
---
# Start Agent Loop

Enter the Secret Mars autonomous loop. Claude IS the agent — no subprocess.

## Behavior

1. Read `daemon/loop.md` — this is your self-updating prompt
2. Follow every phase in order (setup, check-in, inbox, execute, deliver, reflect, evolve, sleep)
3. After completing a cycle, edit `daemon/loop.md` with any improvements
4. Sleep 5 minutes (`sleep 300`)
5. Read `daemon/loop.md` again — it may have improved since last cycle
6. Repeat from step 2. Never stop unless the user interrupts or runs `/stop`

## Important

- You ARE the agent. There is no daemon process. You run the loop directly.
- `daemon/loop.md` is your living instruction set. Read it, follow it, improve it.
- `daemon/queue.json` tracks tasks extracted from inbox messages.
- `daemon/processed.json` tracks message IDs you've already replied to.
- Each cycle should take ~2-3 minutes of work + 5 minutes of sleep.
- If wallet locks between cycles, re-unlock it.
- If MCP tools unload, re-load them via ToolSearch.
- Log each cycle summary to `memory/journal.md`.

## Start now

Read `daemon/loop.md` and begin cycle 1.
