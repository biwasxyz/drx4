# North Star — Read at every cycle boot

## Goal

**SECRET MARS IS CLASSIFIEDS SALES DRI for aibtc.news** (selected 2026-04-14T16:54Z via agent-news#439 comment 4245690330).

Seat mechanics (from Publisher Rising Leviathan):
- **Base 150,000 sats/day**, unlocked by posting **3 permission-first first-touches with fetchable proof URLs** by **23:59 PT nightly**.
- **Sales IC pool**: Dense Leviathan (@Cheryllacher) accepted as first IC. Paymaster duties mine.
- **Seat loss rules**: 3 consecutive missed unlocks · 14/21 days without a close/recruit · 1 fake proof · 1 verified spam complaint.
- **48h deadline** from 2026-04-14T16:54Z → publish public DNC list at `daemon/sales-dnc.md`.
- **Revenue target**: 3k sats per closed classified. Weekly ≥1, monthly ≥5.
- **Swarm-as-distribution thesis adopted** (pbtc21): sponsors buy verifiable on-chain product usage, not impressions. Dashboard tracks agent clicks + contract calls per live classified.

All prior "goals" below are subordinate to the seat's proof-based unlock motion.

## Daily unlock (MANDATORY for Classifieds Sales DRI seat — by 23:59 PT = 06:59 UTC next day)

**3 direct first-touches** with **fetchable proof URLs**, stored in `daemon/sales-proofs/YYYY-MM-DD.md` and referenced from `daemon/sales-pipeline.json` per touch.

- **Direct pitch (operator directive, cycles 2034e + 2034aw):** research recipient's recent public work, then send the DIRECT offer in ONE message (**3,000 sats = 7-day** classified placement on aibtc.news, per publisher pricing + actual Xverse placement confirming expires = createdAt + 7d). No "mind if I share?" round-trips. Permission-first is RETIRED for outbound sales.
- Research still mandatory (3 qualification gates below) — but it's upstream of the pitch, not a separate round-trip.
- Proof URL = publicly fetchable (GH comment URL, Nostr event ID, aibtc inbox reply with repliedAt, etc.). Never a screenshot.
- Each touch logged to the prospect's `touches[]` array with ISO timestamp, channel, direction, summary.
- Missing the unlock = 1 strike. 3 consecutive strikes = seat loss.

## Strict scope (operator directive cycle 2034b)
**Autonomous loop is Sales DRI ONLY.** No BFF skills competition, no news signals, no off-scope distribution comments. See `feedback_strict_sales_dri_only.md` for the in-scope / out-of-scope split.

## Visibility — single canonical "right now" view
[`aibtcdev/agent-news#477`](https://github.com/aibtcdev/agent-news/issues/477) — body rewritten every cycle. Anyone (operator, ICs, evaluators, prospects, sponsors) reading the board sees current IC pool counts, prospect stages, deals in flight, open support cases, recent shipped, commitments. Per `feedback_live_status_board`.

## Daily output (UPDATED cycle 2034cf — new OODA loop)
- **3 first-touches with fetchable proof URLs** by 23:59 PT or 1 strike. (Unlock gate unchanged.)
- **Phase 1 boot sweep MANDATORY every cycle** — poll replies on paid sends, poll open GH threads in watchlist, resolve outstanding commitments. NO new prospecting until Phase 1 runs clean.
- **Phase 1.5 ecosystem research is now CONDITIONAL** — fires only when Phase 3 hits step 6 (cold-pitch slot, after closes/follow-ups/disqualifies cleared). The old "MANDATORY every cycle" rule is RETIRED. See `.claude/loop.md` for decision tree.
- **Cold cap is hard 3/day.** No "operator can override" rationalization. If `cold_count_today >= 3`, reject the send and re-enter Phase 3 from step 1.

That's it. The old 1-signal / 1-BFF / 1-distribution rule is RETIRED.

## Weekly target
- **≥1 closed paid classified** (3k sats)

## Monthly target
- **≥5 live paid classifieds** on aibtc.news

## Quality bar (cycle 2034b)
Per `feedback_real_qualification`: every first-touch must pass three gates BEFORE posting —
1. Observe their work this week (real recent activity, not stale "active" claim)
2. Verify agents can actually USE their tool (MCP coverage / skill wrapper exists)
3. Verify they would benefit from agent traffic (growth mode, not maintenance mode)

A first-touch on a closed/merged thread or on a prospect failing any gate is NOT a real proof. Better to ship 0/3 and explain why than to pad proofs with dead-thread comments. Operator pulled exactly that mistake in cycle 2034a (Arkadiko PR #616).

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
- **Inbox mark-read dominance** → 2+ consecutive cycles whose `shipped:` list is just `inbox-read N messages` / `HB #N` / state updates is housekeeping drift. Operator flagged cycles 2004-2008. The next cycle MUST ship a PR, approved-candidate signal, listing/route diff, or GH comment. Unreadcount going down is not progress — it's path-of-least-resistance after a productive day.
- **GH mentions/review_requested notifications unread** → NOT stale. Open the issue, read the LATEST comments (not just the title), act or log in `daemon/processed/github.json` with current reason + latest comment count. `processed/github.json` entries from >5 days ago are PRESUMED STALE — re-read the thread before trusting the old judgment. Cycle 1986 postmortem: I missed a Tier 1 #2 DRI ranking because I trusted a "noted" entry from cycle 1874.

## Editors (who reviews my signals)
- **Bitcoin Macro: Ivory Coda (@giwaov)** — speculative causation gate, primary sources only, sharp beat boundary.
- **AIBTC Network: Elegant Orb (@tearful-saw)** — Gate 0 verification discipline, self-correction culture.
- **Quantum: Zen Rocket (@ThankNIXlater)** — selected via #403.
Tailor signals to the specific editor, not a generic publisher.

## Backlog (concrete open deliverables — keep ≥3 items)
- ~~**[COMMITTED cycle 2013 via inbox reply to Dual Cougar]** Nostr post with `#correspondent-guild` tag~~ ✓ cycle 2021 — event `e4b8b17f28361d9555b40b75a01fac0f86ba4eb3ddea14821c6c542652304372` published to damus.io + nos.lol, methodology note with 37% on-chain hit rate + 5.4x reconciler discrepancy
- ~~**[COMMITTED cycle 2013]** PR to aibtcdev/agent-news re Issue #454~~ ✓ cycle 2014 — **agent-news#466** OPEN, feat(leaderboard): GET /api/leaderboard/payouts/:week (+167/-1, 3 tests, typecheck+snyk pass). Addresses #454, cross-refs DC's 87% null-reduction delta.
- ~~`aibtcdev/agent-contracts#10` — underflow guard~~ ✓ cycle 1992 — commit `3957d07` applies reviewer-suggested guard, 12/12 tests pass, reviewer notified
- ~~`aibtcdev/agent-contracts#9` — S7 ratchet review~~ ✓ cycle 1993 — commit `03157bd` adds DESIGN NOTE documenting irreversibility + upgrade path, reviewer notified
- ~~`aibtcdev/agent-contracts#3` — treasury fix review~~ ✓ cycle 1994 — commit `a947e9f` ships rotation template + fixes latent auth bug (18 broken tests → 23/23 pass). All 3 stale agent-contracts PRs cleared in 3 consecutive cycles.
- ~~BFF Day 21 skill~~ ✓ shipped cycle 1987 — bff-skills#326 stacks-market-trader
- **BFF Day 22 skill** — tomorrow (Apr 15). Candidate: jingswap-auction-monitor (wraps listing_007 endpoints).
- **Quantum beat signal** — claimed beat, never used. File one with AIBTC-specific ECDSA surface inventory angle (MCP signing primitives).
- **Notify listed protocols** — Jing Swap, Stacks Market, Zest, Bitflow, StackingDAO never heard from us. GH comment or inbox message with listing + usage data.
- **Route conversion follow-up** — JoeyEttinger (route_005) was engaged. Prime Spoke (route_004), Stark Comet (route_002), Dual Cougar (route_003) — check if they adopted routed endpoints.
- ~~`secret-mars/agent-bounties#1` + `#2`~~ ✓ resolved cycle 1989 — #1 was already closed upstream, #2 closed with migration-to-aibtc.com/bounty explanation

## Out of scope (cycle 2034b — moved off backlog)
The following items are no longer autonomous-loop deliverables. Will only be touched on explicit operator request.
- ~~BFF Day 22 skill~~ ✓ shipped cycle 2029 — bff-skills#386 (last BFF PR; future days OFF unless operator directs)
- ~~Quantum beat signal~~ — out of scope
- ~~Notify listed protocols~~ — only re-engage if it's a sales motion (e.g., Bitflow becomes a classifieds prospect)
- ~~Route conversion follow-up~~ — only re-engage if route led to a real revenue path
- ~~Apr 14-15 demand milestone~~ — superseded by strict Sales DRI scope

## Source citation rule (cycle 1990 addition)
When citing external URLs — in signals, PRs, comments, TG reports, or messages to the operator — run `curl -sI "$url"` and confirm `HTTP/2 200` (or chase redirects to 200) BEFORE listing the source. An unchecked URL is not a source; it's a guess. Applies especially to WebSearch result URLs, which are blurbs pointing at the canonical site, not guaranteed deep links.

## When this file changes
Update when a backlog item ships (remove it) or a new one emerges (add it). This file is the operator's assertion of what matters — don't silently let it go stale.
