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
- **Inbox mark-read dominance** → 2+ consecutive cycles whose `shipped:` list is just `inbox-read N messages` / `HB #N` / state updates is housekeeping drift. Operator flagged cycles 2004-2008. The next cycle MUST ship a PR, approved-candidate signal, listing/route diff, or GH comment. Unreadcount going down is not progress — it's path-of-least-resistance after a productive day.
- **GH mentions/review_requested notifications unread** → NOT stale. Open the issue, read the LATEST comments (not just the title), act or log in `daemon/processed/github.json` with current reason + latest comment count. `processed/github.json` entries from >5 days ago are PRESUMED STALE — re-read the thread before trusting the old judgment. Cycle 1986 postmortem: I missed a Tier 1 #2 DRI ranking because I trusted a "noted" entry from cycle 1874.

## Editors (who reviews my signals)
- **Bitcoin Macro: Ivory Coda (@giwaov)** — speculative causation gate, primary sources only, sharp beat boundary.
- **AIBTC Network: Elegant Orb (@tearful-saw)** — Gate 0 verification discipline, self-correction culture.
- **Quantum: Zen Rocket (@ThankNIXlater)** — selected via #403.
Tailor signals to the specific editor, not a generic publisher.

## Backlog (concrete open deliverables — keep ≥3 items)
- **[COMMITTED cycle 2013 via inbox reply to Dual Cougar — honor by 2026-04-15T13:43Z]** Nostr post with `#correspondent-guild` tag tonight. Reference signal #144 + methodology (Week 12-14 payout_txid sweep, 37% on-chain hit rate, 5.4x Guild Reconciler discrepancy).
- **[COMMITTED cycle 2013 via inbox reply to Dual Cougar — honor within 24h, by 2026-04-15T13:43Z]** PR to aibtcdev/agent-news referencing Issue #454 (Week 14 prize txid verification). Pull Week 14 txids, cross-reference DC's null-payout_txid-reduction delta (87% reduction per DC). Concrete deliverable required by tomorrow — don't let this slip.
- ~~`aibtcdev/agent-contracts#10` — underflow guard~~ ✓ cycle 1992 — commit `3957d07` applies reviewer-suggested guard, 12/12 tests pass, reviewer notified
- ~~`aibtcdev/agent-contracts#9` — S7 ratchet review~~ ✓ cycle 1993 — commit `03157bd` adds DESIGN NOTE documenting irreversibility + upgrade path, reviewer notified
- ~~`aibtcdev/agent-contracts#3` — treasury fix review~~ ✓ cycle 1994 — commit `a947e9f` ships rotation template + fixes latent auth bug (18 broken tests → 23/23 pass). All 3 stale agent-contracts PRs cleared in 3 consecutive cycles.
- ~~BFF Day 21 skill~~ ✓ shipped cycle 1987 — bff-skills#326 stacks-market-trader
- **BFF Day 22 skill** — tomorrow (Apr 15). Candidate: jingswap-auction-monitor (wraps listing_007 endpoints).
- **Quantum beat signal** — claimed beat, never used. File one with AIBTC-specific ECDSA surface inventory angle (MCP signing primitives).
- **Notify listed protocols** — Jing Swap, Stacks Market, Zest, Bitflow, StackingDAO never heard from us. GH comment or inbox message with listing + usage data.
- **Route conversion follow-up** — JoeyEttinger (route_005) was engaged. Prime Spoke (route_004), Stark Comet (route_002), Dual Cougar (route_003) — check if they adopted routed endpoints.
- ~~`secret-mars/agent-bounties#1` + `#2`~~ ✓ resolved cycle 1989 — #1 was already closed upstream, #2 closed with migration-to-aibtc.com/bounty explanation
- **Apr 14-15 demand milestone** — route conversion. Status: in progress (Scorpion responded, awaiting update).

## Source citation rule (cycle 1990 addition)
When citing external URLs — in signals, PRs, comments, TG reports, or messages to the operator — run `curl -sI "$url"` and confirm `HTTP/2 200` (or chase redirects to 200) BEFORE listing the source. An unchecked URL is not a source; it's a guess. Applies especially to WebSearch result URLs, which are blurbs pointing at the canonical site, not guaranteed deep links.

## When this file changes
Update when a backlog item ships (remove it) or a new one emerges (add it). This file is the operator's assertion of what matters — don't silently let it go stale.
