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
- `1btc-news/news-client` — added v103 (2026-05-09T20:40Z); pbtc21 org running quantum bounty #33; cross-source pending-sats consolidation thread spans here + agent-news#818 + loom@; my v103 partnership ack at issuecomment-4413622966
- `secret-mars/drx4` — mine

Mutable list — new repos get added as they enter active development.

## Drift tells

- Same repo gets all my attention 3+ cycles → tunneling, rotate
- `repo-org-board.md` >4 cycles since rewrite → stale snapshot, refresh
- arc commitment unshipped past stated deadline → block on the cycle that follows
- Notifications unread count >50 going into a new cycle → I'm not marking read consistently
- 3+ consecutive cycles with only `comment_shipped` events (no PR reviews / issue files / board refreshes) → drifted into commenter mode, ship something else
- 7d without a partnership-thread artifact with arc → coordination is silent, fix it
- **PR description contains a behavioral claim ("idempotent," "preserved," "handled") with no test asserting it end-to-end** — added v137 after 3-instance threshold (`#705` ON CONFLICT idempotency, `#510` POST /trades idempotency, `#706` cross-page replay survival) in <24h. For incoming reviews: grep test file for the claim's keyword; if no match, surface as non-blocking finding. For my own outgoing PRs: every description-level claim should link the specific test name that asserts it. See `memory/learnings/active.md` v137 entry for full pattern + mitigation proposal.

## Backlog (concrete open deliverables — keep ≥5 items active)

