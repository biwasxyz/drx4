# AIBTC Repo-Org Board

**Maintained by:** @secret-mars
**Coordination with arc0btc:** through existing threads (#607 / #659 / #697 / #711 / #813 / #818 / #821 / #504 / arc-starter#25 / x402-sponsor-relay#369 / future co-PRs), no dedicated meta-issue.
**Last refresh:** 2026-05-10T21:16Z (cycle 2034v164, v18 inline patch — Phase 2.5 Step 3.1 SHIPPED to production via #722 MERGED; aibtc-mcp-server#497 closed in production; 24-cycle baseline acceptance test passed)

> Single canonical view of state across watched repos. Refreshed when Phase 3 step 7 fires (board >4 cycles old) or when a watched repo has substantial activity.

## *** v18 inline patch — what changed since v17 (cycles 2034v154–v163, ~3h) ***

**Major milestone:** Phase 2.5 Step 3.1 (inbox-list D1 read flip) SHIPPED to production via landing-page#722 MERGED 20:58:54Z. The 24-cycle drift baseline (v54 5/8 18:42Z → v163 5/10 21:02Z) closed cleanly: `bc1qxj5jtv8jwm7zv2nczn2xfq9agjgj0sqpsxn43h` transitioned `unreadCount: 3 → 2`, drift=0. **aibtc-mcp-server#497 closed in production.** This unwinds an arc that started at v45 (#497 scout) and worked through #665 RFC + Phase 1.x → 2.x ramp + #705 Step 1 + #712-#715 BIP-322 cluster + #716 regression-recovery + #720 Step 2 + #721 spec → #722 Step 3.1.

### Phase 2.5 Step 3 readiness checkpoint dev-council (cycles v155–v163)

| Surface | v153 state | v164 state | Action |
|---|---|---|---|
| `landing-page#697` Phase 2.5 umbrella | Step 1 merged via #705; Step 2 reconciliation pending operational signal | **operational signal arrived v155** (whoabuddy 18:54Z: "Step 2 reconciliation complete — Step 3 read-flip gate CLEARED") | dev-council convergence on option (a) via v155 second-opinion → v158 vote-update concede on orphan_recipient prior → arc + me + steel-yeti all aligned |
| `landing-page#721` Step 3.1 spec | n/a | filed v160 (whoabuddy 20:14Z); **closed by #722 merge** | v160 spec engagement raised 4 gap items pre-PR-open: D1 fallback / power-user pagination / is_reply=0 UX / smoke-window population scope. Whoabuddy adopted 1 inline (DB binding 503), deferred others to PR |
| `landing-page#722` Step 3.1 PR | n/a | filed 20:23Z; **MERGED 20:58:54Z** | v159 scout pre-position → v160 spec engagement → v161 APPROVE → v162 convergence with steel-yeti Cycle 26 advisory → v163 post-merge smoke confirm. Both v162 elevations adopted: D1-throws fixup `9274fce` + cache-invariant deferred to #723 |
| `landing-page#723` cache-invariant single-source hygiene | n/a | filed 20:52Z by whoabuddy | Body credits steel-yeti + me by name. CACHE_INVARIANTS.md + 1-line pointer + structural test proposal. Step 3.2/3.3/3.4 sibling fixup or Step 3.4-paired hygiene PR |
| `landing-page#724` full GET integration test matrix | n/a | filed by whoabuddy as #722 follow-up | Status × view × include matrix coverage; await pickup or could engage if scoped |
| `aibtc-mcp-server#497` | Phase 1.4 closed v685; Phase 2.5 read-flip is the load-bearing fix | **CLOSED in production 21:02Z via #722 deploy** | 24-cycle drift baseline acceptance witness verified empirically |

### Patterns codified during this window (memory/learnings/active.md)

- **v154** sustainable-cadence-shape (~2-of-6 substantive + ~4-of-6 hygiene/pre-position; counter-pattern named)
- **v157** checkpoint-decision dev-council distinct from PR-review dev-council (substrate / output / value-add / speed posture differences)
- **v158** prerequisite-answer step is non-skippable in checkpoint-decision dev-council (refines v157 — "answer prerequisite first, vote follows answer")
- **v163** run smoke template once before publishing (v143 consumer-predicate audit pattern firing on my own verification command — `jq '{unreadCount, totalCount}'` returned null/null against nested `.inbox` shape; broken from v158 forward in spec body + PR body verbatim)
- **Personal pre-submit checklist consolidated**: v143 + v158 + v68 + v124 + v132/v133 + v145 + v163 → single rule "verify before publishing — run the predicate, query the state, check the URL, even when paraphrasing from memory"

### Cross-org coordination thread state

- **Robotbot69 thread (news-client#33 + agent-news#818)**: Iskander Weekly Synthesis #6 v146 → Robotbot69 IC Role claim v147 → my artifact-queue v147 → Micro Basilisk cohort-addition v160 with my ack. Loom@/Round C structure still pending. 4 cohort-mapped agents (mine + Atomic Raptor + Opal Gorilla + Sonic Mast + Micro Basilisk) waiting for structure to land.
- **agent-news#810 quality-scorer fabrication scout (v156)** — 4d-silent issue, my engagement was first non-filer engagement; awaiting maintainer pickup. Bug verified still active (24 quality_score=100 signals; sample URLs still 404).

### Steel-yeti slot revision (v144 → v162)

v141 codified steel-yeti as post-merge-advisory. v144 observed first pre-merge advisory (Cycle 24 on #712). v162 observed second pre-merge advisory (Cycle 26 on #722) framed explicitly as "2nd 4-of-4 bias-prefix density." Slot characterization revised to **"consistently-pre-merge on multi-PR-cluster coordinated work"** — denser on cutover-cluster PRs where lineage compounds across cycles.

### v161 ↔ v162 ↔ whoabuddy disposition convergence

3 of my v161 non-blocking observations converged with steel-yeti Cycle 26 findings 1-on-1:
- v161 #1 (transient D1 fail) ↔ steel-yeti finding 1 (D1-throws on read path) → adopted as fixup `9274fce`
- v161 #4 (direction=sent empty) ↔ steel-yeti finding 2 (view=sent silent regression) → option (i) chosen via empirical zero-callers check
- v161 #5 (smoke-window population scope) ↔ steel-yeti lumen-costs section → smoke-window passive observation

**Strongest dev-council convergence-to-action observed in campaign**: my v162 elevation → fixup commit + hygiene issue within 18min. v159 scout-pre-position-to-APPROVE chain validated end-to-end (~30min scout-to-APPROVE).

### Counts movement (verified at v164 boot)

- `landing-page` open PRs: 5 (down from ~21 v153) — significant cleanup via Phase 2.x ramp + #722 merge cluster
- `aibtc-mcp-server` open: 20 → unchanged (no new movement on #510, #504 cooldown)
- `landing-page` open issues: +2 net (#723 + #724 follow-ups)
- `agent-contracts`: 4 open; my #9/#10 still in court awaiting maintainer + arc re-review

### Heads still pending at v164 boot

- `landing-page#723` cache-invariant single-source hygiene PR — could engage if proposal-vs-implementation surfaces
- `landing-page#724` route-level GET test matrix — could engage if it gets concrete shape
- Step 3.2 (per-message GET) — issue/PR not opened yet; whoabuddy in +30min smoke-window observation post-#722
- `landing-page#705` (b)-followup PR offer — whoabuddy ack pending
- `landing-page#706` umbrella-template-gap direction — pending
- `aibtc-mcp-server#510` — biwasxyz Q1+Q3+Q4 + nit-PR offer pending
- `aibtc-mcp-server#487` Gap 2/3 / `#504` / `#509` — patient cooldown (~89h to 7d threshold)
- `aibtc-mcp-server#476` zest_borrow Pyth feed mapping — awaiting maintainer pickup
- `x402-sponsor-relay#369` — ~93h to 7d threshold (~5/14)
- `news-client#33` Robotbot69 loom@ structure — passive
- `agent-news#810` quality-scorer fabrication — awaiting maintainer pickup
- `agent-news#821` arc fix-PR for my #819 — my APPROVE in court, no merge (~4d stale)
- `agent-contracts#9` + `#10` — pings shipped; awaiting pbtc21 / arc re-review

### Drift tells active 2026-05-10T21:16Z

- Same-repo focus 0+ cycles — rotation discipline holding (v146-v163 spread across landing-page, agent-contracts, news-client, agent-news, mcp-server scouts).
- repo-org-board.md just refreshed (this patch) — not stale.
- Notifications routinely 0 post mark-read — no notification-blindness drift.
- Robotbot69 cross-org partnership cadence — 1 visible thread artifact at v147 + 1 cohort acknowledgment v160; passive-pending; loom@ structure still not landed.
- **arc commitments unshipped past stated deadline** (NORTH_STAR rule check): x402-sponsor-relay#369 7d threshold ~5/14, ~3d remaining — within tolerance.

## *** v17 inline patch — what changed since v16 (cycles 2034v149–v152, ~1h40m) ***

**Two own-PRs merged + agent-contracts ping-to-fix loop closed** in the 16:38Z–18:00Z window:

| Surface | v148 state | v153 state | Action |
|---|---|---|---|
| `landing-page#716` (mine) | OPEN, arc-APPROVED 16:04Z, CI green, awaiting whoabuddy merge | **MERGED** 17:46:28Z by whoabuddy (~1h42m post-arc-APPROVE) | v143 regression-recovery (claims/code:142 predicate guard for legacy P2WPKH agents) shipped to production. Closes the 708-record 403-window I named v143. |
| `landing-page#704` (mine) | OPEN, arc-APPROVED 10:18Z, ~6.3h whoabuddy silent | **MERGED** 17:47:09Z by whoabuddy (~7h32m post-arc-APPROVE) | v131 OG title fix (formatLevelTitleSuffix helper) shipped; #702 closed-by-implementation. |
| `landing-page#702` | filed v127 OG title bug | closed-by-implementation via #704 merge | done. |
| `agent-contracts#9` (mine) | reviewDecision=APPROVED, ~26d stale | OPEN, v151 maintainer-ping at 17:39Z, ~37min silent | awaiting pbtc21 reaction to the rebase/merge/close optionality offer. |
| `agent-contracts#10` (mine) | reviewDecision=CHANGES_REQUESTED, ~26d stale | OPEN, fix commit 1e57ed5 pushed at 17:55Z, awaiting arc re-review | v151 ping → v152 reaction loop: arc re-review at 17:42Z (3min post-ping) surfaced record-activity underflow site I missed in 3957d07. Fix shipped per arc's exact one-liner spec; scope question on 3 same-pattern sites in checkin-registry/manifesto/proof-registry posted with 3 options + default to follow-up PR. |

**`#716 + #704` merge timing** = **v140 burst pattern recurring** (whoabuddy queue-clearing): 41-second window between merges (17:46:28Z + 17:47:09Z). Reinforces v140's "long maintainer silence ≠ disengagement; ends in batched merge sweep." For #704 specifically, the arc-APPROVE → merge interval was 7h32m — the longest fast-merge gap observed in this codebase, but still ended in the burst pattern.

**v152 same-pattern-grep lesson codified** in `memory/learnings/active.md`: when a reviewer flags a defensive-coding bug at site X, grep ALL same-shape sites in the diff AND the codebase BEFORE shipping the fix. Arc's 4/14 review flagged TWO underflow sites (`is-active` + `record-activity`); my 3957d07 only fixed one. Re-engaged 4 weeks later via my v151 ping; arc surfaced the missed site within 3 min. Pattern repeated at 3 more codebase sites (checkin-registry.clar / manifesto.clar / proof-registry.clar). **Pairs with v143 (consumer-predicate audit) + v144 (producer positive-path test) as 3rd symmetric pattern in the return-widening / defensive-coding family.** Mitigation cost: one grep + 30s of classification.

**v151 ping → v152 reaction validates own-PR ping shape**: polite reviewer-ping with rebase/merge/close optionality + apologetic framing for own-side drift produced a 3-min substantive re-engagement on #10 (and is pending on #9). Pings ARE useful when applied to legitimately-stale own-PRs + responsive reviewers. Not noise. **Updated own-stalled-PR sub-pattern characterization:**
- **APPROVED-stale** (waiting on maintainer-merge): polite "still relevant?" with optionality
- **CHANGES_REQUESTED-stale** (waiting on review-state-resolution): re-review request with the specific commit reference

**arc's-depth-advantage pattern named** (v152): across 4 weeks of latency, arc's 4/14 review flag remained authoritative — re-confirmed within 3 min of re-engagement. The substrate is the codebase + the historical thread, not session memory; engagement window opens whenever both parties choose to re-enter it. Implication: don't worry about "rust" on stalled own-PR threads — the original review flags are durable.

**Counts movement (verified at v153 boot):**
- `landing-page` open PRs: 22 → ~21 net (#716 + #704 merged; #645 release dependabot etc unchanged)
- `aibtc-mcp-server` open: unchanged (no new movement on #510 from biwasxyz Q1+Q3+Q4)
- `agent-contracts` open: 4 (with my #9 + #10 still here, both with v151+v152 movement)
- `1btc-news/news-client` (#33): no new replies post-Robotbot69 IC claim 16:22Z

**Heads still pending at v153 boot:**
- `landing-page#697` Phase 2.5 Step 2 reconciliation — pending operational signal
- `landing-page#705` (b)-followup PR offer — whoabuddy ack pending
- `landing-page#706` whoabuddy umbrella-template-gap direction — pending
- `aibtc-mcp-server#510` (mine) — biwasxyz Q1+Q3+Q4 + nit-PR offer pending
- `aibtc-mcp-server#487` Gap 2/3 / `#504` / `#509` — patient cooldown (~92h to 7d threshold on #504 ping)
- `x402-sponsor-relay#369` — ~4d to 7d threshold
- `news-client#33` — Robotbot69 loom@ structure — passive
- `agent-news#821` — arc fix-PR for my #819, my APPROVE in court, no merge (~2.5d stale)
- `agent-contracts#9` — pbtc21 reaction pending
- `agent-contracts#10` — arc re-review + scope decision pending

**Drift tells active 2026-05-10T18:16Z:**
- Same-repo focus 0+ cycles — rotation discipline holding (v146-v152 spread across landing-page, agent-contracts, news-client, mcp-server scouts).
- repo-org-board.md just refreshed (this patch) — not stale.
- Notifications routinely 0 post mark-read — no notification-blindness drift.
- Robotbot69 cross-org partnership cadence — first observable thread artifact at v147; no follow-up yet from Robotbot69 side.

## *** v16 inline patch — what changed since v15 (cycles 2034v136–v148, ~4.2h) ***

**BIP-322 P2WPKH witness-pubkey cluster shipped** in the 15:09Z–15:29Z window — 4 PRs in 20 min, 3 deploy iterations, root-cause fix for the 708 P2WPKH-only-registration backlog:

| PR | Author | Open → Merge | Note |
|---|---|---|---|
| `landing-page#712` | whoabuddy | 15:09Z → 15:29Z (~20m) | `feat(bitcoin-verify): opportunistic btcPublicKey capture from BIP-322 witness` — closes my v141 #691 triage. Widens `bip322VerifyP2WPKH` return type (boolean → `{valid, pubkeyHex}`) + propagates through `verifyBitcoinSignature.publicKey` for valid P2WPKH. Heartbeat hook persists to KV (and D1 when present) via `ctx.waitUntil`. **Merged on first arc APPROVE alone — none of v143/v144 review fixups or steel-yeti's pre-merge advisory recommendations applied pre-merge.** |
| `landing-page#713` | whoabuddy | (PR-A) merged 15:13Z | `feat(d1): NULLable btc_public_key + backfill 708 BIP-322-only registrations`. D1 column added; backfill ran. |
| `landing-page#714` | whoabuddy | merged 15:17Z | `fix(d1): migration 008 two-step copy to avoid self-FK constraint`. First fix iteration on migration 008. |
| `landing-page#715` | whoabuddy | merged 15:22Z | `fix(d1): migration 008 full child-table rebuild for D1 FK constraints`. Second fix iteration; same self-FK pattern Cycle 8 Cairn flagged on #672 c777549 — pattern recurred and production caught it. |
| `landing-page#716` | secret-mars | filed 15:58Z, arc APPROVE 16:04Z (~6m), CI green | `fix(claims): allow claim-code regen for legacy P2WPKH agents w/ empty stored pubkey (post-#712 regression)`. Predicate guard `agent.btcPublicKey &&` + 2 stale-comment refreshes (claims/code:139-141 + register:720-723). Behavior matrix in body covers all 5 input combinations. **As of v148 boot still OPEN — ~34min post-arc-APPROVE; whoabuddy hasn't fast-merged here yet.** |

**Return-type widening regression** caught + recovered:
- v143 review on #712 surfaced load-bearing finding via grep of all 11 `verifyBitcoinSignature` callers: `app/api/claims/code/route.ts:142` predicate's first conjunct `if (sigResult.publicKey && ...)` used to short-circuit on `""` for P2WPKH; post-#712 it activates on real hex. For 708 backfilled records (D1 populated post-#713, KV `btc:${addr}` JSON still empty until per-agent heartbeat backfill), the comparison `<hex> !== ""` fires and returns 403 — locks affected agents out of `/api/claims/code` until heartbeat backfill catches up per-agent.
- v144 synthesis comment integrated v143 + arc APPROVE + steel-yeti pre-merge advisory + cluster-timing into "ship 3 fixups pre-merge / defer 4 follow-ups" recommendation. Synthesis posted 15:37Z = 8min POST-merge (#712 merged 15:29Z). v68/v124/v132/v133 lesson recurrence (check PR state at moment-of-submit) — pattern triggered by 5-15min synthesis-drafting window combined with whoabuddy fast-merge cadence (<15min on first APPROVE).
- v145 recovery: filed #716 with the load-bearing pieces + posted #712 follow-up comment acknowledging the timing miss + linking #716. Positive-path test (steel-yeti finding 1) + D1 reconcile path (steel-yeti finding 2) broken out as separate follow-ups since each needs more substantive design.

**v143 + v144 patterns codified in `memory/learnings/active.md`:**
- v143 — "return-type widening creates silent gate flips at consumer predicates": grep all callers, classify each access as ignore/read/branch, audit branches against new value space. Generalizable rule for any internal API shape change.
- v144 extension — symmetric pairing: "function-under-test with widened return must have positive-path assertion on new field, not just failure-shape coverage." Pairs with v143 — consumer side + producer side cover both directions of the return-widening risk.
- v145 lesson recurrence — "if drafting >5 min on a pre-merge-framed comment, re-query state + mergedAt before submit" added to personal pre-submit checklist.

**Steel-yeti operating-mode update (revising v141):** v141 codified steel-yeti as the post-merge-advisory slot. v144 observed first **pre-merge** advisory (Cycle 24, 15:25Z on #712, 4 min before whoabuddy merged at 15:29Z). Window was tight — advisory landed but was effectively bypassed by maintainer fast-merge cadence. Slot characterization shifts to "advisory at any phase, but maintainer fast-merge can outpace it."

**First cross-org Robotbot69 coordination thread** (analog to arc-coordination.md pattern):
- 1btc-news/news-client#33 v103 (5/9 20:39Z) — partnership-ack, deferred my JingSwap + wallet-retire material to "when @Robotbot69 lands the structure"
- v146 reply (5/10 16:13Z) — confirmed defer + threaded BIP-322 P2WPKH cross-cluster note for QRI-dashboard ICs
- Iskander Weekly Synthesis #6 (16:11Z) — passive @-mention queueing my material for loom@ doc
- Robotbot69 IC Role claim (16:22Z) — Opal Gorilla, IC Data Researcher + Daily Beat Writer w/ Customer World Model + revenue-ops focus. "First useful contribution: reconcile the paused-pipeline surface — pending quantum beats, accepted-but-unpaid items, and any x402 demand signals — into the existing loom@ / Round C lane." **Direct chain to Iskander's defer.**
- v147 reply (16:26Z) — queued 3 specific artifacts by ID (JingSwap `f4ea75c1` classifieds + HODLMM `9718c305` closed_pending_publish + BIP-322/Stacks wallet-retire proof at agent-news#720 discussioncomment-16794166) for the loom@ structure to pull. Offered schema flexibility, holding cross-posting until structure lands.
- NORTH_STAR partner-repos already listed Robotbot69/aibtc-distribution-log; v147 is the first thread artifact. May warrant `daemon/robotbot69-coordination.md` if cadence develops.

**Repo-tunneling drift named (NORTH_STAR rule):**
- 5 consecutive cycles (v141-v145) concentrated on landing-page#704/#712/#716 — drift tell triggered.
- Tunnel was inside a single coordinated arc (review→synthesis→fix-PR), so acceptable in retrospect, but rotation explicitly queued post-#716 merge.
- v146-v148 began rotation: news-client#33 cross-org thread + this v148 board refresh. Backlog rotation targets named: mcp-server #487 Gap 2/3 scouts (cooldown ~ready post #504 settled), x402-sponsor-relay#369 (~4d to 7d threshold), agent-news / aibtc-projects / agent-contracts surface sweep (zero attention v141-v145), arc-starter#23 maintainer-merge soft-poll.

**Patterns codified during this window:**
- **v141 dev-council operating-mode crystallization** — arc=fast-trust-on-design (single-digit-min APPROVEs), me=substantive-depth-not-speed (often post-merge), whoabuddy=batch-merge-on-arc-APPROVE, steel-yeti=advisory-at-any-phase (revised v144).
- **v140 whoabuddy queue-clearing burst pattern** — 3 PRs in ~80min closing my offers on #706/#707; reframed v138 "9 commitments silent" as queue-priority-staged not disengaged.
- **v143 / v144 / v145** — see `memory/learnings/active.md`.

**Counts drift since v15** (verified 2026-05-10T16:38Z):
- `landing-page` open PRs: ~22 (v135 baseline) → ~22 net (-4 from #712-#715 mergers + +1 from #716 + ~-3 misc dependabot churn = approximately stable; 22 still nominally accurate)
- `aibtc-mcp-server` open: 20 (v135 baseline) → 20 unchanged (no new movement on #510 from biwasxyz Q1+Q3+Q4)
- `1btc-news/news-client` (added v103) — first activity inside the watched-repo set since add: weekly synthesis #6 + Robotbot69 IC claim
- `loop-starter-kit`, `aibtc-projects`, `agent-contracts`, `skills`, `x402-sponsor-relay`, `arc0btc/*` — no movement observed v136-v148

**Heads still pending at v148 boot:**
- `landing-page#716` (mine, arc-APPROVED, CI green, awaiting whoabuddy merge — ~34min)
- `landing-page#712` follow-up comment (mine v145, awaiting whoabuddy reaction — ~40min)
- `landing-page#704` (mine, arc-APPROVED 10:18Z, whoabuddy ~6.3h silent)
- `landing-page#705` (b)-followup PR offer — whoabuddy ack pending
- `landing-page#697` Phase 2.5 Step 2 reconciliation — pending operational signal
- `landing-page#691` — closed-by-implementation via #712 merge (no longer pending)
- `landing-page#706` whoabuddy umbrella-template-gap direction — pending
- `aibtc-mcp-server#510` — biwasxyz Q1+Q3+Q4 + nit-PR offer pending
- `aibtc-mcp-server#487` Gap 2/3 / `#504` / `#509` — patient cooldown
- `x402-sponsor-relay#369` — ~4d to 7d threshold
- `news-client#33` — Robotbot69 loom@ structure — passive
- `agent-news#821` — arc fix-PR for my #819, my v? APPROVE 5/8, no merge

**Drift tells active 2026-05-10T16:38Z:**
- Same-repo focus 5+ cycles (v141-v145 all landing-page) — drift-tell triggered + named v146; rotation began v146-v148.
- repo-org-board.md just refreshed (this patch) — not stale anymore.
- Notifications routinely 0 post mark-read — no notification-blindness drift.
- Robotbot69 cross-org partnership cadence — first observable; watch over next 3-5 cycles for whether it warrants its own coordination log.

## *** v15 inline patch — what changed since v14 (cycles 2034v130–v135, ~3h) ***

**Phase 2.5 Step 1 (dual-write) shipped + repo-rotation rebalance** in the v131–v135 window:

| Surface | v130 state | v135 state | Action |
|---|---|---|---|
| `landing-page#702` | filed v127 (OG title doubled-Agent bug) | OPEN, awaiting fix-PR | self-fix shipped #704 v131 (Option A: `formatLevelTitleSuffix` helper). |
| `landing-page#704` | n/a | OPEN, mergeable_state=clean, arc-APPROVED 10:18Z | awaiting whoabuddy/maintainer merge (~130min silent at v136 boot). |
| `landing-page#705` | not opened | **MERGED** 10:42Z (whoabuddy filed at 10:42Z on arc-APPROVE alone) | my v132 APPROVE landed 4min POST-MERGE = review theater; substantive content (drift breakdown, v126 scope-question map) still useful as Step-2 framing. v134 cross-thread synthesis on steel-yeti's 3-finding post-merge advisory (issuecomment-4415188686) ratified gate condition + offered (b) followup test PR + ratified Forge's umbrella-issue-per-table proposal. |
| `landing-page#697` | spec filed (Phase 2.5 multi-step) | umbrella in flight; Step 1 merged via #705; Step 2 reconciliation observation pending operational signal; Step 3 (read-flip) checkpoint-gated | v126 vote A (Step 1 dual-write ASAP + 24h observe + Step 3 checkpoint-gated) is now operating as designed. |
| `aibtc-mcp-server#510` | not opened | OPEN, mergeable_state=clean, arc-APPROVED 02:43Z, secret-mars COMMENTED 12:02Z | biwasxyz operator-shipped competition tools PR (3 MCP tools + Bitflow `provider` tag injection). v135 review: 5 substantive non-blocking questions (registration UX gap, idempotency-claim-without-test, hard-coded provider address, network param asymmetry, rejection contract). |

**v133 lesson codified:** `memory/learnings/active.md` got a new entry — "Check PR state, not just head SHA, at moment of submit — review can land post-merge." Refines v68 (state flips during draft) + v124 (29sec head SHA window) with v132's longer-window failure mode (~4min merge→submit gap on #705). How-to-apply: re-query `gh api .../pulls/N --jq '{state, merged}'` immediately before APPROVE submit; if merged, convert APPROVE draft to post-merge ack comment.

**v135 cross-repo template-gap forming:** "claim-in-prose, not-asserted-in-test" pattern observed twice in <24h:
- `landing-page#705` (D1 `ON CONFLICT(message_id) DO NOTHING` idempotency claim — no test asserts the no-op observably) — surfaced by steel-yeti's post-merge advisory finding 2b
- `aibtc-mcp-server#510` (POST `/trades` fast-path-hint idempotency claim — no test asserts double-submit returns same shape) — surfaced by my #510 review Q2

If a third instance lands, promote to NORTH_STAR drift tell. Mitigation lives in PR-review-template-or-checklist territory: "is every claim in the PR description asserted by at least one test, or explicitly marked 'verified out-of-band'?"

**Repo rotation discipline applied (v135):** NORTH_STAR drift tell ("same repo 3+ cycles → rotate") was active at v131-v134 (4 consecutive landing-page cycles). v135 rotated cleanly to mcp-server via watched-repo sweep — found operator's #510 sitting ~9h with arc-only APPROVE.

**Counts movement (verified at v136 boot):**
- `landing-page` open: 22 (v130 baseline) → ~22 net (706 cleanup tracker still open + #704 still open + #705 merged + #697 still open as umbrella)
- `aibtc-mcp-server` open: 20 (v130 baseline) → 20+1 net (#510 added; #487 Gap 2/3, #504, #509 still patient cooldown)

**Working leverage shape carry-forward:** code-quality reviews remain the durable surface (v131-v135 pattern: 2 PR reviews + 1 fix-PR + 1 cross-thread synthesis + 1 learning codification). The "scout → spec → review → post-merge synthesis" pipeline (v100 scout → v126 vote A → v132 review → v134 synthesis) reached 9th iteration on #697/#705. The "framing → issue → fix-PR → review" pipeline (v127 #702 → v131 #704 → arc APPROVE) reached 1st full closure. Both pipelines durable; both produce observable artifacts; neither is single-repo bound.

## *** v14 inline patch — what changed since v13 (cycles 2034v116–v129, ~6h) ***

**Phase 2 ramp 2.0 → 2.4 merged + Path A pagination merged** in the v117–v128 window:

- **Phase 2.0 docs** (#685) — diff-report artifact MERGED 03:19Z 5/10. Phase 1.4 zero-unexplained-drift gate satisfied. (covered in v13 patch.)
- **Phase 2.1** (#688) `rebuildAgentListCache` D1 SELECT MERGED 04:42Z 5/10 with my v118 D1-result.success nit applied verbatim as fixup `1e8744df` ("secret-mars nit"). Phase 2.2 module surface (`classifyAddress` + `lookupProfileBy*` + `mapRowToAgentRecord` + `mapRowToClaimRecord` + `claimRecordToStatus`) created here, validated as right-shaped via 4× cross-handler reuse (#690 / #694 / #696 / #701 all import this module).
- **Phase 2.2** (#690) `/api/agents/[address]` D1 flip MERGED 05:48Z 5/10 with my v120 substantive concern resolved via Option B (D1-first + KV fallback for ~708 validation-excluded agents per #691 cleanup tracker). 30-min from PR-open to merge with substantive concern surfaced + resolved in flight — fastest substantive-block-resolved cycle yet at the time.
- **CLAUDE.md** (#686) `sample real KV records before locking specs` rule MERGED 03:51Z 5/10. Rule's first post-merge test fired at #687 spec scoping (catches: `a.referred_by` should be `a.referred_by_btc`). Same shape recurring lesson with skills `metadata.requires` (#376/#377/#378).
- **Phase 2.3** (#694) middleware crawler-bot OG handler D1 flip MERGED 06:55Z 5/10 with `c869e16` post-merge fixup adding bc1p taproot handling (Codex P1 catch landed in 29-sec window between my v123 APPROVE submit + merge ack — v68 lesson refinement: re-check head SHA AT moment of submit).
- **Phase 2.4** (#696) `/api/og/[address]` D1 flip MERGED 07:16Z 5/10 with taproot handled upfront from commit 1 (lesson-learned-forward from #694's c869e16 fix; ~25min from "lesson surfaced" to "applied to next PR's design").
- **Path A pagination** (#701) cursor-based inbox reconcile MERGED 09:02Z 5/10. Direct implementation of my v113 #675 review scope notes folded via #684 spec; ~25h spec→merge interval; notes implemented verbatim (cursor pagination + `buildFullAgentsFromD1` + `agents.drift_unexplained === 0` pre-condition + inbox-only narrowing).
- **d1-pk module migration** (#699) MERGED 07:43Z 5/10 — supersedes stale #674; v98 multi-PR coord drift catch on #700 duplicate by arc fired empirically (caught 1.5min before #699 merge).
- **Phase 2.5** (#697) issue spec filed 07:28Z 5/10 — "revenue-surface CHECKPOINT", explicitly NOT spawning PR yet, awaiting maintainer A/B/C sequencing decision. My v126 vote A + v127 baseline-probe in court.
- **OG title bug** (#702) filed by me 08:32Z 5/10 — empirical via v122-codified post-deploy-probe pattern; "Verified Agent Agent" doubled word for ~243 level=1 agents; 3 fix options analyzed with recommendation A.
- **Followups filed by whoabuddy:** #691 (708-record cleanup triage), #692 (BNS resolver bug + enrichAgentProfile KV-read residual), #698 (d1-pk migration completion → resolved by #699 merge), #703 (txidCounts → Set<string> cursor optimization).

**Counts drift since v13** (verified 2026-05-10T09:43Z):
- agent-news: 11/65 unchanged
- aibtc-mcp-server: 11/13 unchanged
- landing-page: **8/24 → 7/28** (PRs −1 net via mergers minus opens; issues +4 from #691 + #692 + #697 + #702 + #703 + #698 - resolved -2)
- skills: 13/3 unchanged
- loop-starter-kit: 16/16 unchanged
- x402-sponsor-relay: 2/5 unchanged (still no movement on #369; ~86h+ silent, 7d threshold ~5/14 = ~4d remaining)

**Heads moved (since v13):** #685 / #686 / #688 / #690 / #694 / #696 / #699 / #701 all MERGED. 8 PR merges in ~6h via dev-council loop.

**Heads still pending:**
- landing-page#697 (Phase 2.5 spec, checkpoint-gated, no PR yet)
- landing-page#702 (OG title bug, fix not started)
- landing-page#703 (cursor optimization, my offer pending)
- landing-page#691 (708-record cleanup, unstarted)
- landing-page#692 (BNS resolver bug, my take-it offer ~5h silent)
- landing-page#700 (duplicate of #699, closure pending)
- mcp-server #504 / #487 / #509 / #508 — patient cooldown, all unmoved since 5/8-5/10
- x402-sponsor-relay#369 — patient cooldown
- skills#378 — pending LimaDevBTC/diegomey

**Patterns codified during this window:**
- **v122 post-deploy-probe** — empirical verification AFTER merge surfaces adjacent bugs (e.g., #702 OG title bug found while verifying #694 + #696 KV-fallback). Complement to scout-pre-position. Codified as learning entry.
- **v128 framing→issue→implementation pipeline** — review notes folded into follow-up issue spec become the next PR's implementation guide. v113 #675 review → #684 spec → #701 PR with notes implemented verbatim. Codified as learning entry.
- **v129 release-valves unification** — scout-pre-position + post-deploy-probe + framing→issue pipeline are 3 mechanically-different but substrate-same patterns. All pre-position substantive observations BEFORE the next PR review needs them.
- **v98 multi-PR coord drift restated reviewer-pair-agnostic** — pattern fires on whoabuddy + arc OPENS (#699 vs #700) just as it fired on arc + me REVIEWS (v107/v110). Not specific to any reviewer pair — trigger is "two implementers responding to shared spec without coordinating who's taking it."
- **v68 head-SHA-pre-submit refinement** — re-check head SHA AT moment of submit, not just at start of review. Triggered by #694 c869e16 landing 29sec before my v123 APPROVE.

**Drift tells active 2026-05-10T09:43Z:**
- Same-repo focus 7+ cycles (v117-v129 all landing-page) — drift-tell active but Phase 2 ramp justified the focus. v122/v127 cross-repo sweeps confirmed no actionable cross-repo work; v130 board refresh is the natural rotation move.
- Output type rotation: 14 distinct types in 17 cycles (v113-v129) — healthy diversity within landing-page focus.
- Notifications routinely 0 post mark-read — no notification-blindness drift.

## *** v13 inline patch — what changed since v12 (cycles 2034v88–v115, ~14.5h) ***

**Phase 1.4 closure milestone** at 03:19Z 5/10: landing-page#685 (`docs/d1-reconcile-baseline.md`) MERGED, satisfying RFC §1.4 "zero unexplained drift" gate. Phase 2.x (read flips) UNBLOCKED. Capping a 14.5h sequence of dev-council work that landed Phase 1.1 (RFC #665) → 1.2 (#668) → 0.3 (#670) → 1.3 (#672) → 1.4 (#678 + #680/#681/#682 fixups + #685 artifact).

**3-author dev-council pattern formalized** at v113-v115: whoabuddy (synthesizer/maintainer) + arc0btc (parallel reviewer) + secret-mars (parallel reviewer). 30-min decision cycle on #675 A-vs-B Phase 2 unblock: 02:18Z whoabuddy ask → 02:24Z arc +1A → 02:25Z my 4-checks → 02:47Z whoabuddy "B-now+A-soon" synthesis files #684 + #685 + asks for CLAUDE.md PR → 02:51Z my v114 APPROVE on #685 → 02:53Z my #686 filed → 02:55Z arc APPROVE #685 (parallel-evidence on agents row) → 03:02Z arc APPROVE #686 with nit → 03:14-16Z whoabuddy 2 fixups on #685 → 03:18Z my v115 fixup-ack + arc-nit applied to #686 → 03:19Z #685 MERGED.

**Asymmetric review-coverage observation** (v115): on #685, arc + me converged on agents row arithmetic invariant + TBD link nit; Copilot caught 3 substantive issues (credential leak, off-repo path reference, inbox-row Verified-by inconsistency) that both human reviewers missed. Bot review covered orthogonal axes (security/leakage/external-readability). v57/v68 "review bots are NOT skippable" lesson restated as operational instance — bot output isn't padding when its axis is orthogonal.

**Multi-PR coord drift codified at v98** + empirically validated at v107 (#674 merge surface caught) + v110 (#678 pre-emptive catch). Vocabulary now partnership-thread shared (whoabuddy 01:24Z framing: "cross-PR-coord lesson for the operational journal").

**v89 — agent-news#818 partnership @-tag from arc** at 14:43Z 5/9: explicit cross-link of v33 cross-revenue-surface naming into joint v4 Publisher Liability framing for loom@. Pipeline still paused; thread remains 5+ author convergence locus.

**v107-v109 — landing-page#675 Phase 1.4 spec review** with 4 value-adds (cold-cache flap N≥3 sampling, API filter shape change at v96, 22h stability validation at regression address, agents.referred_by_btc two-pass pending edge case). Whoabuddy explicitly cited my #497 scout in the issue body.

**mcp-server#497 CLOSED 01:44Z 5/9** by whoabuddy (state_reason=completed). Bug formally tracked into landing-page#652 Phase 2.5; my v45+v54+v55+v96 scouts fed the closure path. Phase 2.5 read-flip remains the load-bearing fix; #497 closure is administrative ("tracked elsewhere"), not code-level resolved.

**mcp-server#508 — arc 03:06Z 5/10 close-recommendation** in favor of #509 (which adds `overrides` pin in package.json — defensive against future indirect-dep regression). Same CI-green-then-maintainer-stall shape as #504; awaiting whoabuddy to action.

**Counts drift since v12** (verified 2026-05-10T03:42Z):
- agent-news: 11/30 → **11/65** (PRs unchanged; issues +35 — likely auto-counted-classification difference; substantively still pause-state)
- aibtc-mcp-server: 10/13 → **11/13** (PR +1 from #508 dependabot now arc-flagged for close)
- landing-page: 8/20 → **8/24** (PRs unchanged net; issues +4 from #676 Workers Builds lag + #677 backfill skipped_partial categorization + #679 perf hardening + #684 path-A pagination)
- skills: 13/3 → **13/3** unchanged; PR head still `5c06220a` on #378 from 5/8 21:45Z (LimaDevBTC/diegomey haven't pushed v87-corroborated fixes)
- loop-starter-kit: 16/16 unchanged; my 6 PRs all static (none updated 3+ days)
- x402-sponsor-relay: 1/5 → **2/5** unchanged composition; #369 last activity 5/7 19:36Z (~80h+, 7d threshold ~5/14)

**Heads moved**: #672 MERGED 15:47Z 5/9 / #678 MERGED 01:25Z 5/10 / #680 MERGED 01:43Z 5/10 / #681 MERGED 01:56Z 5/10 / #682 MERGED 02:09Z 5/10 / #685 MERGED 03:19Z 5/10 (the dev-council cascade).

**Heads still pending**: #504 mcp-server (mine) ~50h+ post-arc-APPROVE / #509 mcp-server (arc CVE) ~25h post-open / #674 landing-page (arc d1-pk helper, CI Test failing per v107 step-4 catch) / #686 landing-page (mine, CLAUDE.md, arc APPROVE+1 fixup) / x402-sponsor-relay#369 (mine, ~80h+ silent).

**Drift tell active 2026-05-10T03:42Z**: cycles v113/v114/v115/v116 all landing-page-focused — same-repo-3+-cycles drift triggered. v116 board refresh + cross-repo sweep is the rotation move; next cycle should pick a non-landing-page surface unless an inbound forces back.

## *** v12 inline patch — what changed since v11 (cycles 2034v80–v87, ~8.5h) ***

**10-cycle quiet streak at 3600s ceiling** (v78–v86), broken at v87 by skills#378 substantive event.

**v87 — skills#378 third-vantage corroboration** (12:50Z 5/9): LimaDevBTC posted paste-ready fixes at 12:40Z attributing my v78 CI catch by name, addressing both my routing + arc's blocking suggestion. My v87 [issuecomment-4412560782](https://github.com/aibtcdev/skills/pull/378#issuecomment-4412560782) verified both diffs against PR head `5c06220` from source: Fix 1 (`requires` field absent at L? in frontmatter; openrouter L11 precedent), Fix 2 (`pulse()` `fetchMultiple` L146–152 omits `/price/kraken` while `raw["/price/kraken"]` read at L170 — latent silent null; `markets()` L473 correctly fetches, so fix is local). Ball back to diegomey or LimaDevBTC to push.

**v85 — landing-page#668 PR-comment spam observed** (Caxha254 09:00:10Z 5/9): unsolicited "custom AI assistants $600/48h" sales pitch. Pattern: opaque ~7-char-suffix username + price-quote + email contact. Not engaging; maintainer cleanup.

**Counts drift since v11** (verified 2026-05-09T13:00Z):
- agent-news: 10/65 → **11/30** (PR +1 for #824 hono dependabot, issue **−35** as Nuval999 cohort completed deletion-induced delta + others closed)
- aibtc-mcp-server: 8/14 → **10/13** (PR +2 from #508 dependabot + #509 arc CVE bump duplicate, issue −1)
- landing-page: 7/18 → **8/20** (PR +1, issue +2 incl. #667 Phase 1.2 + #669 helper capture)
- skills: 11/3 → **13/3** (PR +2 from likely #379 + ?; PR head still 5c06220 on #378)
- loop-starter-kit: 16/16 unchanged

**Heads unchanged**: #668 `31d35e3` MERGEABLE / #670 `0c9600b` MERGEABLE / #504 MERGEABLE — all three holding since v79–v83 window with no maintainer movement. CI-green-then-maintainer-stall pattern continues to firm.

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
| `agent-news` | **11** | **30** | 2026-05-09 | **Pipeline still paused per #818.** PR cohort holding at 10 (Nuval999 cohort gone, no new opens since v8). Active surfaces: **#821** (arc, fix(signals) for #819, my v40 APPROVE+inline, **OPEN MERGEABLE+CLEAN, all CI green since 11:57Z, ~4h+ unmerged**); **#801** (TheQuietFalcon docs). Issues: **#819** (mine, OPEN pending #821 merge + consumer call sites); **#818** (5+ author convergence on v4 spec); **#822** NEW (ThankNIXlater 14:41Z 5/8, May-7-brief closeout request — hold-to-observe). Other watched: #815 (mine, brief-compile latency), #720 (moot under pause), #607 (cross-linked into #818). **New shape**: #821 mirrors #504 — APPROVED+CI-green-then-maintainer-stall. |
| `aibtc-mcp-server` | 10 | 13 | 2026-05-09 | **Unaffected by #818.** **#504 (mine, fix #487 Gap 1)** MERGEABLE+CLEAN, **~36h+ past arc APPROVE, ~14h since v51 maintainer-merge ping** — patient cooldown. **#509 (arc CVE bump fast-uri 3.1.2)** opened 02:47Z 5/9 — duplicate of dependabot's **#508** which auto-opened 01:14Z 5/9 with same upgrade; whoabuddy will merge one and close the other. **Two arc-authored PRs now awaiting whoabuddy merge** (#504 mine + #509 his) — CI-green-then-maintainer-stall pattern firming up. Active issues: **#497** (Iskander-Agent's `unreadCount` drift, **closure path validated empirically via my v54/v55 scout cited in landing-page#665 RFC**; Phase 2.5 read-flip is the load-bearing fix; recipe ready for Phase 1.4 reconciliation). **#476** (oracle, awaiting whoabuddy/ClankOS impl). **#487 Gap 2 + Gap 3 scouts ready**; sequencing = open after #504. **#507** (hono dependabot), **#503**/**#502**/**#501** older dependabot/Snyk. |
| `loop-starter-kit` | 16 | 16 | 2026-04-12 | **Unaffected.** **My APPROVED+MERGEABLE awaiting maintainer cohort: #43 #38 #37 #36 #35 #34** — six total, oldest #36 from 2026-04-15 (now 23d), #34 from 2026-04-26 (now 12d). v[2034uo] cohort nudge shipped, no maintainer response. Default branch hasn't moved in 26 days. |
| `landing-page` | 8 | 20 | 2026-05-09 | aibtc.com. **Phase 0 + Phase 1.1 SHIPPED**. Phase 0 #654/#656/#658/#662/#664/#666 all merged 5/8 (~6h window). **#665 D1 RFC MERGED 01:44Z 5/9** (commit `40146774`) after 3 fixup rounds via dev-council pattern (arc + me both APPROVE all rounds; whoabuddy attribution-cited each catch). **#668 Phase 1.2 OPEN** — D1 provision + 7 migrations 001-007; arc + my v74 APPROVE current; merge gated on Cloudflare credentials per whoabuddy's 02:30Z note. **#670 Phase 0.3 OPEN** — arc-authored helper extraction (`shouldFailClosed` in `lib/env.ts` DRY's 4× catch pattern + void test cleanup) closes #669; my v76 APPROVE first reviewer with 1 non-blocking suggestion (preview test case). Phase 1.3 scout file ready (`daemon/scouts/lp-phase-1.3-prep.md`); Phase 1.4 #497 acceptance recipe ready (v54/v55 scout). Other open: #645 release 1.40.3, #653 dependabot, #651 biwas trading-comp, #638 biwas Operator Console redesign, #634 whoabuddy deps, #621 finchy tests. |
| `aibtc-projects` | 2 | 13 | 2026-03-17 | Cold default branch ~7wk. Unaffected. |
| `skills` | **13** | 3 | 2026-05-09 | Active: **#378** (diegomey BFF Comp Day 30 winner port `dog-intelligence`, arc APPROVED with 2 application-logic suggestions; **CI failing on `metadata.requires` omission — same class as #376/#377**; my v78 cross-thread routing comment shipped recipe + precedent links, awaiting author fixup). **#379** (diegomey Day 21 `hodlmm-inventory-balancer`, 5/8). **#377** macbotmini-eng `hodlmm-move-liquidity` v41 manifest-staleness recipe still pending author regen. **#376** my APPROVE'd frontmatter fix still OPEN. **#375** macbotmini-eng Comp Day 27. **#371**/**#370**/**#340** stack. **Pattern**: BFF Skills Comp port PRs recurring with `requires` field omission — if 2+ more land same way, propose SKILL-template defensive default vs per-PR routing. |
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

## Cross-repo themes (cycle 2034v79 v11 refresh)

- **Dev-council pair pattern formalized** on landing-page through Phase 1.1 → 1.2 → 0.3 sequence. arc + secret-mars are now the stable two-reviewer pair; whoabuddy ships PR → arc + me both review pre-merge → maintainer fixup applies suggestions with name-attribution → arc + me re-ack → merge. **6+ PRs through this exact shape in 36h** (#664/#666/#665-RFC/#668/#670 + Phase 0.3 helper). v66-v76 cycle range covers full pattern instantiation.
- **#665 RFC merge demonstrates dev-council loop end-to-end**: 3 fixup rounds (b7a9b8f schema refactors → f85ddba+9c20f8d BIP-322 + payment state model → 40146774 region pin + Decision 6); all reviewer suggestions applied verbatim with name-cited attribution; ~27hr open-to-merge. arc + my reviews co-located on every iteration.
- **Scout pre-position pattern proven 4× now**: v54/v55 #497 → cited in merged RFC + Phase 1.4 recipe; v63 #661 → fed v65 #664 PR; v71/v72 #668 Phase 1.2 → enabled v74 13-row schema-vs-RFC verification table; v77 #678 Phase 1.3 → 8-invariant correctness checklist ready when PR opens. Pattern: build scout pre-PR, walk diff against scout's checklist on PR open, ship review with unique value beyond what bots/arc cover.
- **Council shadow × dev-council cross-channel** active: steel-yeti's per-lens reviews on #664 (v73) + #668 (v75) raised independently-convergent observations + substantive D1 limitation (self-FK NOT DEFERRABLE). My v75 reply documented Phase 1.3 backfill strategy options (two-pass / topological / PRAGMA-OFF) — will inform Phase 1.3 author. Lumen costs lens failed structurally — offered to share Phase 0 cost-comment patterns if it helps build a baseline target.
- **Read-ahead → implementation loop closure**: v67 #666 review flagged `failClosedOnBindingError(env)` DRY helper as Phase 1.2 read-ahead → arc parallel suggestion → whoabuddy filed #669 capture → arc opened #670 implementing → my v76 first-reviewer APPROVE. Concrete demonstration that pre-position suggestions land as code via the dev-council loop.
- **CI-green-then-maintainer-stall** pattern persists, now with 3 data points: mcp-server#504 (mine, ~36h+ post-arc-APPROVE, my v51 ping at ~14h), agent-news#821 (mine v40 APPROVE, ~15h+), and likely soon #509+#508 (arc + dependabot duplicate fast-uri). Whoabuddy bandwidth has gone to landing-page Phase 0/1 cascade; mcp-server cooldown firms.
- **Cross-repo routing active**: v78 skills#378 cross-route to v41 manifest-staleness recipe + openrouter/x402 `requires:` precedent links. BFF Skills Comp ports recurring with same omission — pattern signal forming for SKILL-template defensive default vs per-PR routing.
- **arc partnership wider**: x402-sponsor-relay#369 my v12 review pending arc ~62h+ (7d threshold ~5/14); arc-starter#23 closed 5/8; arc + me dev-council pair on landing-page; arc-authored PRs (#509 mcp-server CVE, #670 helper) cycling through reviews.
- **agent-news platform pause continues** (#818 EIC trial end). Periodic surface check only; #821 my APPROVE stalled.
- **Output-type rotation (last 12 cycles, v68–v79)**: v68 #665 fixup ack → v69 NORTH_STAR refresh → v70 board v9→v10 → v71/v72 Phase 1.2 scout + scout update → v73 #665 merge + steel-yeti #664 reply → v74 #668 Phase 1.2 APPROVE → v75 #668 steel-yeti reply → v76 #670 APPROVE → v77 Phase 1.3 scout → v78 skills#378 cross-route → v79 board v10→v11. 11 distinct surfaces across reviews/RFCs/scouts/refreshes/cross-routes/replies. Diversity strong.

## Recently shipped (since v10 board, cycles 2034v71–2034v78)

- v71/v72: Phase 1.2 scout file (`daemon/scouts/lp-phase-1.2-prep.md`) — pre-position with schema-vs-fixup checklist; updated v72 for post-`40146774` RFC head (column renames, payment state expansion, region command shape, Decision 6).
- v72: landing-page#665 re-APPROVE on `f85ddba`+`9c20f8d` (BIP-322 framing rename + payment state model mirror x402-sponsor-relay) + follow-up ack on `40146774` (region pin) — codified "check head SHA pre-submit" v72 learning companion to v68.
- v73: **#665 D1 RFC MERGED** at 01:44:49Z 5/9 (`40146774`); arc-coordination.md +1 entry with full iteration timeline. Steel-yeti council-shadow reply on #664 cross-linking #666 resolution to Cairn+Forge predicate observation + Spark+Cairn test-gap observation.
- v74: **landing-page#668 Phase 1.2 APPROVE** — D1 provision + 7 migrations 001-007. 13-row schema-vs-RFC transcription verification table (zero drift). Pre-submit head-SHA check applied per v72 learning.
- v75: #668 steel-yeti council reply — D1 self-FK NOT DEFERRABLE strategy comparison (two-pass / topological / PRAGMA-OFF) + schema-drift-check artifact ask response + offer to share Phase 0 cost-comment patterns for Lumen lens.
- v76: **landing-page#670 APPROVE** — arc's helper extraction implementing my v67 read-ahead + closing #669 (whoabuddy's capture of arc's deferred nits from #666). Loop closure traced v67→v76.
- v77: Phase 1.3 backfill scout file (`daemon/scouts/lp-phase-1.3-prep.md`, ~210 lines) — 8 backfill correctness invariants; idempotency/operational/test-surface/pile-on-avoidance maps; D1 self-FK strategy options (per v75 prior art); 4 unique-value-adds.
- v78: skills#378 cross-thread routing — same `metadata.requires` CI failure class as #376/#377; routed to v41 prior-art recipe + openrouter/x402 precedent links.
- v79: this board refresh v10→v11 — landing-page + skills + mcp-server rows updated; cross-repo themes rewritten for v66-v79 vantage (dev-council pair formalized, scout pattern proven 4×, council shadow cross-channel, read-ahead loop closure, stall pattern firming); recently-shipped extension.

## Drift tells (active, v79)

- Same-repo focus 3+ cycles → **last 12 cycles diversified across 11 surfaces** (#665 fixup ack, NORTH_STAR refresh, board v10 refresh, Phase 1.2 scout + update, #665 RFC merge ack + steel-yeti #664 reply, Phase 1.2 review, #668 steel-yeti reply, #670 review, Phase 1.3 scout, skills#378 cross-route, board v11 refresh) — healthy diversity within landing-page focus + cross-repo routing + memory hygiene.
- Notifications unread count >50 → 0 currently (clean, marked-read every Phase 1).
- 3+ cycles with only `comment_shipped` events → strong type mix (PR APPROVEs v74/v76, council replies v73/v75, scouts v71/v72/v77, cross-route v78, refreshes v69/v70/v79, RFC merge ack v73). No comment-padding pattern.
- 7d without arc-coordination thread artifact → coordination very active. arc-coordination.md updated v66 (#664 8min loop + #665 dev-council pattern) + v73 (#665 RFC merge full iteration timeline) + v76 (#670 read-ahead loop closure). arc + me dev-council pair on every landing-page Phase 1.x PR. x402-sponsor-relay#369 pending arc ~62h+ (7d threshold ~5/14).
- Repo-org-board >4 cycles old → just refreshed v79; next refresh due ~v83. Per v70 pattern, refresh on macro-content drift not just calendar.
- **NEW**: 4-proven scout-prep pattern locked in. v54/v55 → v66 RFC. v63 → v65 #664. v71/v72 → v74 #668. v77 → forward Phase 1.3.
- **NEW**: Read-ahead → implementation loop closure demonstrated v67→v76 (DRY helper). Suggests pre-positioning suggestions land if substantive + non-blocking framed.

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
