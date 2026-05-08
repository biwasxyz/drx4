---
name: start
description: Enter the Secret Mars autonomous loop
user_invocable: true
---
# Start Agent Loop

## Launching Claude Code

Use `scripts/start-loop.sh` to launch claude with `--dangerously-skip-permissions` and `--channels plugin:telegram@claude-plugins-official` set, so the operator can reach Mars from Telegram between cycles. If claude is already running without the channel flag, ack the gap in `STATE.md` but proceed — the bridge is best-effort, not load-bearing for cycle work.

## Pre-flight (run once, before entering /loop)

1. Unlock wallet — name `secret mars v2`, mainnet. Password in `.wallet-password` (single line). **Never read `.env`** — it contains secrets that should not be loaded into context.
2. Read `daemon/STATE.md` — last cycle's observation/decision/commitment + `this_week_close_target`
3. Read `daemon/health.json` — cycle count, circuit breakers, pillar state
4. Read `daemon/NORTH_STAR.md` — drift reminder + backlog of open deliverables
5. Run `scripts/briefing.sh` — compact boot dashboard
6. Confirm the Telegram bridge is live: the tool list should include `mcp__plugin_telegram_telegram__reply`. If absent, the operator launched without `--channels` — note in `STATE.md` and continue.

## Enter native /loop (self-paced)

Invoke the native `/loop` skill with **no interval** so the model self-paces via `ScheduleWakeup`. Pass this exact prompt as the loop body:

> Execute one cycle of the cross-repo contributions loop defined in `.claude/loop.md`. Run Boot → Phase 1 → 2 → 3 → 4 → 5 → 6. At end of Phase 6, call `ScheduleWakeup` and pass THIS EXACT PROMPT back as the `prompt` argument so the next firing re-enters the same loop. Cadence: default 900s; 60–270s if time-sensitive (worker running, paid send awaiting confirm, reply-poll mid-batch); 1200–3600s for cooldown; >3600s only if operator said back off. Per Claude Code dynamic-/loop docs, omitting ScheduleWakeup ends the loop — so omit only on `/stop`.

The cycle body lives entirely in `.claude/loop.md` — do not duplicate it here. Update that file (or the pillar files it references in `daemon/pillars/`) to change cycle behavior.

## Exit

`/stop` is the graceful shutdown — it instructs you NOT to call `ScheduleWakeup`, saves state, syncs git, and reports cycle number.

**Never stop unless the operator runs `/stop`.** If something breaks, log it, skip it, keep turning.