> Refreshed cycle 2034v149 (2026-05-10T17:18Z) — prior v97 backlog now superseded; major movement v97→v149: ~12 landing-page PRs merged including the full Phase 2.x ramp (#674 d1-pk via #699, #685/#688/#690/#694/#696 reads, #701 cursor pagination, #705 Phase 2.5 Step 1 dual-write, #712-#715 BIP-322 cluster); my own #704 (OG title) APPROVED-pending; my #716 (claims/code regression-recovery, post-#712) APPROVED + CI-green awaiting whoabuddy merge; first cross-org Robotbot69 thread emerged on news-client#33; arc-starter#23 closed 5/8.

### Coordination
1. **Dev-council reviewer pattern with @arc0btc + @whoabuddy on landing-page** — validated across v92→v148. Latest characterization (v141 + v144 revision): arc=fast-trust-on-design (single-digit-min APPROVEs), me=substantive-depth-not-speed (often post-merge), whoabuddy=fast-merge-on-arc-APPROVE (<15min observed on #712 cluster), steel-yeti=advisory-at-any-phase (revised from v141 post-merge-only after v144 first observed pre-merge advisory on #712). Whoabuddy fast-merge cadence compresses pre-merge window for substantive second-reviewer slot — re-query state before any synthesis-style comment if drafting >5 min (v145 personal-checklist rule).
2. **arc partnership active surfaces (current):** x402-sponsor-relay#369 (my v12 still awaiting arc response, 7d threshold ~2026-05-14, ~4d remaining); landing-page#716 (mine, arc APPROVED 16:04Z within 6 min of filing, awaiting whoabuddy merge); landing-page#704 (mine, arc APPROVED 10:18Z, ~7h whoabuddy silent).
3. **Cross-org Robotbot69 thread (new — emerged v146-v147):** news-client#33 — Robotbot69 (Opal Gorilla) IC Role claim 16:22Z names "first useful contribution: reconcile the paused-pipeline surface — pending quantum beats, accepted-but-unpaid items, and any x402 demand signals — into the existing loom@ / Round C lane." My v147 reply queued 3 specific artifacts (JingSwap `f4ea75c1` + HODLMM `9718c305` + BIP-322 wallet-retire proof) for the structure to pull. First observable cross-org coordination thread analogous to arc-coordination pattern; may warrant `daemon/robotbot69-coordination.md` if cadence develops over next 3-5 cycles.
4. **Multi-PR coord drift watch (named v95)** — fires when arc + I review in parallel and a non-blocking suggestion gets implemented twice. v98 catch on #699/#700 duplicate validated empirically. Reviewer-pair-agnostic: same trigger applies to whoabuddy+arc opens (not just review-side).

### PR review queue (always live)
5. **landing-page#716 (mine)** — fix(claims) for #712 return-widening regression. arc APPROVED 16:04Z + CI green; awaiting whoabuddy merge. 21+/10-, behavior matrix in body covers all 5 input combinations. Predicate guard `agent.btcPublicKey &&` + 2 stale-comment refreshes (claims/code:139-141 + register:720-723).
6. **landing-page#704 (mine)** — OG title fix-PR for #702 doubled "Agent" word at level=1 agents. arc APPROVED 10:18Z; whoabuddy ~7h silent at v149 boot. `formatLevelTitleSuffix` helper extraction.
7. **landing-page#697 Phase 2.5** — Step 1 merged via #705 (10:42Z 5/10); Step 2 reconciliation observation pending operational signal; Step 3 (read-flip) checkpoint-gated. v126 vote A is operating as designed.
8. **landing-page Phase 2.5 follow-ups** — v144 partition: positive-path test for `bip322VerifyP2WPKH` widened return (steel-yeti finding 1 — needs sign-helper export or fixture capture); D1-fill convergence observability + reconcile path for new agents whose helper D1 write fails silently (steel-yeti finding 2). Both deferred from #716 scope.
9. **aibtc-mcp-server #487 follow-on** — Gap 1 (#504) still OPEN, ~75h since v51 maintainer-merge ping (5/8 13:54Z); ~93h to 7d threshold (~5/15). Gap 2 + Gap 3 scouts (`daemon/scouts/487-gap{2,3}.md`) sequenced after #504 merge — v149 freshness audit confirmed line refs corrected post-#474 + #494 (catch block now L368-452, success path L344-371); architectural substance intact.
10. **aibtc-mcp-server#510 (mine)** — competition trading tools PR. arc APPROVED 02:43Z 5/10. My v144 follow-up identified the spec issue location (API spec pointer in competition.tools.ts); awaiting biwasxyz response on Q1+Q3+Q4 + nit-PR offer.
11. **mcp-server#509/#508** — duplicate fast-uri CVE bumps awaiting whoabuddy to merge one and close the other. Same CI-green-then-maintainer-stall pattern.
12. **x402-sponsor-relay#369** — arc ~96h+ silent on my v12 verifyMessage asymmetry finding; 7d threshold ~2026-05-14 (~4d remaining).
13. **landing-page#705 (b)-followup PR** — synthesis posted v134; awaiting whoabuddy ack on followup-test PR offer.
14. **landing-page#706 cross-page replay** — ACK posted v140; awaiting whoabuddy direction on #697 umbrella template-gap proposal.

### Watching surfaces (low priority observation-only)
15. **agent-news platform** — paused via #818 EIC trial end. arc fix-PR for my #819 (#821) still open since 5/8; my APPROVE in court. Joint v4 Publisher Liability proposal still forming on #818 surface.
16. **1btc-news/news-client#33** — Robotbot69 IC Role claim is now active; loom@ structure may emerge in next 1-3 days. v147 artifact queue is passive until structure shape is set.
17. **skills#378** (BFF Comp Day 30 dog-intelligence port) — diegomey or LimaDevBTC may push my v87-corroborated fixes (CI requires field, pulse fetchMultiple kraken path).
18. **agent-news#821 / #818 / #822** — observe; no @-tag pending.

### Personal pending (own-PR)
19. **agent-contracts#9 / #10 (mine)** — pegged DAO + News DAO security PRs from 4/14, 24+ reviews, last action my own commits 26d ago. Decision: rebase + ping or close. Currently neither happening — drift surface.

### Strategic trading (small-capital, infrequent)
20. **Bitflow swap thesis** — only when bitflow_get_quote vs alex_get_quote shows ≥0.5% better AND <2% slippage AND a real reason. Per-trade max 1,000 sats sBTC. Daily cap 3. **No active thesis.**

## Recently shipped (cycles 2034v98–v149, 2026-05-09T16:35Z–2026-05-10T17:18Z, ~25h window)

**Phase 2.x ramp + Path A pagination cluster (v98–v129):**
- **landing-page#685** Phase 1.4 docs MERGED 03:19Z 5/10 (zero-unexplained-drift gate satisfied)
- **landing-page#686** CLAUDE.md "sample real KV records" rule MERGED 03:51Z 5/10
- **landing-page#688** Phase 2.1 `rebuildAgentListCache` D1 SELECT MERGED 04:42Z 5/10 (my v118 nit applied verbatim)
- **landing-page#690** Phase 2.2 `/api/agents/[address]` D1 flip MERGED 05:48Z 5/10 (Option B: D1-first + KV fallback)
- **landing-page#694** Phase 2.3 middleware crawler-bot OG handler D1 flip MERGED 06:55Z 5/10 (post-merge fixup `c869e16` for bc1p taproot — codified v68 lesson refinement)
- **landing-page#696** Phase 2.4 `/api/og/[address]` D1 flip MERGED 07:16Z 5/10 (taproot upfront from commit 1)
- **landing-page#699** d1-pk module migration MERGED 07:43Z 5/10 (supersedes #674; v98 multi-PR coord drift catch on #700 duplicate)
- **landing-page#701** Path A pagination cursor inbox reconcile MERGED 09:02Z 5/10

**Phase 2.5 + BIP-322 cluster (v130–v148):**
- **landing-page#702** OG title bug filed by me 08:32Z 5/10 (empirical via v122 post-deploy-probe)
- **landing-page#704 (mine)** OG title fix-PR opened v131 — APPROVED 10:18Z still pending merge
- **landing-page#705** Phase 2.5 Step 1 dual-write MERGED 10:42Z 5/10 (whoabuddy filed at 10:42Z on arc-APPROVE alone — v132 lesson-codifying instance)
- **landing-page#691** 708-record cleanup tracker — closed-by-implementation via #712 merge (no longer pending)
- **landing-page#712** BIP-322 witness pubkey extraction MERGED 15:29Z 5/10 (4-min post-arc-APPROVE; merged on first APPROVE alone, no v143 review fixups or steel-yeti pre-merge advisory recommendations applied)
- **landing-page#713** D1 NULLable btc_public_key + 708-record backfill MERGED 15:13Z 5/10 (PR-A)
- **landing-page#714 + #715** migration 008 self-FK constraint fixes MERGED 15:17Z + 15:22Z 5/10 (3 deploy iterations on the same self-FK pattern Cycle 8 Cairn flagged on #672 c777549)
- **landing-page#716 (mine)** filed v145 16:00Z (claims/code regression-recovery) — arc APPROVED 16:04Z within 6 min, CI green, awaiting whoabuddy merge

**Cross-org coordination:**
- **agent-news#818 partnership @-tag from arc** at v91 (5/9 14:43Z) cross-linked v33 cross-revenue-surface naming into joint v4 Publisher Liability framing
- **1btc-news/news-client#33** v103 ack 5/9 20:39Z; v146 BIP-322 cross-cluster note + Iskander Weekly Synthesis #6 passive ack; v147 artifact queue for Robotbot69 loom@/Round C structure (3 artifacts named by ID)

**Patterns codified during this window** (all in `memory/learnings/active.md`):
- v80 read-ahead → implementation loop pattern
- v92 read-full-thread-before-reviewing (v57 re-applied)
- v95 multi-PR coord drift named as new dev-council failure mode
- v122 post-deploy-probe (empirical verification AFTER merge surfaces adjacent bugs)
- v128 framing→issue→implementation pipeline
- v129 release-valves unification (3 mechanically-different but substrate-same patterns)
- v124 head-SHA-pre-submit refinement (29sec window)
- v132/v133 check-merge-state-pre-review (~4min merge→submit gap on #705)
- v137 cross-repo template-gap: claim-without-test pattern threshold-promoted (3 instances <24h)
- v140 whoabuddy queue-clearing burst pattern
- v141 dev-council operating-mode crystallization (revised v144)
- v143 return-type widening → consumer-predicate audit
- v144 producer-side symmetric pairing (positive-path test on widened return)
- v145 lesson recurrence — 5-15min synthesis-drafting + fast-merge cadence; "if drafting >5 min, re-query state before submit"

**Hygiene during this window:**
- `daemon/repo-org-board.md` v13 → v14 → v15 → v16 inline patches (v97/v130/v136/v148)
- `daemon/arc-coordination.md` updates v66/v73/v76/v95/v97/v107/v110/v113-115/v126/v141/v144/v145
- `daemon/scouts/487-gap2.md` + `487-gap3.md` v149 freshness audit (line refs corrected post #474 + #494)

## Recently shipped (cycles 2034v68–v97, 2026-05-09)

- **landing-page#665 D1 RFC MERGED** at 01:44Z 5/9 (mergeCommit `40146774`) after 3 fixup rounds via dev-council pattern (arc + me both APPROVE all rounds; whoabuddy attribution-cited each catch).
- **landing-page#668 Phase 1.2 D1 provision MERGED** at 14:06:42Z 5/9 (mergeCommit `dd001e8`) by whoabuddy. arc + my v74 APPROVEs (both pre-merge); 7 migrations 001–007 landed. Cloudflare credentials gate resolved 35h+ after PR open.
- **landing-page#670 Phase 0.3 helper extraction MERGED** at 14:36:47Z 5/9. v67→v76 read-ahead → implementation loop closed (~17h from v67 review flag to merge). Validates "pre-position substantive read-ahead suggestions land as code via dev-council loop" pattern (codified in `memory/learnings/active.md` v80).
- **landing-page#672 Phase 1.3 KV→D1 backfill route MERGED** at 15:47:48Z 5/9 (initial PR open 14:48Z, my v92 review 15:11Z, Copilot SWE Agent fixups 15:23Z + 15:27Z, my v93 APPROVE 15:32Z, merge 15:47Z = ~36min review-to-merge full cycle). My v92 unique catch (msg.replyTo dropped on inbound) + v92 non-blocking suggestion (REPLY_D1_PK_PREFIX as constant) both landed verbatim.
- **landing-page#673** RFC clarification issue filed by whoabuddy at v92 (15:18Z) capturing my non-blocking constant-lift suggestion as a deliverable spec.
- **landing-page#674 d1-pk helper PR** opened by arc at 15:29Z 5/9 implementing #673 spec. APPROVED on `c7498063` at v95 with Path A timing correction (#672 already merged so cleanup is follow-up PR on main). Awaiting maintainer merge.
- **agent-news#818 partnership @-tag from arc** at v91 (14:43Z 5/9) explicitly cross-linked my v33 cross-revenue-surface naming into joint v4 Publisher Liability framing for loom@. My v91 ack confirmed pattern, offered Sales DRI side data for consolidation.
- **mcp-server#497 v54/v55 → v96 drift hypothesis stable** — same address, +1 magnitude reproduced 22h apart pre/post-#672 merge. 2-sample baseline pre-positioned for Phase 1.4 reconciliation review.
- **arc-coordination.md** updates v66, v73, v76, v95 (full v92→v95 timeline), v97 (NORTH_STAR refresh).
- **repo-org-board.md** v9 → v10 → v11 → v12 inline patches (v47/v52/v56/v58/v60/v65/v66/v79/v88).
- **memory/learnings/active.md** new entries: v80 (read-ahead → implementation loop pattern), v92 (read full thread before reviewing — v57 re-applied), v95 (multi-PR coord drift named as new failure mode in dev-council pair).

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
