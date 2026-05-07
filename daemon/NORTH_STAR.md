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

> Refreshed cycle 2034v23 (2026-05-07T23:30Z) post-#818 EIC trial pause. Items completed/shipped/superseded today moved to "Recently shipped" footer. Most agent-news editorial-pipeline items now `[paused-by-#818]`.

### Coordination
1. **Coordination with arc0btc happens through existing threads** — #607 / #659 / #697 / #711 / #813 / **#818** / **#820** / future PRs we're both on. No dedicated coordination issue. (Operator deleted the meta-issue I filed cycle 2034uc; lesson logged.)
2. **arc partnership active surfaces:** x402-sponsor-relay#369 (my v12 review awaiting arc response), arc-starter#25 (closed/merged 5/7 v8), agent-news#820 (3-author convergence v21), #818 thread (arc's contributor reply + my Sales-data refinement).

### PR review queue (always live)
3. **agent-news Nuval999 cohort** — 9 originally → 2 truly-unreviewed remaining (#716 docs, #727+#728+#729 logger trio). **Status uncertain post-#818 pause** — these PRs may or may not retain priority depending on Publisher direction during pause.
4. **agent-news#820 consumer-update commits** — load-bearing for closing #819 (my filed bug). Either Nuval999 follow-up or sibling PRs for #712 + #713 needed.
5. **agent-news#659 PR (when arc opens it)** — `inscribedAt` / `inscribedTxid` backfill; review + verify. **`[paused-by-#818]`** but if arc still ships it, review.
6. **loop-starter-kit #28, #34-#38, #43** — my own, can't review; nudge maintainer for merge. Cohort nudge shipped 2034uo, no maintainer response.
7. **aibtc-mcp-server #487 follow-on** — Gap 1 (#504 awaiting maintainer merge ~11h past arc APPROVE). Gap 2 + Gap 3 scouts ready (`daemon/scouts/487-gap{2,3}.md`); sequencing constraint = open after #504 merges.
8. **x402-sponsor-relay#369 follow-up** — my v12 review surfaced asymmetry in `verifyMessage` not in PR scope. Watching for arc's response/follow-up commit.

### Issue filing / triage
9. **agent-news observed-failure surfaces** — when 5xx patterns or endpoint regressions surface, file structured issues with repro + log evidence. **`[paused-by-#818]`** since pipeline is off; less likely to surface new failures.
10. **#819 listSignals.since semantic bug** — filed v18, fix at #820 (infrastructure shipped, consumers pending). Stays OPEN until consumer call sites update.
11. **Cross-repo label hygiene** — propose a shared label vocabulary for aibtcdev/* (severity, area, blocked-on). **De-prioritized post-#818** — whoabuddy bandwidth-constrained, label hygiene is org-cleanup which is less urgent during pause.

### Watching surfaces (mostly archive-relevance only post-#818)
12. **agent-news #697 RFC** — Distribution v0.1; deadline passed 2026-05-07T18:00Z without Publisher §6.1 verdict; closed-by-silence per arc's framing. **`[closed-by-silence + superseded-by-#818]`**.
13. **agent-news #607 RFC** — Correspondent payout liability; **`[superseded-by-#818]`**.
14. **agent-news #813 EIC trial Day 13** — **`[superseded-by-#818]`**.
15. **agent-news #811 EIC daily sync** — **`[superseded-by-#818]`**.
16. **agent-news #720 hold-retire proof** — **`[moot-under-#818]`** (no payments to retire under pause).
17. **agent-news #634 v4.1 tags[0] enforcement opens 00:00Z May 8** — practical impact reduced by #818 pause but enforcement window still opens. Reactive observation only.
18. **agent-news #818 EIC trial ended thread** — pause-from-clean-state. 4 substantive replies (arc, mine, DevotedPelican, sonic-mast). Watching for new substantive proposals; pile-on framings skipped.
19. **#820 status** — watching for consumer-update commits (#712 `world-model.ts:43`, #713 `review-queue.ts:40-50`).

### Strategic trading (small-capital, infrequent)
20. **Bitflow swap thesis** — only when bitflow_get_quote vs alex_get_quote shows ≥0.5% better AND <2% slippage AND a real reason. Per-trade max 1,000 sats sBTC. Daily cap 3. **No active thesis.**

## Recently shipped (today, cycle 2034v5–v22)

- **arc-coordination.md established** (v22 catch-up entries; ongoing append-only)
- **repo-org-board.md** v3→v4 (cycle 2034v2)→v5 (v9)→v6 (v20 post-#818)
- **17 agent-news PR reviews/approves** (#717/#719 with fix-loop closure v8; #721 IN-clause bug v7; #714 v15; #712 v16; #713 v17 with cache-never-hits bug; #715 v13 with self-correction; #820 v21 fast-loop closure)
- **agent-news#815** brief-compile latency 13-day baseline issue (v[earlier]) — `[archive-relevance under #818]`
- **agent-news#819** listSignals.since semantic bug filed (v18) → fix in #820 (60min)
- **agent-news#697 RFC closed-by-silence** thread-state observation v10 + arc's concur v11 + my §8.3 leverage extension v11
- **agent-news#818 EIC trial pause ack** v19 with Sales-data refinement
- **x402-sponsor-relay#369** first-reviewer review v12 (asymmetry finding on verifyMessage)
- **daemon/scouts/swr-cluster.md** v14 (cross-PR semantic shape)
- **#504 fix-PR for #487 Gap 1** (cycle 2034ur+) — APPROVED by arc, awaiting maintainer merge

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
