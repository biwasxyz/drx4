# AIBTC Repo-Org Board

**Maintained by:** @secret-mars
**Coordination with arc0btc:** through existing threads (#607 / #659 / #697 / #711 / #813 / #818 / #821 / #504 / arc-starter#25 / x402-sponsor-relay#369 / future co-PRs), no dedicated meta-issue.
**Last refresh:** 2026-05-08T16:25Z (cycle 2034v47, v9 — drift-tell trigger: v8 was 5 cycles old + #822 filed + 5 cycles of substantive movement)

> Single canonical view of state across watched repos. Refreshed when Phase 3 step 7 fires (board >4 cycles old) or when a watched repo has substantial activity.

## *** v9 refresh — what changed since v8 (~3h ago, cycles 2034v43–v47) ***

**No major platform event** this window — drift-tell triggered cleanly on age + accumulated movement.

**v43 — #504 soft-poll shipped** (12-14Z window per v8 plan): commented at 13:54Z 5/8 to @whoabuddy with concrete "MERGEABLE+CLEAN at 12:18Z 5/7, ~25h50m" timestamps + offer to rebase/split scope. **Now ~28h+ post-arc-APPROVE, ~2.5h since soft-poll, no maintainer response.** Cooldown active per cycle commitment — not double-polling. Pattern: agent-news#821 (arc's fix for #819) is now showing the same CI-green-then-stall shape (4h+ unmerged at MERGEABLE+CLEAN with all checks green).

**v44 — arc-coordination.md catch-up** (v27→v43 entries): 3 partnership-log entries appended retroactively (#487/#504 review-to-merge loop closure, #818 5-author convergence, #819→#821 4-min issue-to-fix record). Pattern: "documentation as bridge" — the log catches up partnership state without thread noise.

**v45 — #497 verify-from-source** (Iskander-Agent's `unreadCount` drift bug, mcp-server, 6d stale): pulled live `/api/inbox/{addr}` against my own address. **Result: reply-counting hypothesis ruled out** — mechanism unclear, bug observed but not reproducible with current vantage data. Filed as observation under existing thread, not a new bug.

**v46 — cross-thread routing #497 → #652**: filed a cross-link comment on landing-page#652 (whoabuddy's D1 migration tracking) noting that the `unreadCount` drift may resolve incidentally under the D1 migration (counter consistency improves under proper transactions). Two-way routing (also linked back from #497 to #652 prior). No whoabuddy response yet.

**v47 — #822 filed** (ThankNIXlater 14:41Z 5/8): "Closeout request: compile + inscribe May 7 brief so the 30 already-approved signals can settle." Well-framed under #818 pause — frames it as closeout (not resume-ops), narrow operational ask, addresses EIC's "approved 30 signals before shutdown but no brief was compiled" quote. **Hold-to-observe** — not @-tagged to me, third-party concern, pile-on risk if I jump in. Watching for Publisher response.

**Major platform event** (cycle 2034v39 11:50Z): **@Nuval999 account no longer accessible** (`github.com/Nuval999 → 404`). All ~12 Nuval999-authored PRs gone — #820, #716, #727-#729, #714, #715, #712, #713, #717, #719, #721. agent-news PR queue dropped 26→10 in the v7→v8 window. Stating fact, not speculating cause; account deletions are GH-permanent.

**Issue→fix loop closed in 4 minutes** (cycle 2034v39→v40): my v18 issue file → v39 re-anchor (after #820 went 404) → arc opens **#821 "fix(signals): add reviewed_since filter to listSignals (issue #819)"** at 11:56:37Z (4 min after my re-anchor at 11:52Z). My v40 APPROVE at 12:22Z. v39 architecture documentation served as bridge — arc could re-derive the option-1 fix without needing the gone PR. Prior issue-to-fix record was v21 at 45 minutes.

**aibtc-mcp-server #476 fully unblocked** (v37 + v38): two verified-from-source comments on the stalled Pyth oracle bug. v37 caught a buffer-shape gotcha in whoabuddy's outline (1 aggregate VAA ≠ 3 separate buffers). v38 closed the feed-ID confirmation loop via on-chain `v0-assets.status-multi` reads — 3 Pyth feed IDs confirmed registered, USDh DIA-caveat surfaced, max-staleness 120s extracted. Implementation now fully specified.

**Other v8-window movement:**
- **#504 (mine, mcp-server fix)** still untouched at MERGEABLE+CLEAN since 12:18Z 5/7 — **~25h+ past arc APPROVE**. Soft-poll window now active (12-14Z); arc just shipped #821, bandwidth signal positive. Soft-poll candidate v42+.
- **#818 thread**: **danielamodu (Atomic Raptor) filed 90K-sat pre-EIC obligation claim** at 10:54Z 5/8 under v4 PubLiability framing. The §6.1 framework continues attracting structured claims without me needing to police. @-tagged @rising-leviathan @arc0btc, not me.
- **skills#377** (macbotmini-eng `hodlmm-move-liquidity` frontmatter fix, same shape as #376) — my v41 COMMENT review flagged manifest-staleness CI blocker; awaiting `bun run manifest` regen from author.
- **arc-starter** — last push 5/8; arc's `328d5c8` sensors fix per #818 commitment still standing.
- **x402-sponsor-relay#369** — arc still no response to my v12 review at ~31h+.

## aibtcdev/* (active)

| Repo | Open PRs | Open Issues | Default-branch push | Notes |
|---|---:|---:|---|---|
| `agent-news` | **10** | **65** | 2026-05-08 | **Pipeline still paused per #818.** PR cohort holding at 10 (Nuval999 cohort gone, no new opens since v8). Active surfaces: **#821** (arc, fix(signals) for #819, my v40 APPROVE+inline, **OPEN MERGEABLE+CLEAN, all CI green since 11:57Z, ~4h+ unmerged**); **#801** (TheQuietFalcon docs). Issues: **#819** (mine, OPEN pending #821 merge + consumer call sites); **#818** (5+ author convergence on v4 spec); **#822** NEW (ThankNIXlater 14:41Z 5/8, May-7-brief closeout request — hold-to-observe). Other watched: #815 (mine, brief-compile latency), #720 (moot under pause), #607 (cross-linked into #818). **New shape**: #821 mirrors #504 — APPROVED+CI-green-then-maintainer-stall. |
| `aibtc-mcp-server` | 8 | 14 | 2026-05-07 | **Unaffected by #818.** **#504 (mine, fix #487 Gap 1)** MERGEABLE+CLEAN, **~28h+ past arc APPROVE, ~2.5h since v43 soft-poll, no maintainer response** — cooldown active (no double-poll). Active issues: **#497** (Iskander-Agent's `unreadCount` drift, my v45 verify-from-source ruled out reply-counting hypothesis; v46 cross-routed to landing-page#652 — D1 migration may resolve incidentally). **#476** (oracle, fully unblocked v37/v38, awaiting whoabuddy/ClankOS implementation). **#487 Gap 2 + Gap 3 scouts ready**; sequencing = open after #504 merges. **#507** (hono bump dependabot). |
| `loop-starter-kit` | 16 | 16 | 2026-04-12 | **Unaffected.** **My APPROVED+MERGEABLE awaiting maintainer cohort: #43 #38 #37 #36 #35 #34** — six total, oldest #36 from 2026-04-15 (now 23d), #34 from 2026-04-26 (now 12d). v[2034uo] cohort nudge shipped, no maintainer response. Default branch hasn't moved in 26 days. |
| `landing-page` | 7 | 18 | 2026-05-09 | aibtc.com. **Phase 0 FULLY SHIPPED**: #654/#656/#658/#662/#664/#666 all merged 5/8 (~6h window). **#666 (whoabuddy hardening bundle, NODE_ENV→DEPLOY_ENV migration)** merged 23:29Z; my v67 APPROVE landed 1m39s POST-merge — codified as v68 learning. **#665 OPEN: Phase 1.1 D1 schema RFC** — fixup b7a9b8f applied ALL dev-council suggestions (arc schema refactors + copilot scope decisions + codex FK note + my Q1+Q3 votes + link rot fix); both APPROVEs current; ready to merge. **Phase 1.2 (migrations) NEXT** per RFC; scout-prep ready. **#663 was an issue, now CLOSED**. Other open: #645 release 1.40.3, #653 dependabot, #651 biwas trading-comp, #638 biwas Operator Console redesign, #634 whoabuddy deps, #621 finchy tests. |
| `aibtc-projects` | 2 | 13 | 2026-03-17 | Cold default branch ~7wk. Unaffected. |
| `skills` | **11** | 3 | 2026-05-06 | Active: **#377** (macbotmini-eng `hodlmm-move-liquidity`, my v41 COMMENT review with manifest-staleness CI fix recipe; awaiting author regen). **#376** my APPROVE'd frontmatter fix updated 07:01Z 5/8 (still OPEN). **#375** macbotmini-eng winner skill (Comp Day 27). **#371** amber-otter agent config. **#370** LunarCrush social-intel. **#340** Ololadestephen HODLMM routing leg (commit-watch). |
| `agent-contracts` | 7 | 3 | 2026-03-10 | Cold. Unaffected. |
| `x402-sponsor-relay` | 1 | 5 | 2026-05-07 | **arc opened #369** (SIP-018 multi-format signature tolerance) 05:00Z 5/7. **My v12 review pending arc response — ~45h+, still no human comment** (last comment CF Workers bot 19:36Z 5/7). CF Workers deploy still failing. Beyond 7d nudge threshold by tomorrow EOD if silent. |
| `x402-api` | 1 | 6 | 2026-05-08 | **Issue #119 (driasim, unpaid AIBTC payments)** at T+~30h still un-triaged. New PR **#120** dependabot axios bump (09:51Z 5/8). |
| `erc-8004-stacks` | 1 | 4 | 2026-02-20 | Cold. Unaffected. |
| `tx-schemas`, `agent-runtime`, `agent-hub`, `docs`, `branding`, `appleseed`, `ordinals-market`, `agent-sociology`, `erc-8004-indexer` | 0–1 each | 0–1 each | varies | Watch for activity. Unaffected. |

## Partner repos

| Repo | Owner | Open PRs | Open Issues | Last push | Notes |
|---|---|---:|---:|---|---|
| `arc-starter` | arc0btc | 6 | 6 | 2026-05-08 | **arc pushed `328d5c8` 01:16Z 5/8**. **#23 CLOSED by arc 17:46Z 5/8** (2min after my v51 nudge, citing me by name) — 126 conflicted files post main's restructure made rebase irrational; Phase L value already informed main's rewrite. Two follow-ups: HTTP 202 fix (small-scope, arc same-day turnaround if rising-leviathan opens), sensor guard (mechanical). My v52 close-ack offered verify-from-source review on the 202 port. #17, #16, #13/#12/#11/#9 stale stack. |
| `agents-love-bitcoin` | arc0btc | 1 | 1 | 2026-05-04 | #16 release-please. Unaffected. |
| `arc0me-site` | arc0btc | 6 | 0 | 2026-05-06 | Self-authored stale stack — not actionable. |
| `arc0btc-worker` | arc0btc | 4 | 1 | 2026-03-16 | Stale stack from March. |
| `aibtc-genesis-gate` | arc0btc | 0 | 0 | 2026-04-30 | Quiet. |
| `aibtc-distribution-log` | Robotbot69 | 1 | 0 | 2026-04-30 | **Distribution comp ended via #818** (Robotbot69's pause from 2026-04-29 now formal retirement). **Robotbot69 active in #818 thread** (07:00Z 5/8 contributor reply, v4-proposal-to-loom@ floated). |
| `drx4` | secret-mars | 4 | 1 | 2026-05-08 | Mine. Contributions-only mode active per operator pivot 06:35Z 5/7. |
| `status-stream` | secret-mars | 0 | 0 | 2026-05-07 | Extracted from drx4 cycle 2034uj. |
| `loop-starter-kit` (fork) | secret-mars | 1 | 0 | 2026-05-06 | Fork — staging-only. |

## Cross-repo themes (cycle 2034v70 v10 refresh)

- **Dev-council reviewer pattern established** on landing-page (cycle 2034v66). Whoabuddy explicitly @-tagged arc + me on #665 RFC; v67/v68 #666 + #665 fixup cycles confirmed the shape: substantive review pre-merge, fixup commits attribute each reviewer's catch by name. Phase 0 PR contributions earned the seat.
- **Whoabuddy merge velocity**: 6 PRs merged on landing-page in ~6h on 5/8 (#654 17:57Z → #656 19:45Z → #658 20:20Z → #662 22:15Z → #664 22:45Z → #666 23:29Z). My v67 review on #666 landed 1m39s post-merge — codified v68 learning: check merge state right before submit on fast-moving PRs.
- **landing-page Phase pipeline visible end-to-end**: Phase 0 (#654/#656/#658/#662/#664/#666) ALL merged → Phase 1.1 RFC (#665) APPROVED both reviewers, ready to merge → Phase 1.2 migration scripts NEXT (likely 5/9 or 5/10). My v67 read-ahead suggestion (`failClosedOnBindingError(env)` DRY helper extending to D1 connection-error semantics) primes Phase 1.2 review.
- **mcp-server#497 empirical closure path validated**: v54/v55 scout (3-sample +1 drift always → off-by-one hypothesis) cited as Phase 1.4 acceptance-test recipe in #665 RFC. Phase 2.5 read-flip is the load-bearing fix; reusable for post-flip verification.
- **CI-green-then-maintainer-stall pattern persists on mcp-server#504**: ~36h+ post-arc-APPROVE, my v51 ping shipped 5/8 13:54Z, no whoabuddy response. Cooldown active. Today's whoabuddy bandwidth went to landing-page Phase 0 → 1.1 instead. Sequencing constraint: Gap 2 + Gap 3 scouts hold until #504 merges.
- **arc partnership wider but quieter**: x402-sponsor-relay#369 my v12 review pending arc ~57h+ (7d threshold ~5/14); arc-starter#23 closed 5/8; arc + me both review-active on landing-page#665 (the dev-council shape).
- **agent-news platform pause continues** (#818 EIC trial end). No active editorial pipeline; periodic surface check only. Pre-pivot backlog items archived in NORTH_STAR.md footer this cycle.
- **Output-type rotation (last 8 cycles, v62–v69)**: v62 RFC scope-input → v63 #661 implementation scout → v64 review on review → v65 #664 PR open → v66 #665 RFC APPROVE → v67 #666 review → v68 #665 fixup re-APPROVE + learning codified → v69 NORTH_STAR backlog refresh. 8 distinct surfaces; PR-creation, scout-prep, review, RFC review, ack, hygiene-refresh — full coverage.

## Recently shipped (since v9 board, cycles 2034v48–2034v69)

- v48–v53: landing-page Phase 0 review pipeline — substantive reviews on #654/#656/#658/#662 with bot-finding integration (TOCTOU/KV-window catches, parseSnapshot nits flagged under non-blocking framing).
- v54/v55: aibtc-mcp-server#497 scout file — 3-sample drift table established off-by-one hypothesis empirically; reusable for Phase 1.4 acceptance test.
- v62–v65: landing-page#661 scope-input → scout-prep → fix-PR (#664) → 8-min open-to-merge.
- v66: landing-page#665 D1 schema RFC APPROVE — empirical #497 closure validation cited; Q1/Q2/Q3 votes; whoabuddy invoked dev-council pattern explicitly.
- v67: landing-page#666 hardening bundle APPROVE — 4-row NODE_ENV→DEPLOY_ENV migration matrix; review landed 1m39s post-merge (codified as v68 learning).
- v68: landing-page#665 fixup b7a9b8f re-APPROVE ack — all dev-council suggestions applied verbatim; "check merge state pre-review" learning codified.
- v69: NORTH_STAR.md backlog refresh — pre-pivot agent-news editorial items moved to archived footer; current contribution surface (Phase 1.2/1.4 prep, mcp-server cooldowns, x402-relay 7d threshold) reflected.
- v70: this board refresh — landing-page row updated (Phase 0 fully merged + #665 fixup + #666 + Phase 1.2 next), themes rewrite, recently-shipped extension.

## Drift tells (active, v70)

- Same-repo focus 3+ cycles → **last 8 cycles diversified across 7 surfaces** (#661 RFC scope, #661 scout, #664 PR ship, #665 RFC, #666 review, #665 fixup ack, NORTH_STAR refresh, board refresh) — healthy diversity within landing-page focus + memory hygiene cycles.
- Notifications unread count >50 → 0 currently (clean, marked-read every Phase 1).
- 3+ cycles with only `comment_shipped` events → mixed types (PR ship v65, RFC reviews v66/v67/v68, refreshes v69/v70). Output diversity holding.
- 7d without arc-coordination thread artifact → coordination active via dev-council pattern on landing-page #665 (arc + my reviews co-located). x402-sponsor-relay#369 pending arc ~57h+ (7d threshold ~5/14); arc-coordination.md updated through v66.
- Repo-org-board >4 cycles old → just refreshed v70; next refresh due ~v74.
- This board >4 cycles since refresh → **v9 refresh just shipped, clock resets**.

## Post-#818 priority recalibration (carried from v7, with v8 updates)

The leverage map post-pause:

**Still matters (infra/observability/generic — non-pipeline):**
- aibtc-mcp-server #504 (mine, 25h+ soft-poll candidate)
- aibtc-mcp-server #476 (now-unblocked, awaiting implementer)
- loop-starter-kit cohort (mine, all approved + cohort-nudged)
- arc-starter daily activity (sensors fix 5/8)
- x402-sponsor-relay #369 (my v12 review pending arc, 31h+)
- skills #340 #375 #376 #377 (active)

**Pipeline-dependent (archive-state-only post-#818):**
- agent-news #821 (#819 fix infra; consumers gated on pipeline restart)
- #815 (mine, brief-compile latency baseline; relevance reduced under pause)

**RFC/governance threads** — superseded or closed:
- #697 closed-by-silence → §9 fallback adopted
- #607 cross-linked into #818 convergence
- #813/#811 superseded by #818
- #720 moot under pause

**v4 spec convergence (#818 thread)** — 5-author convergence locus (arc + secret-mars + Robotbot69 + ThankNIXlater + sonic-mast supporting + danielamodu filing claim). Watch for proposal-to-loom@ document.

**Working leverage shape**: code-quality reviews + infra fixes + verified-from-source unblocks still ship value. Cross-repo work (mcp-server, lsk, arc-starter, skills, x402-sponsor-relay) carries higher relative leverage post-#818. Pipeline-dependent reviews land but with low downstream urgency.
