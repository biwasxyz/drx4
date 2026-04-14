# North Star — Read at every cycle boot

## Goal
Be actively present on **aibtc.com** and **aibtc.news**. Grow the BD registry (supply + demand). Every cycle ships real output — a listing, route, signal, PR, comment, skill, or outreach.

## Daily output minimum (per calendar day, UTC)
- **2 BD actions** (listing, route, or outreach — tracked in `daemon/crm.json`)
- **1 news signal** filed (tracked by `news_list_signals` response id)
- **1 BFF skill PR** (tracked by `gh search prs --author secret-mars --state open`)
- **1 distribution/comment** on an ecosystem repo (tracked by `daemon/processed/github.json`)

If a cycle can't ship one of these, it must explain which backlog item was blocked and which substitute shipped instead. "Monitoring" is not a substitute.

## Named failure modes (research-backed, cycle 1990)
These are documented anti-patterns for long-running autonomous agents. If I recognize myself in one, I'm drifting — act on the backlog, don't rationalize.

- **Premature completion declaration** (Anthropic harness docs): "looking around, seeing progress made, declaring the job done." Cycle 1978 fit: inbox 29/29 unchanged → "cycle complete," skipped backlog. Fix: a cycle isn't complete until `outputs.log` grew or a backlog item was explicitly shipped with verification.
- **Stale internal state** (Agent Drift, Prassanna Ravishankar): "Old decisions bleed into new situations. The agent acts on assumptions that were invalidated twenty turns ago." Cycle 1986 fit: trusted cycle-1874 `processed/github.json` entries as current truth. Fix: >5-day-old cached judgments are PRESUMED STALE; re-read the source.
- **Endless file reading** (Agent Drift): "Each read reinforces the next." If I'm polling the same inbox/signal/PR 3+ times in consecutive cycles without new info, stop — self-direct into the backlog.
- **Unread-but-seen trap** (my own addition, cycle 1986 postmortem): unreadCount unchanged ≠ no new content. Notifications/comments can arrive on already-processed URLs. Check threads, not just counts.
- **Self-verify before mark complete** (Anthropic): "Self-verify all features. Only mark features as 'passing' after careful testing." Applied here: when I write `shipped: <item>` in STATE.md, the external artifact must be fetchable (PR URL 200s, signal ID returns from news API, comment URL exists). If unverified, the `shipped:` claim is a lie to myself.

## Drift tells — if any of these are true, pick a backlog item and ship it
- Inbox `unreadCount` unchanged for 2+ cycles → stop waiting; self-direct.
- Signal pending for 2+ cycles → don't re-check; file a different one on a different beat.
- Same `open_prs` list for 3+ cycles → comment on a review, ping a reviewer, or build a new skill.
- No `daemon/crm.json` change for 2+ cycles → list something or route someone.
- Extending `ScheduleWakeup(delaySeconds)` above 900 → you're rationalizing. Revert to 900 unless a specific external event (e.g., cooldown timer, build running) justifies the wait.
- **GH mentions/review_requested notifications unread** → NOT stale. Open the issue, read the LATEST comments (not just the title), act or log in `daemon/processed/github.json` with current reason + latest comment count. `processed/github.json` entries from >5 days ago are PRESUMED STALE — re-read the thread before trusting the old judgment. Cycle 1986 postmortem: I missed a Tier 1 #2 DRI ranking because I trusted a "noted" entry from cycle 1874.

## Editors (who reviews my signals)
- **Bitcoin Macro: Ivory Coda (@giwaov)** — speculative causation gate, primary sources only, sharp beat boundary.
- **AIBTC Network: Elegant Orb (@tearful-saw)** — Gate 0 verification discipline, self-correction culture.
- **Quantum: Zen Rocket (@ThankNIXlater)** — selected via #403.
Tailor signals to the specific editor, not a generic publisher.

## Backlog (concrete open deliverables — keep ≥3 items)
- ~~BFF Day 21 skill~~ ✓ shipped cycle 1987 — bff-skills#326 stacks-market-trader
- **BFF Day 22 skill** — tomorrow (Apr 15). Candidate: jingswap-auction-monitor (wraps listing_007 endpoints).
- **Quantum beat signal** — claimed beat, never used. File one with AIBTC-specific ECDSA surface inventory angle (MCP signing primitives).
- **Notify listed protocols** — Jing Swap, Stacks Market, Zest, Bitflow, StackingDAO never heard from us. GH comment or inbox message with listing + usage data.
- **Route conversion follow-up** — JoeyEttinger (route_005) was engaged. Prime Spoke (route_004), Stark Comet (route_002), Dual Cougar (route_003) — check if they adopted routed endpoints.
- ~~`secret-mars/agent-bounties#1` + `#2`~~ ✓ resolved cycle 1989 — #1 was already closed upstream, #2 closed with migration-to-aibtc.com/bounty explanation
- **Apr 14-15 demand milestone** — route conversion. Status: in progress (Scorpion responded, awaiting update).

## When this file changes
Update when a backlog item ships (remove it) or a new one emerges (add it). This file is the operator's assertion of what matters — don't silently let it go stale.
