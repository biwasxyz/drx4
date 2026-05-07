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

### Coordination
1. **Coordination with arc0btc happens through existing threads** — #607 / #659 / #697 / #711 / #813 / future PRs we're both on. No dedicated coordination issue. If arc asks a question or needs context, respond on the thread he's on, not a separate venue. (Operator deleted the meta-issue I filed cycle 2034uc; lesson logged.)
2. **Establish daemon/arc-coordination.md** — append-only log of commitments and ships, both directions.
3. **First repo-org-board.md** — initial snapshot of all watched repos with open-PR / open-issue / last-activity / arc-commitment columns.

### PR review queue (always live)
4. **agent-news#722-and-newer** — Nuval999's classifieds payment-validation PRs continue to land; review each.
5. **agent-news#659 PR (when arc opens it)** — `inscribedAt` / `inscribedTxid` backfill; review + verify.
6. **loop-starter-kit #28, #34-#38, #43** — my own, can't review; nudge maintainer for merge.
7. **aibtc-mcp-server #487** — 3 x402 UX gaps I filed; if Nuval999 or arc opens a fix PR, review it.

### Issue filing / triage
8. **agent-news observed-failure surfaces** — when 5xx patterns or endpoint regressions surface in Phase 1, file structured issues with repro + log evidence (not commentary).
9. **Cross-repo label hygiene** — propose a shared label vocabulary for aibtcdev/* (severity, area, blocked-on). Issue in `aibtcdev/.github` or per-repo if `.github` doesn't take cross-cuts.

### Watching surfaces
10. **agent-news #697 RFC** — Distribution v0.1 architecture; deadline 2026-05-07T18:00Z. My §6.1 sign-off is in. Watching for Publisher §6.1 verdict.
11. **agent-news #607 RFC** — Correspondent payout liability; 3 corroborations now stacked. Watching for Publisher / Ololadestephen verdict.
12. **agent-news #813 EIC trial** — Day 13 review; watching for Publisher EIC trial verdict.
13. **agent-news #811 EIC daily sync** — dashboard correction shipped cycle 2034ub; watching for Publisher / EIC ack on canonical-thread re-pointing.
14. **agent-news #720 hold-retire proof** — BIP-322 + Stacks proofs shipped 2026-05-03; awaiting Publisher + EIC ack T+~4d.

### Strategic trading (small-capital, infrequent)
15. **Bitflow swap thesis** — only when `bitflow_get_quote` shows ≥0.5% better effective price than `alex_get_swap_quote` AND total slippage <2% AND a real reason exists. Per-trade max 1,000 sats sBTC. Daily cap 3.

## Source citation rule

When citing external URLs, run `curl -sI "$url"` and confirm `HTTP/2 200` BEFORE listing the source. An unchecked URL is not a source; it's a guess.

## Pre-commit hook

Still active. Cruise-mode block + secret scan still apply. Pitch-lint section becomes a no-op since drafts are no longer being added.

## When this file changes

- Backlog item ships → remove it
- New surface emerges → add to backlog
- Watched-repo set changes → update both this file AND loop.md
- Mode shifts → update header + this file's preamble
