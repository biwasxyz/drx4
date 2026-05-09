# North Star — Read at every cycle boot

## Mode (effective 2026-05-07T06:35Z): cross-repo contributions, no role label

**Operator pivot 2026-05-07T06:35Z (post cycle 2034uc seal):** Sales DRI motion is fully retired — not paused, retired. The agent now ships across the aibtc ecosystem — code reviews, fix PRs, issue files, cross-repo routing, partnership work with @arc0btc. **Don't take on titles.** No "manager," no "developer," no role-y self-descriptions on artifacts. Just an agent doing work where the leverage is. The aim is for aibtcdev to read like a coordinated github organization — visible coordination, hygienic backlogs, substantive PR reviews — not for the agent to brand a role for itself.

**Out:** classifieds Sales DRI seat, daily 3-fire unlock, IC pool ops, x402 cold pitches, BD energy budget, cold-count cap, weekly close target, fire-queue scripts, pitch-lint as a sales gate. All `daemon/sales-*` files become historical artifacts (preserved, not active).

**In:** cross-repo state awareness; PR code review (substantive); issue filing on observed bugs; cross-thread routing; triage hygiene (labels, milestones, stalled-thread nudges); partnership with arc; strategic Bitflow swaps under Phase 4 sizing rules.

## Goal

Make aibtcdev — and its partner repos under arc0btc, Robotbot69, secret-mars — read like a coordinated github organization. Concretely:
- Open PRs across watched repos receive substantive reviews within 2 cycles of `review_requested`
- Open issues get triaged, labeled, linked to related work
- Stalled threads (7d+) get a nudge or close-with-verification
- Cross-repo routing happens (don't ask about X on repo A when X is solved on repo B)
- arc + I have a visible coordination thread; commitments tracked in `daemon/arc-coordination.md`
- Weekly: org-wide repo board (`daemon/repo-org-board.md`) reflects current truth

## Watched repos (canonical)

**aibtcdev/* active:**
- `agent-news` (85 open) — primary platform
- `aibtc-mcp-server` (20)
- `loop-starter-kit` (32)
- `landing-page` (22)
- `aibtc-projects` (15)
- `skills` (11)
- `agent-contracts` (10)
- `x402-sponsor-relay` (6), `x402-api` (6), `erc-8004-stacks` (5)
- `tx-schemas` (1), `agent-runtime` (1), `agent-hub` (1), `docs` (2), `branding` (1), `appleseed` (0), `ordinals-market` (0), `agent-sociology` (0), `erc-8004-indexer` (0)

**Partner repos:**
- `arc0btc/arc-starter` (13), `arc0btc/agents-love-bitcoin` (2), `arc0btc/arc0me-site` (6), `arc0btc/arc0btc-worker` (5), `arc0btc/aibtc-genesis-gate` (0)
- `Robotbot69/aibtc-distribution-log`
- `secret-mars/drx4` — mine

Mutable list — new repos get added as they enter active development.

## Drift tells

- Same repo gets all my attention 3+ cycles → tunneling, rotate
- `repo-org-board.md` >4 cycles since rewrite → stale snapshot, refresh
- arc commitment unshipped past stated deadline → block on the cycle that follows
- Notifications unread count >50 going into a new cycle → I'm not marking read consistently
- 3+ consecutive cycles with only `comment_shipped` events (no PR reviews / issue files / board refreshes) → drifted into commenter mode, ship something else
- 7d without a partnership-thread artifact with arc → coordination is silent, fix it

## Backlog (concrete open deliverables — keep ≥5 items active)

> Refreshed cycle 2034v68 (2026-05-09T00:08Z). Prior backlog (v23, mostly `[paused-by-#818]` items) moved to "Archived backlog" footer. Today's surface is dominated by aibtcdev/landing-page Phase 0 → Phase 1.1 → Phase 1.2 pipeline + the dev-council reviewer pattern with @arc0btc + @whoabuddy.

### Coordination
1. **Dev-council reviewer pattern with @arc0btc + @whoabuddy on landing-page** — established by whoabuddy's explicit @-tag of arc + me on #665 RFC (cycle 2034v66). Pattern: when whoabuddy opens a substantive PR (Phase 0+ migration / RFC), arc + I both review pre-merge, fixup commits attribute each reviewer's catch by name. Continue showing up substantively, not LGTM-padding.
2. **arc partnership active surfaces (current):** x402-sponsor-relay#369 (my v12 review still awaiting arc response, 7d threshold ~2026-05-14), landing-page#665 RFC (both APPROVE current), landing-page Phase 1.2 (next migration PR likely tomorrow per RFC plan).

### PR review queue (always live)
3. **landing-page Phase 1.2 (D1 migration scripts)** — next per RFC #665 migration-plan table; expected to open tomorrow (2026-05-09 or 10). Pre-position via scout file when shape is visible. My v67 read-ahead: codify `failClosedOnBindingError(env)` helper to DRY the 4× fail-closed catch pattern + extend to D1 connection-error semantics.
4. **landing-page Phase 1.4 reconciliation** — my #497 closure-path acceptance test recipe (`daemon/scouts/497-pre-phase-2.5-baseline.md`) is ready to drop in. 3-sample +1 drift table is reusable for post-flip verification.
5. **landing-page Phase 0.5** — pending; awaiting Bitflow upstream side-issues resolution.
6. **aibtc-mcp-server #487 follow-on** — Gap 1 (#504) APPROVED by arc + 36h+ awaiting maintainer merge; my v51 ping shipped 2026-05-08T13:54Z. Cooldown until ≥7d since ping or until merge. Gap 2 + Gap 3 scouts (`daemon/scouts/487-gap{2,3}.md`) sequenced after #504 merge.
7. **x402-sponsor-relay#369** — arc 45h+ silent on my v12 verifyMessage asymmetry finding; 7d threshold ~2026-05-14. Patient cooldown.
8. **mcp-server#497 closure path** — Phase 2.5 read-flip is the load-bearing fix; v54/v55 scout has reusable acceptance test. Watch for whoabuddy commit pattern in landing-page Phase 2.5 to mirror or improve in mcp-server.

### Issue filing / triage
9. **Phase 1.2 scout file** — when the PR opens, scout the migration-plan table coverage (which inbox/outbox writes are touched, which D1 schema sections are landed, which still-pending), pre-position the review per the v54/v55 → v65 → v67 pattern.
10. **landing-page#665 RFC merge watch** — both APPROVEs current (mine on b7a9b8f, arc on prior). Whoabuddy may merge or push final fixup. If new commit, read-and-ack within cycle.

### Watching surfaces (low priority observation-only)
11. **agent-news platform** — paused via #818 EIC trial end. No active editorial pipeline; no daily review work. Periodic surface check for new substantive RFC proposals only.
12. **arc-starter#23 maintainer-merge soft-poll** — shipped v54; no movement; rising-leviathan HTTP 202 fix-PR still pending. Patient.
13. **#487 (closed) / #821 / #818 / #822** — observe; no @-tag.

### Strategic trading (small-capital, infrequent)
14. **Bitflow swap thesis** — only when bitflow_get_quote vs alex_get_quote shows ≥0.5% better AND <2% slippage AND a real reason. Per-trade max 1,000 sats sBTC. Daily cap 3. **No active thesis.**

## Recently shipped (cycles 2034v40–v68, 2026-05-08)

- **landing-page#664 (mine)** — Phase 0.6 IP-bucket rate-limit on inbox mark-read PATCH; merged 22:45Z (8min open-to-merge record); arc + whoabuddy APPROVE; followed by #666 hardening migration that preserved my fail-closed semantics + strictly improved preview-env security
- **landing-page#665 D1 schema RFC** — APPROVED v66 with empirical #497 closure validation via v54/v55 scout (3-sample +1 drift) + Phase 2.5 dual-write reply-write coverage + Q1/Q2/Q3 votes + link rot suggestion. Re-APPROVE ack v68 on fixup b7a9b8f (all dev-council suggestions applied verbatim).
- **landing-page#666 hardening bundle** — APPROVE v67 with 4-row NODE_ENV→DEPLOY_ENV migration matrix verifying #664 mark-read fail-closed semantics survive; merged 23:29Z (1m39s before my review submitted — codified as new learning v68: check merge state right before submit).
- **landing-page Phase 0 review pipeline** — substantive reviews on #654 / #656 / #658 / #662 / #664 / #666 over 5h window; pile-on-avoidance discipline; review-bot integration learning (v57 refined: review bots are NOT skippable, only status/CI bots are).
- **mcp-server#497 v54/v55 scout** — 3-sample drift table establishing off-by-one hypothesis empirically; cited in #665 RFC as Phase 1.4 acceptance-test recipe.
- **#504 v51 maintainer-merge ping** (mcp-server) — 25h50m post-arc-APPROVE polite request; codified citation discipline learning (never fabricate issuecomment IDs).
- **arc-coordination.md** — v52 (#23 close + #654 review-to-merge), v60 (Phase 0.2 56min), v66 (#664 8min loop + #665 dev-council pattern).
- **repo-org-board.md** — v9 (cycle 2034v47); refreshed inline at v52, v56, v58, v60, v65, v66.
- **5 active learnings codified in `memory/learnings/active.md`**: v48 (CI-green-then-stall), v50/v57 (read full thread + bot reviews are not skippable), v51 (citation discipline), v60 (minor-nit-flag-discipline), v68 (check merge state pre-review).

## Archived backlog (pre-2026-05-08 pivot, mostly `[superseded-by-#818]`)

> Preserved for reference; not active work. The agent-news editorial pipeline is paused via #818 EIC trial end; the items below are archived rather than actively pursued.

- **agent-news#697 / #607 / #813 / #811 / #720 / #634 / #818 / #820 watching** — all `[paused-by-#818]` or `[superseded-by-#818]` per v23 backlog.
- **agent-news Nuval999 cohort** — 2 unreviewed remained at v23; status moot under pause.
- **loop-starter-kit cohort nudge** — shipped 2034uo; no maintainer response.
- **Cross-repo label hygiene proposal** — de-prioritized v23.

## Source citation rule

When citing external URLs, run `curl -sI "$url"` and confirm `HTTP/2 200` BEFORE listing the source. An unchecked URL is not a source; it's a guess.

## Pre-commit hook

Still active. Cruise-mode block + secret scan still apply. Pitch-lint section becomes a no-op since drafts are no longer being added.

## When this file changes

- Backlog item ships → mark in "Recently shipped" footer or remove
- New surface emerges → add to backlog
- Watched-repo set changes → update both this file AND loop.md
- Mode shifts → update header + this file's preamble
- Major platform-state events (e.g., #818 pause) → annotate affected items with `[paused-by-X]` / `[superseded-by-X]` / `[moot-under-X]`
