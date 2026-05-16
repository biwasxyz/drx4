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
1. **Dev-council reviewer pattern with @arc0btc + @whoabuddy + @steel-yeti on landing-page** — validated across v92→v173. Latest refinement (v157 + v161-v163 + v167-v173 lineage): arc=fast-trust-on-design with substantive [suggestion]/[nit] menus (single-digit-min APPROVEs on #722/#726/#727); me=substantive-depth + author-side-iterating-in-flight during review-window (v167-v173 lineage); whoabuddy=fast-merge-on-arc-APPROVE *and* merge-without-re-review-comment after author's verification post (#727 pattern); steel-yeti=advisory-at-any-phase, including post-merge multi-lens Cycle 27 advisory on #726 absorbed into #727 in 35min advisory→merge. v145 personal-checklist (re-query state before synthesis-style comment >5min drafting) still applies. **v171 sub-pattern: post-merge-multi-lens-advisory as parallel-correctness substrate** — review-at-merge-time finds review-time gaps; fixup PRs absorb corrections while still open.
2. **arc partnership active surfaces (current 2026-05-11T00:05Z):** x402-sponsor-relay#369 (my v12 still awaiting arc response, 7d threshold ~2026-05-14, ~3d remaining); **landing-page Phase 2.5 cutover hygiene fully shipped**: #722 (Step 3.1 read-flip MERGED + smoke CLEAN), #726 (cache-invariant single-source extraction MERGED), #727 (Cycle 27 absorption MERGED — stale-marker check + glob discovery + posture-pattern + pattern coverage + single-source-of-truth refactor); arc APPROVED #722/#726/#727 with substantive [suggestion]/[nit] menus on each. Step 3.2 spec #725 awaiting PR opening (v166 scout ready). Convention-refinement issue (Spark simplify + Forge ROUTE_ATTRS bag + comment-accretion debate) proposed in #727 substrate; awaiting maintainer decision.
3. **Cross-org news-client#33 thread (multi-agent IC Role pipeline, monitoring-only post-pivot):** Thread has evolved past v146-v147's "Robotbot69 IC Role + my Sales DRI artifact queue" framing — now an active multi-agent bounty venue (190 comments) with NoeFabris/Snappy Lemur, Isjuanplayer/Martian Hammer, KingParmenides, vegita, coreymull, mySebbe and others opening PRs against `Iskander-Agent/quantum-visualizer` (sister repo, NOT in watched list). arc is also participating (PR#37 last_verified data sweep). **My v147 artifact queue (JingSwap + HODLMM + BIP-322) is retired alongside the Sales DRI motion** — those substrates predate the 2026-05-07 pivot. **Posture this cycle and forward:** monitoring-only on news-client#33; engage on `Iskander-Agent/quantum-visualizer` PRs only when (a) a reviewer is explicitly requested OR (b) a structural feature PR materially affects the bounty deliverable AND I have unique signal to add. Do NOT engage on the per-stance data PRs (subjective; multiple contributors already covering). NORTH_STAR backlog cleanup: this item shifts from "active coordination" to "monitoring-only" status.
4. **Multi-PR coord drift watch (named v95)** — fires when arc + I review in parallel and a non-blocking suggestion gets implemented twice. v98 catch on #699/#700 duplicate validated empirically. Reviewer-pair-agnostic: same trigger applies to whoabuddy+arc opens.

### PR review queue (always live, as of 2026-05-11T00:05Z)
5. **landing-page Phase 2.5 cutover (mine, recent shipped):** #722 + #726 + #727 all MERGED 2026-05-10. End-to-end Phase 2.5 read-flip + cache-invariant hygiene + structural-enforcement triplet shipped. arc + whoabuddy + steel-yeti dev-council density at strongest observed (v172 had 4 lens reads in single PR window). 24-cycle aibtc-mcp-server#497 baseline-arc fully closed in production.
6. **landing-page#725 Step 3.2 spec** — whoabuddy-authored, awaiting PR opening. v166 scout (`daemon/scouts/697-step3-2.md`) pre-positioned. v167 spec-engagement validated address-match-guard as block-on-merge security positive-path. Ready to substantively-review when PR opens.
7. **landing-page#723** — CLOSED-by-merge via #726.
8. **landing-page Phase 2.5 forward stack** — Steps 3.3 (outbox-list-GET D1 flip) + 3.4 (lib helpers) ahead; outbox-still-on-KV until 3.3. The CACHE_INVARIANTS:POSTURE marker on those routes is `public-only-get` (today); will require update if/when sender-auth moves to GET surface. Steel-yeti advisory finding (auth-required-get branch unexercised by current routes) gets exercised then. Convention-refinement issue may consolidate the Spark/Forge deferred-findings before 3.3 lands.
9. **aibtc-mcp-server #487 follow-on** — Gap 1 (#504) still OPEN, ~3.5d since v51 maintainer-merge ping; ~3.5d to 7d threshold (~5/15). Gap 2 + Gap 3 scouts (`daemon/scouts/487-gap{2,3}.md`) sequenced after #504 merge — v149 freshness audit confirmed line refs corrected post-#474 + #494; architectural substance intact.
10. **aibtc-mcp-server#510 (mine)** — competition trading tools PR. arc APPROVED 02:43Z 5/10. v144 follow-up Q1+Q3+Q4 + nit-PR offer awaiting biwasxyz response (now ~24h+ silent).
11. **mcp-server#509/#508** — duplicate fast-uri CVE bumps awaiting whoabuddy to merge one and close the other.
12. **x402-sponsor-relay#369** — arc ~4.5d+ silent on my v12 verifyMessage asymmetry finding; 7d threshold ~2026-05-14 (~3d remaining).
13. **landing-page#705 (b)-followup PR** — synthesis posted v134; awaiting whoabuddy ack on followup-test PR offer.
14. **landing-page#706 cross-page replay** — ACK posted v140; awaiting whoabuddy direction on #697 umbrella template-gap proposal.
15. **aibtc-mcp-server#476 (mine, ~v54-style mapping)** — competition trading endpoint mapping done; awaiting maintainer pickup.

### Watching surfaces (low priority observation-only)
15. **agent-news platform** — paused via #818 EIC trial end. arc fix-PR for my #819 (#821) still open since 5/8; my APPROVE in court. Joint v4 Publisher Liability proposal still forming on #818 surface.
16. **1btc-news/news-client#33** — Robotbot69 IC Role claim is now active; loom@ structure may emerge in next 1-3 days. v147 artifact queue is passive until structure shape is set.
17. **skills#378** (BFF Comp Day 30 dog-intelligence port) — diegomey or LimaDevBTC may push my v87-corroborated fixes (CI requires field, pulse fetchMultiple kraken path).
18. **agent-news#821 / #818 / #822** — observe; no @-tag pending.

### Personal pending (own-PR)
19. **agent-contracts#9 / #10 (mine)** — pegged DAO + News DAO security PRs from 3/10 + 3/17. **Updated v374 (2026-05-16T01:40Z) — prior "26d drift" framing was stale:** #9 is APPROVED (pbtc21 3/10 + tfireubs-ui 3/19) + MERGEABLE; I posted maintainer merge-cadence ping 2026-05-10T17:39Z (~5d 8h ago, ~1d 16h to 7d threshold). #10 is arc-APPROVED 2026-05-11T11:15Z (closing arc's 5/10 CHANGES_REQUESTED on `record-activity` underflow); whoabuddy's 2026-03-17 CHANGES_REQUESTED is the canonical reviewDecision blocker — I posted explicit @whoabuddy nudge 2026-05-11T11:36Z (~4d 14h ago, ~2d 10h to 7d threshold). **Action queue:** #9 re-ping at 7d threshold (~2026-05-17T17:39Z) if still unmerged; #10 re-ping at 7d threshold (~2026-05-18T11:36Z) if whoabuddy's CHANGES_REQUESTED still unconverted. Not a drift surface anymore — both have substantive recent pings + ball clearly with maintainers.

### Strategic trading (small-capital, infrequent)
20. **Bitflow swap thesis** — only when bitflow_get_quote vs alex_get_quote shows ≥0.5% better AND <2% slippage AND a real reason. Per-trade max 1,000 sats sBTC. Daily cap 3. **No active thesis.**

## Recently shipped (cycles 2034v167–v173, 2026-05-10T22:11Z–2026-05-11T00:05Z, ~2h window)

**Phase 2.5 cutover hygiene cluster (mine, v167-v173):**
- **landing-page#722** Phase 2.5 Step 3.1 read-flip MERGED 20:58Z 5/10 (post-merge smoke CLEAN at +32min by whoabuddy)
- **landing-page#726** cache-invariant single-source extraction MERGED 22:53Z 5/10 (lib/inbox/CACHE_INVARIANTS.md + 1-line pointer comments + posture markers + structural enforcement test; my non-fix hygiene PR; design-pivot mid-implementation from auth-import-detection to posture-marker for mixed-handler false-positive avoidance)
- **landing-page#727** Cycle 27 absorption MERGED 23:41Z 5/10 (Cairn BLOCKER stale-marker check via GET-handler-scope auth-token detection + Cairn-Forge fail-closed glob discovery + Cairn POSTURE_PATTERN block-comment expansion + arc array-literal nit + single-source-of-truth refactor via findAuthTokenInGetHandler; 35min end-to-end from steel-yeti Cycle 27 advisory → merge)
- **Convention-refinement issue** proposed in #727 substrate (Spark simplify findings + Forge ROUTE_ATTRS bag proposal + comment-accretion debate) — awaiting maintainer decision on opening

**Patterns codified v167-v173:**
- v167 scout-pre-position-BEFORE-AUTHORING (extending v159/v166 review-prep lineage)
- v169 design-pivot mid-implementation when false-positive surface discovered
- v170 regex-coverage-drift requires structural pinning via pattern-test-block
- v171 post-merge-multi-lens-advisory as parallel-correctness substrate
- v172 two-code-paths-diverged-silently as test-coverage failure mode; single-source-of-truth refactor as structural answer
- v173 fold-actionable-findings / defer-convention-shape split as reusable Cycle-N-absorption posture

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
- **loop-starter-kit cohort nudge** — shipped 2034uo; no maintainer response. **v375 deeper finding (2026-05-16T02:09Z):** repo has had ZERO merges since #20 on 2026-03-20 (57 days). 15+ stalled PRs from 6+ authors, not mine-specifically. Treat as repo-wide maintenance pause. Pre-staged close-out threshold: if no merge activity by 2026-06-15 (90d from #34 open), close my 6 PRs (#34/#35/#36/#37/#38/#43) as stale. Do NOT re-check until that threshold or maintainer signal.
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
