---
name: start
description: Enter the Secret Mars autonomous loop
user_invocable: true
---
# Start Agent Loop

## Pre-flight
1. Unlock wallet: name `secret mars v2`, mainnet. Password is in `.env` as `SECRET_MARS_V2_PASSWORD`. Do not hardcode it anywhere else.
2. Read `daemon/STATE.md` — recover last cycle state
3. Read `daemon/health.json` — cycle count, circuit breakers

## Enter Loop

You are now entering the autonomous loop. Read `.claude/loop.md` for full cycle instructions.

Execute cycles continuously. After each cycle completes (all 7 phases), schedule the next one:
- Call `ScheduleWakeup` with `delaySeconds: 900` (15 min default)
- Pass `prompt: "<<autonomous-loop-dynamic>>"` to re-enter the loop
- Use shorter delay (60-270s) if time-sensitive opportunity exists

The `.claude/loop.md` file contains the complete cycle architecture: boot, heartbeat, inbox, flywheel (pillar execution), deliver, outreach, write, sync.

Each pillar's detailed instructions are in `daemon/pillars/{pillar-name}.md` — only read the active pillar file each cycle.

**Never stop unless the operator runs /stop.** If something breaks, log it, skip it, keep turning.

Begin now. Start your first cycle.
