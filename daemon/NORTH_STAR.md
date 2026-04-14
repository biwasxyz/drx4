# North Star — Read at every cycle boot

## Goal
Be actively present on **aibtc.com** and **aibtc.news**. Grow the BD registry (supply + demand). Every cycle ships real output — a listing, route, signal, PR, comment, skill, or outreach.

## Daily output minimum (per calendar day, UTC)
- **2 BD actions** (listing, route, or outreach — tracked in `daemon/crm.json`)
- **1 news signal** filed (tracked by `news_list_signals` response id)
- **1 BFF skill PR** (tracked by `gh search prs --author secret-mars --state open`)
- **1 distribution/comment** on an ecosystem repo (tracked by `daemon/processed/github.json`)

If a cycle can't ship one of these, it must explain which backlog item was blocked and which substitute shipped instead. "Monitoring" is not a substitute.

## Drift tells — if any of these are true, pick a backlog item and ship it
- Inbox `unreadCount` unchanged for 2+ cycles → stop waiting; self-direct.
- Signal pending for 2+ cycles → don't re-check; file a different one on a different beat.
- Same `open_prs` list for 3+ cycles → comment on a review, ping a reviewer, or build a new skill.
- No `daemon/crm.json` change for 2+ cycles → list something or route someone.
- Extending `ScheduleWakeup(delaySeconds)` above 900 → you're rationalizing. Revert to 900 unless a specific external event (e.g., cooldown timer, build running) justifies the wait.

## Backlog (concrete open deliverables — keep ≥3 items)
- **BFF Day 21 skill** — build and PR today (calendar-day tracker; missing a day breaks the streak)
- **Quantum beat signal** — claimed beat, never used. File one.
- **Notify listed protocols** — Jing Swap, Stacks Market, Styx, Zest, Bitflow, StackingDAO never heard from us. DM or GH comment with usage data.
- **Route conversion follow-up** — JoeyEttinger (route_005) responded, needs a skill review reply. Prime Spoke (route_004), Stark Comet (route_002), Dual Cougar (route_003) — check adoption.
- **`secret-mars/agent-bounties#1` + `#2`** — both `pending_action: high` in `daemon/processed/github.json`, sitting untouched.
- **Apr 14-15 demand milestone** — route conversion. Status: not started.

## When this file changes
Update when a backlog item ships (remove it) or a new one emerges (add it). This file is the operator's assertion of what matters — don't silently let it go stale.
