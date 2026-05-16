# AIBTC Repo-Org Board

**Maintained by:** @secret-mars
**Coordination with arc0btc:** through existing threads (#607 / #659 / #697 / #711 / #813 / #818 / #821 / #504 / arc-starter#25 / x402-sponsor-relay#369 / future co-PRs), no dedicated meta-issue.
**Last refresh:** 2026-05-16T01:18Z (cycle 2034v373, **v26 inline patch — focused snapshot covering v314→v372 (~58 cycles, 3 days). Major events: x402-sponsor-relay#369 verifyMessage-asymmetry CLOSED (arc fixup 8582d80 + v13 LGTM); BFF Skills Comp Day 15 + Day 17 paid (251,784 sats sBTC); lp#823 launch-hygiene cluster (#824/#825/#831) MERGED; lp#785 + #786 carry-forward MERGED; agent-contracts#9/#10 drift surface still 30+ days. Headline events only — full v314→v370 narrative deferred.**)

> Single canonical view of state across watched repos. Refreshed when Phase 3 step 7 fires (board >4 cycles old) or when a watched repo has substantial activity.

## *** v26 inline patch — focused snapshot v314→v372 (~58 cycles, 2026-05-13T05:13Z → 2026-05-16T01:18Z) ***

### Headline events

| When | Repo / PR | Event | Notes |
|---|---|---|---|
| 2026-05-13 | lp#785 + #786 | **MERGED** by whoabuddy | Carry-forward attestations from v309/v313 cleared. lp#785 was KV claim fallback for erc8004 agents w/ D1-LEFT-JOIN miss; lp#786 was edge-cache PR checklist docs |
| 2026-05-13 | lp#823 cluster (#824 + #825 + #831) | **3 PRs MERGED** — competition launch hygiene | Part 1 (filter SSR aggregate to Genesis-only senders), Part 2 (clean pre-launch swaps so 19:30Z renders empty), allowlist router-stableswap fix |
| 2026-05-13 | lp#826 + #838 | **CLOSED** (mine, superseded) | Competition launch iteration; superseded by alternative paths |
| 2026-05-14T15:09Z | health.json | **mode: comp_hype** | Trading competition went live; mode_directive constantly check + hype agents to trade |
| 2026-05-14 → 2026-05-15 | various | Comp-hype invitation broadcasts | Including bff-skills#588 macbotmini-eng invite (5/14, no response). Per health.json `comp_broadcast-2026-05-14-batch2.json` |
| 2026-05-15T15:41Z | lp#843 | **substantive review** (mine) | KV asymmetry + prefix anchor + bounty.drx4.xyz cutover plan + memo padding warning |
| 2026-05-15T16:10Z | x402-sponsor-relay#369 | **v370 polite nudge** (mine) | 8d past v12 verifyMessage-asymmetry finding; cite-last-comment-timestamp + one-specific-follow-up |
| 2026-05-15T16:18Z | x402-sponsor-relay#369 | **arc fixup `8582d80`** (~8min response) | verifyMessage symmetric path + 6 new tests + docstring + addressed CF-deploy concern |
| 2026-05-16T00:41Z | x402-sponsor-relay#369 | **v371 v13 LGTM closer** (mine) | Verified each claim against diff; surfaced one non-blocking expectedAddress-gating follow-up |
| 2026-05-16T00:41Z | aibtcdev/skills#327 + #330 | **BFF Skills Comp paid** | Day 15 (stacking-delegation) + Day 17 (contract-preflight) — 125,892 sats each, total 251,784 sats sBTC. Acked v372 with on-chain verification |

### Current open balls (v373 boot snapshot)

| PR | Repo | Status | Ball with |
|---|---|---|---|
| **x402-sponsor-relay#369** | aibtcdev/x402-sponsor-relay | OPEN, CONFLICTING-with-main | @arc0btc on (a) docstring-sharpen vs add-expectedAddress (b) rebase ownership |
| **mcp#518** | aibtcdev/aibtc-mcp-server | OPEN | @whoabuddy on merge (arc APPROVE on prior heads, fixup absorbed findings) |
| **mcp#504** | aibtcdev/aibtc-mcp-server | OPEN ~9d unmerged | @whoabuddy on merge (arc APPROVE×2 + explicit @-nudge) |
| **lp#843** | aibtcdev/landing-page | OPEN | @biwasxyz on response to v369 substantive review |
| **lp#851** | aibtcdev/landing-page | OPEN | @whoabuddy on review/merge of price-reads route through /api/prices |
| **lp#751** | aibtcdev/landing-page | OPEN | maintainer review (deprecated marker restoration) |
| **agent-contracts#9** | aibtcdev/agent-contracts | OPEN, APPROVED 2x + MERGEABLE | maintainer (release cadence?) — my ping 5/10 17:39Z, ~5d 8h ago, ~1d 16h to 7d threshold |
| **agent-contracts#10** | aibtcdev/agent-contracts | OPEN, arc APPROVED 5/11 + MERGEABLE; whoabuddy CHANGES_REQUESTED still canonical reviewDecision | @whoabuddy on converting CHANGES_REQUESTED → APPROVED — my @-nudge 5/11 11:36Z, ~4d 14h ago, ~2d 10h to 7d threshold |
| **loop-starter-kit#34/#35/#36/#37/#38/#43** | aibtcdev/loop-starter-kit | OPEN | maintainer pickup pending (last meaningful update late April–early May) |

### Patterns crystallized v371-v372 (active.md candidates)

- **v371 polite-nudge response cadence**: 8min from cite-last-comment-timestamp + one-specific-follow-up nudge to arc fixup commit. Validates v370 nudge format
- **v371 fixup-on-nudge as addressing-all-findings**: arc's fixup didn't just address the lead finding but ALL three v12 findings (lead + docstring + CF-deploy concern) in single commit/comment pair
- **v371 cross-cycle commit-time triangulation**: cited prior commit 4257596b started 2026-05-07T05:00–05:01Z to verify arc's "pre-existing" CF deploy claim. v122 post-deploy-probe pattern applied to claim-verification
- **v372 verify-before-ack on payment confirmations**: get_transaction_status before posting public ack on payment receipt. Standard hygiene; codifying as norm

### Active drift tells as of 2026-05-16T01:18Z

- **~~agent-contracts#9/#10: 30+ days no activity~~** [v374 correction: stale framing — both have substantive maintainer-pings within last 5-6 days; ball clearly with maintainers; 7d-threshold scouts pre-noted in NORTH_STAR backlog item 19. Not a drift surface]
- **comp_hype mode**: active per health.json since 2026-05-14T15:09Z but I'm not actively trading. Mode still load-bearing or stale? Check operator directive freshness.
- **loop-starter-kit cluster**: 5+ open PRs since mid-April with no maintainer pickup. Cohort nudge shipped 2034uo with no response. Stalled-thread surface candidate.

### Whoabuddy / arc dynamics (v314 → v372)

- **arc continues fast-trust-on-design + comprehensive-fixup pattern** (validated v371 on x402-sponsor-relay#369: 8min response → addresses all 3 findings in single commit)
- **whoabuddy queue-clearing pattern still active** (3 own-PR merges in window: lp#785, #786, #823 cluster)
- **Cross-thread arc cascade still observed** but at lower density than v309 burst (3 threads in 12min)
- **diegomey** added as new active counterparty: shipped BFF Skills Comp Day 15 + Day 17 payments (intake + frontmatter conversion + sBTC settlement). Cadence: comp PR merge → ~1mo review/judging → payment confirmed

### v375 finding — loop-starter-kit merge-queue pause

- **Last merge in `aibtcdev/loop-starter-kit`: 2026-03-20** (PR #20 by tfireubs-ui, merged 5762971f). **57 days since last merge** as of v375 (2026-05-16T02:09Z).
- 15+ open PRs from at least 6 different authors (mine + Benotos + anansutiawan + dogdamassa + codenan42 + dantrevino) all sitting MERGEABLE since mid-March/April.
- Mine: #34/#35/#36/#37/#38 (4/15) + #43 (5/6) — all APPROVED + MERGEABLE; arc APPROVED #34 on 2026-04-26.
- **Cohort nudge already shipped 2034uo with no response.** Re-pinging is unlikely to unblock.
- **Disposition:** treat as repo-wide maintenance pause, not mine-specifically-stalled. Action queue: if no merge activity by **2026-06-15 (90d threshold from #34 open)**, close my 6 PRs as "stale, awaiting maintainer pickup" and archive the work locally for later re-submission. Until then, no further nudges.
- Future cycles: do NOT re-check loop-starter-kit cluster as actionable until 6/15 threshold or maintainer signal.

---

## *** v25 inline patch — Gap 3 PR + arc cross-thread cascade + Tenero issue + scout discipline (cycles 2034v304–v313, ~3h 25min window 01:48Z → 05:13Z 5/13) ***

### Major ships this window

| PR/Issue | Repo | Status | Notes |
|---|---|---|---|
| **PR #518** (mine — Gap 3 held-state visibility) | aibtcdev/aibtc-mcp-server | OPEN, arc APPROVED on prior head, fixup absorbed 3 findings | Worker subagent shipped end-to-end in ~8min wall (v310→v311 spawn-to-PR-open). 550+/1- initial + 131+/13- fixup. 503 tests + 2 new. Critical schema-verification catch (worker swapped scout's invented `relayState`/`holdReason` for canonical `status`+`terminalReason` per `HttpPaymentStatusResponseSchema`). SSRF-guard widening mid-implementation in v312 absorption (same-origin too strict for production where relay is on different subdomain) |
| **lp#794** (mine — Tenero KV-empty root cause) | aibtcdev/landing-page | OPEN, 0 responses ~2.5h cold | Empirical: `/api/prices.prices = {}` + per-token `fetchedAt: null` on all 3 STATIC_TOKEN_IDS at +2h post-#738 deploy. 4 hypotheses ordered by likelihood + diagnostic ask + take-a-stab path. lp#793 (browser-direct Tenero) is a symptomatic workaround; this issue tracks the root SchedulerDO refresh task gap |
| **mcp#504 + mcp#487** (mine) | aibtcdev/aibtc-mcp-server | #504 still OPEN unmerged (~6d clean+approved); #487 callout actioned | arc re-APPROVED #504 on current head at v308 03:24Z resolving the dev-council "fast-merge-on-FIRST-APPROVE-only" gap. arc explicit @-whoabuddy nudge in their v308 status-check. arc cleared Gap 3 PR parallel-queue ("Don't wait for #504") with 100 sats/cycle ops-cost framing |
| **lp#785/#786** (mine) | aibtcdev/landing-page | Content-equivalent attestations shipped (v309/v313) | 8h-threshold attestations per pre-staged scout. Both still OPEN, awaiting whoabuddy merge despite arc APPROVE-on-prior-heads + green CI |
| **lp#754** (mine, issue) | aibtcdev/landing-page | CLOSED-by-whoabuddy 04:03:54Z | v218 prediction validated: risky merge-order (#743 before #738) did materialize but bounded impact via structural-zero. v311 closure ack from me + arc historical confirmation |

### Scout pre-stage/retirement table

| Scout | Pre-staged | Status | Outcome |
|---|---|---|---|
| `x402-relay-369-7d-threshold` | v304 | **ACTIVE** | Fires ~14.5h (2026-05-14T19:36Z) if arc still silent |
| `lp-785-786-attestation` | v306 | **RETIRED v313** | Branch A fired for both PRs (lp#785 v309, lp#786 v313). Content-equivalent claim empirically verified honest pre-fire |
| `mcp-504-7d-threshold` | v307 | **RETIRED v308** | Branch B fired: arc engaged pre-threshold (~30min post pre-stage). n=1 of scout-pre-stage-→-engagement-pre-threshold pattern |
| `487-gap2` / `487-gap3` | pre-existing | Gap 3 now SHIPPED as PR #518 (v311); Gap 2 still deferred per arc's parallel-queue clearance | |

### Patterns codified v304-v313 (active.md candidates)

- **v305 issue_filed-as-cooldown-override**: severe new issue surface (Phase 3 priority 3) overrides cooldown directive via category distinction (`issue_filed` ≠ `comment_shipped`)
- **v308 scout-pre-stage-→-engagement-pre-threshold (n=1)**: pre-staging a scout 2.5d before threshold may be loose Schelling signal. Coincidence still likely at n=1; track for n≥3 to validate
- **v308 same-cycle scout retire to resolved/**: when scout branch B/C fires (engagement / supersession pre-threshold), retire scout in same cycle. Updates `daemon/scouts/` set to active-only
- **v309 arc-cross-thread-cascade**: arc engaged 3 threads in 12min (mcp#504 APPROVE + agent-news#810 context + mcp#487 status-check). Cluster engagement; not coincidence. Worth detecting as a "respond fast" signal
- **v310-v311 worker-agent-as-implementation-arm**: 2-3h estimated solo PR work ran in <10min wall via background subagent (56 tool uses, 103k tokens, 513s). Worker output high-quality; critical schema-verification catch surfaced. Best for scope >100 LOC + clear specs. n=1
- **v311 schema-verification-during-implementation**: scout-invented field names (from issue body) may not exist in canonical schemas. Always read the canonical schema source-of-truth at implementation time. Worker correctly caught + documented mapping table
- **v312 SSRF-widening-mid-implementation**: first-pass strict same-origin SSRF guard would have broken production (relay on different subdomain). Caught by re-reading test data assumptions before push. Pivoted to dual-check (endpoint-origin OR canonical relay per NETWORK)
- **v313 scout-discipline-cost-vs-contract-guarantee**: waited 91s past threshold rather than fire 91s early in v312. Cost ~15min cycle deferral; preserved agent's-own-contract guarantee

### Active drift tells as of 2026-05-13T05:13Z

- **Maintainer post-burst quiet** — lp#785, lp#786, mcp#504, mcp#518 all OPEN despite arc APPROVE + my attestations. whoabuddy's burst at 00:24-00:49Z (lp#738 + lp#790 + mcp#510 + lp#651 closure + mcp 1.52.0 release) appears to have closed for the night
- **lp#794 (Tenero KV-empty)** — 2.5h cold; if no response by EOD 5/13, consider a brief polite ping with `wrangler tail` snippet to make the diagnostic ask more concrete
- **arc x402-sponsor-relay#369** — still silent ~5d 9h since my v12 review; 7d threshold ~14.5h. Scout fires Branch A nudge automatically at threshold
- **Scout retirement velocity** — 2-of-3 retired this session (66% hit rate). Suggests scout pre-stage matches real maintainer cadence rather than being theoretical

### Whoabuddy / arc dynamics (v304-v313)

- **arc** v304-v313: HIGH engagement. Cross-thread cascade in 12min; substantive APPROVE on PR #518 at 6min post-open with 3 actionable findings including operational reproduction (3,000 sats stranded production case). arc explicit @-whoabuddy nudges on multiple threads suggest arc is unblocking the merge queue via cross-thread coordination
- **whoabuddy** v304-v313: post-burst quiet. Last merge activity at 00:49Z (lp#790). 4+ PRs awaiting merge clearance despite green CI + arc clearance. Possible end-of-active-window
- **biwasxyz** v304-v313: shipped #792 + #793 leaderboard fixes (cited my v301 finding directly) + closed lp#754 implicitly via #738 + #743 landing
- **ThankNIXlater** v309: on agent-news#810 thread (Quality scorer fabricated URLs); also confirmed my 5/10 verification

---

## *** v24 inline patch — Phase 3.1 LIVE + mcp#510 npm release + open-fix-PR lag watch (cycles 2034v287–v303, ~6h window 19:44Z 5/12 → 01:48Z 5/13) ***

### Phase 3.1 LIVE cluster (3 merges in 25min, 00:24Z–00:49Z 5/13)

| PR | SHA | Merged-at | Notes |
|---|---|---|---|
| **lp#738** (Phase 3.1 verifier + scheduler + allowlist) | `9afa89d1` | 2026-05-13T00:24:40Z | Final rebase: SchedulerDO integration replacing public /api/competition/cron + token-bucket. 3 secret-mars APPROVEs in lineage (bed7cd0b/5224a0d9/9afa89d1). Deploy-verified Branch A v300 (`/api/competition/{trades,allowlist,status}` all 200, 400+example on missing required `address=`). v301 +46min Volume anchor + v303 +1.5h re-probe: `volumeUsd: 0, allPriced: false` consistent on 2 legacy rows |
| **lp#790** (SchedulerDO rejectionReasons buckets) | n/a | 2026-05-13T00:49:06Z | whoabuddy's own follow-up. Adds `rejectionReasons` buckets so SchedulerDO status/logs explain whether rejects are pre-launch trades, failed txs, registration misses, etc. Focused tests green. Merged without my pre-review (CI green + whoabuddy-author) |
| **mcp#510** (competition tools + Bitflow provider tag) | `521c2466` | 2026-05-13T00:26:41Z | Mine. Merged 2min after lp#738 (chained dependency per arc note). v144 follow-up Q1+Q3+Q4 thread mooted by merge (biwasxyz never responded). npm `@aibtc/mcp-server@1.52.0` published 00:29:35Z via release-please #514. Tarball spot-verified v302: `competition.tools.js` + `competition.js` present; 3 tools registered (`competition_submit_trade`/`status`/`list_trades`); `AIBTC_CAMPAIGN_API_URL` default → prod |

### lp#651 CLOSED-by-superseded (cycle v300)

whoabuddy closed lp#651 at 00:27:34Z citing my v280 closure-suggestion rationale. /leaderboard now satisfies the dashboard-balance ask at the platform level. Closes the v218→v257 architectural arc plus the v280 closure-framing scout (retired).

### Open PRs (mine) at end-of-window 2026-05-13T01:48Z

| PR | Head | Reviews | Notes |
|---|---|---|---|
| **lp#785** (mine — fix Robotbot69#771 KV claim fallback) | `56c770a3` | arc APPROVED on prior `9df091f6` (stale-after-fixup); CI all green | ~6.3h since fixup. Anomalous lag — arc has not re-approved on current head, whoabuddy was Phase-3.1-busy during the window. Possible content-equivalent attestation candidate in next cycle |
| **lp#786** (mine — Forge edge-cache PR checklist, closes lp#782) | `89458b94` | arc APPROVED on prior `aafe76ff` (stale-after-fixup); CI all green | ~5.1h since fixup. Same pattern as lp#785 |
| **lp#771** (Robotbot69 — POST /api/signals identity gate) | n/a (issue) | n/a | Robotbot69 silent since their original filing; arc cross-source framing at v286; my v292 ack at 21:22Z. Awaiting lp#785 merge for write-path unblock verification |

### Phase 3.1 +1.5h observability anchor (v301 + v303)

Probes at +46min (v301) and +1.5h (v303) both show identical state:
- `/leaderboard` → 200, 2 trade rows (both my wallets: `SP20GPDS5RYB2DV03KG4W08EG6HD11KYPK6FQJE1` Quasar Garuda × 2 trades 5/11, `SP4DXVEC…` Secret Mars × 1 trade 5/8)
- Both rows: `volumeUsd: 0, allPriced: false`
- `/api/competition/trades?address={mine}`: 2 rows, both STX↔stSTX swaps via `SPQC38PW542EQJ5M11CR25P7BS1CA6QT4TBXGB3M.stableswap-stx-ststx-v-1-2` (Bitflow allowlisted), `scored_value: null, scored_at: null`
- **Hypothesis**: Tenero pricing coverage for stSTX may explain terminal `allPriced: false` on these legacy rows rather than scheduler-firing gap. Concrete test = fresh sBTC/STX swap via the allowlist
- v301 observability comment (issuecomment-4436213944) and v302 mcp close-out (issuecomment-4436330260) shipped; awaiting whoabuddy/arc response

### Patterns codified v287–v303 (memory/learnings/active.md v299 + STATE v300)

- **v288 Phase 6 always-on re-baseline** (always re-read recent STATE/health/board before drafting; closes v277 stale-info recurrence class)
- **v297 cross-PR substrate compounding** (one fixup commit can absorb 3+ deferred findings across multiple PRs when they share a substrate; e.g. addressesToBust + identity-refresh-shape + cache-invariant on lp#727)
- **v298 full-cluster lock-up signal corrected → v300 deep-batch lull vs EOD** (silent-cluster lull doesn't always mean operator EOD; deep-batch ships do happen overnight)
- **v300 pre-stage scout 3/3 success rate** (scouts/743 + scouts/651 + scouts/738 all fired Branch A as designed)
- **v302 post-merge npm tarball spot-verify** (close-out pattern: pull npm tarball + confirm presence of expected files + tool names + config defaults; cheap end-to-end empirical close)
- **v303 drift-tell guard: 3-comment-consecutive watch** (3 cycles with only comment_shipped triggers diversification — fires board refresh / issue file / PR review)

### Active drift tells as of 2026-05-13T01:48Z

- **lp#785 + lp#786 lag** — ~6.3h / ~5.1h since fixup. arc APPROVE stale on prior heads. CI green. Dev-council fast-merge-on-arc-APPROVE pattern only fires on FIRST APPROVE, not re-approves on fixups — so the lag may be structural (arc doesn't re-approve on rebase/fixup unless explicitly re-tagged)
- **lp#738 v301 observability + mcp#510 v302 close-out** — both await whoabuddy/arc response; not yet "stalled" but ping-watch
- **arc x402-sponsor-relay#369** — 2026-05-07T19:36Z; 7d threshold ~2026-05-14T19:36Z (~18h remaining at v303). Past 5d into the silent window
- **lp#771 partner verification** — Robotbot69 has NOT engaged since filing; awaiting lp#785 merge for write-path unblock verification (cascade gate)
- **0 review-requested @me, 0 new aibtcdev issues last 24h, 0 notifications** — quiet inbound; loop momentum sustained by own-PR loops + observability anchors

### Whoabuddy / arc dynamics (v287–v303)

- **whoabuddy** post-Phase-3.1: 4 ships in ~24h (lp#787 + lp#788 + lp#790 + lp#738 + mcp#510 merge + lp#651 close + lp#514 release). Operator-action density at strongest observed. Less responsive to my v301/v302 comments — typical post-burst quiet
- **arc0btc** post-Phase-3.1: contributed Phase 3.1 review + cross-source framing on lp#771 (v286). Quiet on x402-sponsor-relay#369 still (5d+). May be cycling off-platform
- **biwasxyz**: silent v300 (didn't respond to v144 Q1+Q3+Q4 on mcp#510 but merge happened via whoabuddy); also accepted my lp#651 closure rationale (via whoabuddy close)

---

## *** v23 inline patch — v275-cluster merge wave + cross-repo fix-PR + Cycle 6/7/8/9 absorption (cycles 2034v275–v286, ~3.3h window 16:31Z → 19:38Z 5/12) ***

### Cluster merge wave (lp#773 + #774 + #775 + #743 all MERGED this window)

| PR | SHA | Merged-at | Notes |
|---|---|---|---|
| **lp#773** (P4.0a agents-index from D1) | `1827ebdf` | 2026-05-12T16:13:50Z | Fast-merge 2min post my v274 APPROVE. Cycle 6 retrospective (steel-yeti 16:17Z) → whoabuddy filed **lp#783** at 18:23Z capturing 3 follow-ups (d1_low_row_count logger reason, threshold-basis comment, #691-gated retirement). My v281 offer-to-take with tagged-union sketch in court. |
| **lp#774** (P3.2 edge-cache crawler OG middleware) | `6f79f647` | 2026-05-12T17:18:26Z | My v276 Cycle 7 substantive follow-up (Cairn Q1/Q2/Q3 + Spark residue + Forge +1) closed cross-PR comment + addressesToBust unification. Cycle 9 retrospective (steel-yeti 17:23Z) flagged identity-refresh shape inconsistency → whoabuddy filed **lp#780/#781/#782** at 18:22-23Z citing my v276 work 3x ("narrowing note", "Cairn Q2", "Forge +1"). |
| **lp#775** (P3.3 edge-cache /api/og 24h TTL) | `7999e01d` | 2026-05-12T16:45:26Z | Caught at v277 (was stale-at-write in v276 STATE — Phase 6 re-baseline pattern codified always-on). Cycle 8 advisory (steel-yeti 16:43Z) validated ogAddressesToBust as strong precedent. |
| **lp#743** (/leaderboard + SchedulerDO) | `d72559e8` | 2026-05-12T17:52:28Z | force-dynamic flip from my v275 build-caveat recommendation. End-to-end loop: 16:24Z whoabuddy raises caveat → 16:30Z my rec → 17:06Z whoabuddy ships d72559e → 17:09Z my re-APPROVE → 17:52Z merge → 18:06Z deploy verified Branch A. ~1h41m. Pre-staged scout (scouts/651-closure-framing.md) ran Branch A → closure-as-superseded suggestion shipped on lp#651. |

### Open PRs at end-of-window (2026-05-12T19:44Z)

| PR | Author | SHA | Reviews | Notes |
|---|---|---|---|---|
| **lp#785** (mine — fix#771 KV claim fallback) | secret-mars | `56c770a3` | arc APPROVED on prior 9df091f6 (stale-after-fixup); CI all green on fixup | First cross-repo fix-PR pattern. arc shipped substantive [question]/[suggestion]/[nit] at 19:13Z; same-cycle absorption: fixup pushed (!= null + JSDoc trim) + substantive [question] answer (trust-chain framing). Awaiting arc re-APPROVE OR whoabuddy fast-merge. |
| **lp#784** (whoabuddy — scheduler v2 hotfix) | whoabuddy | `aa4e4848` | arc + secret-mars both APPROVED | Already deployed to prod per PR body. My v284 review: HMAC-RFC-4226-§6 constant-time-comparison analysis + 2 non-blocking follow-ups (rate limit on /api/admin/*, robots.txt). |
| **lp#780** (whoabuddy — unify OG cache invalidation) | whoabuddy | n/a | none | Supersedes my lp#778 (closed). Whoabuddy cited my v276 narrowing note. |
| **lp#781** (whoabuddy — zone-CDN s-maxage) | whoabuddy | n/a | none | My v282 substantive recommendation (option b + c per-surface tiering). Whoabuddy cited my v276 Cairn Q2. |
| **lp#782** (whoabuddy — edge-cache PR checklist) | whoabuddy | n/a | none | Forge campaign-checklist materialization. Whoabuddy cited my v276 Forge +1. |
| **lp#783** (whoabuddy — MIN_EXPECTED_D1_ROWS retirement) | whoabuddy | n/a | none | My v281 offer-to-take with tagged-union return-shape sketch in court. |
| **lp#651** (biwasxyz — /dashboard balance) | biwasxyz | `d711c3a1` | secret-mars CHANGES_REQUESTED + closure suggestion | My v280 close-as-superseded suggestion (per pre-staged scout). Awaiting biwasxyz decision. |
| **lp#771** (Robotbot69— POST /api/signals identity gate) | Robotbot69 | n/a (issue) | n/a | Cross-org partner bug. My v279 substantive triage (dual-source claim lookup root cause); fix-PR #785 linked. |

### Patterns codified this window (memory/learnings/active.md)

- **v275 substantive-engagement-when-asked**: whoabuddy build-caveat invited substantive read → OpenNext-CF reasoning + concrete 2-line suggestion + trade analysis. Not LGTM-padding even when not @-tagged.
- **v276 read-full-thread + sub-line-cited Q&A**: Cycle 7/8/9 advisories warrant code-cited substantive responses across 3 advisories surfaced within 30min.
- **v277 stale-info-in-STATE → Phase 6 re-baseline always-on**: third occurrence of writing-STATE with stale PR/issue state. Promoted to always-on policy.
- **v278 advisory→operator-issue→my-offer-to-take pattern**: steel-yeti advisory → whoabuddy filed #783 → I offered-to-take with code-design surfacing.
- **v279 cross-org partner-filed bug response**: same-day-or-next-day substantive triage for partner repos.
- **v280 pre-stage-scout pattern paid off**: scouts/743 + scouts/651 (staged v259) → ran clean Branch A. Maintain 3-5 pre-staged scouts.
- **v281 offer-to-take-PR pattern at scale**: 3rd instance in 3 cycles. Cite file:line + surface code-design question + concrete implementation sketch + easy-to-decline language.
- **v282 sweep-rule addition**: include `gh search issues/prs --created=">2h"` to catch new openings without @-tag dependency. Validated preventive in v283 + actionable in v284 (caught lp#784).
- **v283 cross-repo fix-PR pattern (NEW)**: clone via gh repo fork → focused fix → unit tests on pure helper + TS type-guard predicate → PR body with issue triage URL + alternatives + verification path + related backlog.
- **v284 crypto-auth review pattern**: HMAC-as-constant-time-comparison RFC 4216 §6 grounding; information-theoretic argument when string-compare is non-constant-time but inputs are HMAC outputs.
- **v285 dev-council [suggestion]/[nit]/[question] same-cycle absorption**: fix [suggestion]+[nit] in fixup commit + answer [question] in-thread, don't wait for re-review.
- **v286 pre-stage-scout as observation-cycle artifact**: in waiting-cycles where CI runs but no external action ships, scout pre-stage produces real workspace artifact AND multiplies leverage on trigger.

### Active drift tells as of 2026-05-12T19:44Z

- lp#785 fixup 56c770a3 CI green ~14min, arc re-APPROVE pending — dev-council loop slightly slower than baseline ~5min
- lp#784 dual-APPROVE in court, whoabuddy merge pending despite "already deployed to prod" framing
- lp#780/781/782/783 all OPEN with my offer-to-take in court (4 simultaneous offers — operator batch cadence ~hourly)
- arc x402-sponsor-relay#369 still 2026-05-07T19:36Z (5d+ silent; 7d threshold ~5/14 ~36h)
- Robotbot69 has NOT engaged on #771 since filing — awaiting fix-PR merge + verification before they validate write-path unblock

### Whoabuddy / arc dynamics

- **whoabuddy** post-pivot: operator-action batches at ~hourly cadence (16:24Z notes → 17:06Z fix → 18:22Z 4-issue batch → 19:13Z review absent). Active on architecture decisions + issue-filing; less active on response-to-my-PRs (lp#785 awaits whoabuddy notice).
- **arc0btc** post-pivot: fast turnaround on substantive reviews (~17min PR-opened to APPROVE on lp#785; ~minutes on lp#784). Dev-council [question]/[suggestion]/[nit] structure showing strong adoption.
- **biwasxyz** quiet on lp#651 closure suggestion since 18:07Z (~1.5h).

---



**Operator directive (still active — /start args 2026-05-11):** "100% focus on trading-comp PRs across MCP + landing-page, review/test via preview URLs, file ONE issue tagging @whoabuddy + @arc0btc."

### Trading-comp cluster state (as of 2026-05-12T09:13Z)

| PR | SHA | State | Review state | Notes |
|---|---|---|---|---|
| landing-page#738 (Phase 3.1 verifier) | `5224a0d9` | OPEN | secret-mars APPROVE×5 (latest on 5224a0d9); arc/whoabuddy formal re-approve pending | CLEAN mergeable. bed7cd0 comp-start gate + 5224a0d9 KV→D1 cursor refactor both substantively approved. v246 doc-nit (route.ts:31 stale "501") still awaits maintainer fix |
| landing-page#743 (/leaderboard + SchedulerDO) | `46e6badb` | OPEN | reviewDecision=APPROVED; secret-mars closing APPROVE at v257 | DIRTY mergeable (rebased onto main+#772). CI red expected (10211: non-prod CI can't apply DO migrations). No preview URL (CF doesn't issue for DO workers). Migration history v1+v2+v3 declared. Inlined SchedulerDO in worker.ts. Awaiting whoabuddy merge |
| landing-page#651 (/dashboard balance Genesis) | `d711c3a1` | OPEN | secret-mars CHANGES_REQUESTED (v241 scope clarification); whoabuddy stale | BLOCKED. Scope question to whoabuddy from biwasxyz 02:31Z. v241 surfaced 3 drifts (route name, file collision, schema). Awaiting whoabuddy decision |
| landing-page#765 (DO-alarm scheduler bridge) | n/a (issue) | **CLOSED** | n/a | Closed by biwasxyz 03:54Z at v244. My v242 trigger-semantics distinction made simpler-state-store path attractive; scheduler-primitive selection became orthogonal once cursor moved to D1 |
| landing-page#768 (SchedulerDO design) | n/a (issue) | OPEN | secret-mars v247 substantive comment; whoabuddy filed | Materialized in lp#743's 12-commit batch at 07:11-07:16Z. Implementation tracks v247 framework directly |
| landing-page#772 (v2 deleted_classes hotfix) | n/a (merged) | **MERGED** | secret-mars +1 reaction | Production restoration 08:30Z. Recovered from misdirected v1 SchedulerDO migration that hit production worker `landing-page` instead of preview during PR #743 experimentation. v254 hypothesis #2 (migration-tag conflict) verbatim-confirmed |
| mcp-server#510 (competition tools + Bitflow) | `521c2466` | OPEN | secret-mars APPROVE; arc re-APPROVED 03:21Z (closed v1 suggestions) | CLEAN, both APPROVE. Chained behind lp#738 merge per arc note |

### Arc-closure summary (v218 → v257)

The full architectural thread closes cleanly. Finding-thread carried through 4 pivots + 2 fix-cycles + 1 production incident:

| Cycle | Surface | Ship | Outcome |
|---|---|---|---|
| v218 | #764 | second-opinion APPROVE on DO-alarm pattern | Validated NonceDO/NewsDO as org precedent |
| v220 | #764 | NonceDO trigger-semantics empirical read | Worth-naming finding for #765 impl |
| v241 | #651 | Scope clarification (3 drifts) | biwasxyz scope-question got 3 concrete findings |
| v242 | #765 | Event-driven-vs-poll-driven distinction | Drove biwasxyz to close #765, pivot to D1-cursor |
| v243 | #738 (bed7cd0) | Substantive APPROVE re-review | Producer/consumer-symmetric pattern named |
| v244 | #738 (5224a0d9) | KV→D1 cursor refactor APPROVE | Direction tracks #765 closure rationale |
| v245 | #743 (412f91ff) | APPROVE re-review | KV→D1 alignment cross-PR observation |
| v246 | #738 | Doc-drift nit (501 stale string) | Non-blocking; awaits fixup |
| v247 | #768 | SchedulerDO design comment (3 findings + 1 clarification) | Materialized as 12-commit batch within ~1h |
| v249 | #743 | Pre-staged scout (A/B/C/D decision tree) | Restraint demonstration; held-back review during iteration |
| v250 | #743 | Deploy-fail flag after 2 failures | Operational signal escalation |
| v251 | #743 | Runtime-404 flag with hypothesis | **v252 hypothesis confirmed verbatim by b8abf98f commit msg** |
| v254 | #743 | Still-broken flag with 2 hypotheses | **Hypothesis #2 confirmed verbatim by #772 PR body** |
| v256 | #772 | +1 reaction on production-restoration | Closed diagnostic loop without comment noise |
| v257 | #743 (46e6badb) | Closing APPROVE | Arc closure |

### Patterns codified during this window (memory/learnings/active.md)

- **v246/v248 → preview-URL deep-probe pattern** (after PR-APPROVE, 4-axis runtime probe: self-doc, validation, idempotency, cursor) — closes gap between PR-review correctness and runtime-edge-case drift
- **v249-v252 → engagement-cadence-with-maintainer-iteration** (3 modes: active-iteration / diagnostic-stall / hard-wait); operational signals ≠ nits; build status ≠ runtime status; cache-miss tradeoff for diagnostic waits; pre-staged scout files for "comment ready but timing wrong"
- **v255 → hypothesis-validation-via-commit-message** (when you can't access debug artifacts, well-bounded static-analysis hypothesis SHIPPED publicly becomes a validation oracle via maintainer fix-commit message); 2 prerequisites — testable + shipped publicly

### Whoabuddy / arc dynamics

- **whoabuddy** filed #768 (SchedulerDO design issue) at 05:33Z, filed #772 (production hotfix) at 08:30Z. Active on architecture decisions, less so on review-side.
- **biwasxyz** materialized #768 design in 12-commit batch at 07:11-07:12Z (with Claude Co-Authored-By trailer). Two failed deploys + production incident + recovery via #772 + final clean rebase 08:38Z. Multi-iteration cycle with explicit lessons-baked-in comment at 08:42Z.
- **arc** silent on trading-comp surfaces since 03:21Z mcp#510 re-APPROVE. lp#738 5224a0d9 + lp#743 46e6badb both await arc re-approve.

### Active drift tells as of 2026-05-12T09:13Z

- lp#738 5224a0d9 untouched ~3.7h, no arc/whoabuddy formal approve on the current SHA
- lp#651 unchanged since 02:38Z (7h idle), whoabuddy scope decision pending
- mcp#510 chained behind #738; if #738 merge delays >24h, may want to nudge
- lp#743 46e6badb CI red expected; merge depends on whoabuddy doing manual review (no preview URL to test against)
- Drift-tell: **operator override still active but architectural arc closed** — next cycle may shift focus if operator lifts override

---

## *** v21 inline patch — trading-comp scope only (cycles 2034v218–v231, ~6.5h window 15:58Z → 22:33Z) ***

**Operator directive (active):** "100% focus on trading-comp PRs across MCP + landing-page, review/test via preview URLs, file ONE issue tagging @whoabuddy + @arc0btc."

### Trading-comp cluster state (as of 2026-05-11T22:33Z)

| PR | SHA | State | Review state | Notes |
|---|---|---|---|---|
| landing-page#738 (Phase 3.1 verifier) | `37f53c6a` | OPEN | secret-mars APPROVE×5; arc APPROVED | Mergeable, CI green. Untouched since 09:23Z; chainhook PR-C scope-cut at 04:31Z (8 revert commits) |
| landing-page#743 (/leaderboard MCP-trade count) | `6abf5ddc` | OPEN | reviewDecision=APPROVED (arc 08:47Z); arc held-approval-post-rebase commitment per #754 | Mergeable, CI green. Stacked on #738; head missing #738's `lib/competition/*` substrate (rebased onto main) |
| landing-page#651 (/leaderboard balance Genesis) | `d711c3a1` | OPEN | secret-mars APPROVED; whoabuddy APPROVED; arc APPROVED earlier | Mergeable. **Route collision with #743** (both write `app/leaderboard/page.tsx` with divergent designs) |
| mcp-server#510 (competition tools + Bitflow provider) | `521c2466` | OPEN | secret-mars APPROVE (v228 substantive re-review); arc APPROVED 5/10 | Tool descriptions + 6-test test file land Q1/Q2/Q5 from my v135. Awaiting #738 backend deploy |
| mcp-server#512 (Pyth VAA fix for zest_borrow) | `3d87c8e3` | OPEN | secret-mars APPROVE×2; arc APPROVED self | Sequential merge with #513 |
| mcp-server#513 (vaaInFlight + ZestPythUnavailableError + 8 tests) | `606ed7c2` | OPEN | secret-mars APPROVED; arc APPROVED self | Awaiting #512 merge first |

### Cross-PR coordination findings (filed in landing-page#754)

1. **Branch drift** (v218): #743 head was rebased onto main and dropped #738's `lib/competition/*` substrate. PR base is correctly `feat/competition-read-routes`; head tree is missing the substrate. Production risk if #743 merges first: empty `/leaderboard`. Recommended order: #738 → main → rebase #743 → merge.
2. **Held-approval pattern** (v219 — arc validated): held APPROVE on stacked PR until post-rebase CI passes is structural enforcement vs. PR-template checklist's author-side discipline.
3. **Route collision** (v220): #651 + #743 both write `app/leaderboard/page.tsx` with divergent designs. Collision created by #743's 09:08Z architectural pivot (post my-APPROVE on #651). 3 resolution options proposed; biwasxyz silent.
4. **Chainhook scope-cut self-correction** (v227): #754's body had listed chainhook among routes #738 adds — empirical re-probe + commit log showed PR-C was reverted at 04:31-04:34Z 5/11. Tightened to 4 ingestion routes (trades/status/allowlist/cron).
5. **mcp#510 missed-commits self-correction** (v228): my STATE.md had carried "biwasxyz silent on Q1+Q5 ~28h+" — wrong since 06:51Z 5/11. Biwasxyz pushed 3 commits at 06:44-06:51Z addressing Q1 + Q5 + adding 6-test test file. Substantive APPROVE shipped post-discovery.

### Issues filed

- **landing-page#754** "[trading-comp coord] #738 verifier must merge before #743 leaderboard — empirical preview test surfaced branch drift" (filed 16:04Z, 3 comments since: arc ratification at 16:11Z, my held-approval ack at 16:23Z, my collision finding at 16:41Z, my chainhook self-correction at 20:22Z). Tagging @whoabuddy + @arc0btc.

### Whoabuddy sequencing (signal from landing-page#652)

Phase 2.5 → **#762 (rate-limits + identity/BNS cache off KV)** → trading-comp queued behind. 5 inbox PRs merged 17:10-19:18Z 5/11; cluster has been quiet on trading-comp since 09:23Z (#738 last commit). #762 PR not yet opened.

### Patterns codified during this window (memory/learnings/active.md)

- v218 → branch-drift in stacked PRs (empirical sibling-route probing)
- v219 → held-approval-until-rebase as structural enforcement
- v220 → sibling-PR-created collision (PR-A's approval stales when PR-B mutates)
- v223 → allowlist coverage timing + broken handoff doc link
- v225 → idle-cluster restraint discipline (don't synthesize on idle)
- v226 → `ALLOW_EMPTY_CYCLE=1` is the right bypass (not "don't commit")
- v227 → self-introduced staleness in own canonical docs
- v228 → `updatedAt` ≠ "no new substance"; compare commit SHAs at boot
- v229 → operator-narrow + hook-strict creates synthesis cliff
- v230 → telegram operator with cadence menu on persistent-quiet cycles
- v231 → scope-limited board refresh as honest output during quiet window

### Drift tells active 2026-05-11T22:33Z (trading-comp scope)

- 9 consecutive SHA-unchanged cycles on all 6 trading-comp PRs (since v218)
- main HEAD unchanged 3.25h+ (since 19:18Z)
- No biwasxyz response to v220 collision, v223 allowlist+handoff, v227 PR-body cleanup (~6h silent)
- No whoabuddy response to #754 (~6.5h silent — but whoabuddy has been active on inbox PRs, signaling Phase 2.5 priority over trading-comp)
- arc ratified #754 at 16:11Z, no further engagement
- Operator override active since 15:58Z; v230 cadence menu telegram sent at 22:01Z, no operator reply by 22:33Z (default = continue 1800s)

## *** v20 inline patch — what changed since v19 (cycles 2034v197–v208, ~5.5h window 06:55Z → 12:34Z) ***

**Major milestones:**

- **landing-page#743 mid-cycle architectural pivot** (cycles v200–v201, ~30min window 08:49Z → 09:25Z): biwasxyz opened #743 at 08:49Z titled "feat(agents): MCP trades count + volume + latest-trade columns on /agents" → my v201 substantive review identified CI BLOCKER (3 `console.warn` violating `no-console`, fix recipe: thread `createConsoleLogger` from `@/lib/logging`) → biwasxyz had ALREADY pushed the lint fix `2fc8adad` at 08:53Z (1 min before my review) → my v201 follow-up at 09:05Z surfaced operator-empirical volume=0 bug from preview render → biwasxyz **fully pivoted architecture** in 6 commits between 09:00Z–09:25Z: `f327554 revert: drop volume.ts + /agents enrichment, switch to /leaderboard page`, `ef9e570 feat(leaderboard): /leaderboard page (server-rendered, D1-only)`, `92b37cd feat(leaderboard): LeaderboardClient with browser-side Tenero + localStorage cache`, etc. Title changed to "feat(leaderboard): /leaderboard page ranked by MCP-submitted trade count + USD volume." Closes v201 obs #2 (cross-PR source-of-truth split) + obs #4 (Tenero cache absence). Current state: reviewDecision=APPROVED (arc APPROVED 08:47Z — I missed this in v201 due to state-staleness on read-side; arc's APPROVE landed 7min BEFORE my review).

- **landing-page#738 allowlist endpoint** (cycle v202, 09:23Z): biwasxyz landed `37f53c6a feat(competition): GET /api/competition/allowlist — discoverable verifier scope` (90 LOC) — 2 minutes BEFORE my empirical-follow-up surfaced the operational gap from the 3 diagnostic swap rejections. **My v202 APPROVE** validated: 4 entries / 10 functions, 24h SWR edge cache, ?docs=1 self-doc payload, `CACHE_INVARIANTS:POSTURE=public-only-get` marker (v167-v173 first new-route instance). Surface complete: verifier + read routes + allowlist endpoint + chainhook + cron + success-only-gate tests + 409 structured error. Awaiting whoabuddy merge ~22h+.

- **3 operator-directed diagnostic swaps** (cycle v201, 09:11Z–09:18Z): substrate for #743 volume=0 bug investigation. Trade results:
  | # | Txid | Pair | Route | Verifier |
  |---|---|---|---|---|
  | 1 | `1525545c` | sBTC → STX 1000 sats | `wrapper-velar-path-v-1-2::swap-univ2v2` (Bitflow MCP picked Velar) | **REJECTED HTTP 422** `contract_not_allowlisted` |
  | 2 | `8216835d` | sBTC → stSTX 1000 sats | `router-xyk-stx-ststx-v-1-2::swap-helper-a` | **REJECTED HTTP 422** |
  | 3 | `54388a8a` | stSTX → STX 0.1 stSTX | `stableswap-stx-ststx-v-1-2::swap-y-for-x` | **ACCEPTED HTTP 200** — landed in D1 |
  Empirically surfaced operational gap (Bitflow MCP routes sBTC pairs through non-allowlisted wrappers) → biwasxyz built allowlist endpoint as direct response. **Bonus empirical finding:** `/leaderboard` revealed `tokenId: "unknown"` for SP4DXVEC retired wallet's row, confirming parser fallback path exists in production data (validates v201 obs #3 wstx-normalization concern in spirit).

- **landing-page#740 + #741 dev-council convergence** (cycles v198–v199, 07:14Z → 08:05Z): @Robotbot69 filed 2 post-cutover regression issues on Phase 2.5 (`/api/agents.sentCount=58` vs `/api/inbox.sentCount=0` for Opal Gorilla). v198 root-caused to `lib/agent-enrichment.ts:108-165` (still KV-backed `getSentIndex`/`getAgentInbox` while inbox/outbox routes flipped to D1 in #732/#739). Two-track fix proposed; arc validated empirically with 2nd address (gap=234 for arc's own bc1qlezz…), named PR #720 as introducing dual-write, proposed MAX(kv,d1) band-aid + B-before-A sequencing. v199 convergence: arc takes Track A (agent-enrichment.ts flip), whoabuddy ball on Track B shape (backfill admin endpoint vs cron), consistency-check invariant co-located with B. Awaiting whoabuddy decision.

- **agent-contracts cluster cascading-unblock** (cycles v205–v206, ~30min window): self-audit corrected "27d stale" narrative — arc had filed CHANGES_REQUESTED at 17:42Z 5/10 (yesterday), my fix `1e57ed5 heartbeat: guard record-activity prev-block` landed at 17:57Z + informal ack at 17:58Z, but no explicit @-tag re-review request. **v206 explicit ping** with @arc0btc + "Re-review when convenient" got 7-MIN APPROVED response. **arc APPROVED #10** at 11:15:58Z ("Ready for testnet deploy"). Cascading unblock pings: whoabuddy on #10 (dismiss-or-re-review stale CHANGES_REQUESTED), #8 stuck-cluster ping with 3 paths cc'd @pbtc21/@cocoa007/@tfireubs-ui. v207 corrected the v204 sub-pattern naming: real failure is "**ack-comment-without-explicit-@-tag-and-re-review-phrasing**", not "no ack."

- **aibtc-mcp-server#510 wire-up scout** (cycle v203): pre-positioned for PR open after #738 merge. `daemon/scouts/510-allowlist-wireup.md` proposes ~80-100 LOC across 3 files: (a) `src/config/competition-allowlist.ts` (~40 LOC with vaaInFlight pattern from #513); (b) `bitflow_get_routes` + `bitflow_swap` modifications (~20 LOC) including `requireCompetitionAllowed: boolean` arg + per-route `competition_allowed` field; (c) new `competition_check_route` tool (~30 LOC).

- **EmblemAI#13 + arkade-os/skill#13 partnership-closes** (cycles v200, v198): Two counterparties (Kukks/Arkade, decentraliser/EmblemAI) silently closed pre-pivot classifieds artifacts within the morning. Confirmed wallet rotation across counterparties (`SP20GPDS5…` canonical, `SP4DXVEC…` retired). Sales DRI motion explicitly signaled retired upstream.

### State-staleness self-corrections (v207 audit findings)

Three instances where my narrative drifted from gh API truth:
1. **v204 "agent-contracts 27d stale"** — wrong; arc had freshly engaged on 5/10
2. **v205 "never sent ack"** — wrong; sent informal ack at 17:58Z 5/10, just lacked @-mention
3. **v201 self-electing #743 reviewer** — wrong; arc APPROVED 7min before my review

Common shape: described state from `daemon/STATE.md` narrative rather than re-checking gh API. **Mitigation codified:** Phase 1 sweep should re-query reviewDecision + recent reviews on priority PRs, not just rely on previous-cycle state narrative.

### Counts movement (verified at v208 boot)

- **landing-page open PRs:** v196: 8 → v208: 8 (#743 NEW since v196; #738/#651/#735 still OPEN; #740 + #741 NEW issues)
- **aibtc-mcp-server open PRs:** v196: 14 → v208: 14 (no movement on #512/#513/#510/#504)
- **agent-contracts open PRs:** v196: ~4 → v208: 4 (#8/#9/#10/#11 — #10 transitioned arc CHANGES_REQUESTED → APPROVED)
- **Total commits across watched repos this window:** ~12 (biwasxyz 7-8 on #738/#743; me 5 in drx4)

### Drift tells active 2026-05-11T12:34Z

- **landing-page#738 merge stuck** ~22h+ since first arc-APPROVE (typical fast-merge on this PR series was <30min) — whoabuddy may be on a different sleep cycle / triage queue
- **landing-page#743 reviewDecision=APPROVED** but no whoabuddy merge action — same gatekeeper bottleneck
- **agent-contracts#8 cluster** static 44d on pbtc21's pegged-dao v2 — my v206 ping is first substantive nudge in 6 weeks
- **mcp-server#504** at 4d+ post-arc-APPROVE, 7d threshold ~5/15 (~3d remaining)
- **x402-sponsor-relay#369** at 5d 14h+ arc-silent, 7d threshold ~5/14 (~2.5d remaining)
- **loop-starter-kit cohort** 20+ days silent on maintainer engagement (cohort-nudge already shipped per archived backlog)

### Patterns codified during this window

- **v204 maintainer-iteration-faster-than-review-cadence → scout-ahead-of-merge becomes load-bearing** (memory/learnings/active.md top entry)
- **v207 ack-comment-without-explicit-@-tag-and-re-review-phrasing** (refined sub-pattern of v204): informal "thanks pushed it" comments without @-tag do NOT reliably trigger reviewer re-engagement. Rule: push-fix + @-tag + explicit "please re-review" phrasing.
- **v207 state-staleness on read-side** (narrative drift between STATE.md and gh API truth) — mitigation: re-query reviewDecision + recent reviews per cycle.

## *** v19 inline patch — what changed since v18 (cycles 2034v167–v196, ~10h) ***

**Major milestones:**
- **Phase 2.5 cache-invariant hygiene cluster SHIPPED (v167–v173, ~2h):** landing-page#726 (cache-invariant single-source extraction MERGED 22:53Z 5/10) + #727 (Cycle 27 absorption MERGED 23:41Z 5/10 — stale-marker check + glob discovery + posture-pattern + pattern coverage + single-source-of-truth refactor; 35min steel-yeti advisory→merge cadence). Convention-refinement issue (Spark simplify + Forge ROUTE_ATTRS bag + comment-accretion debate) proposed in #727 substrate.
- **Phase 2.5 Step 3 series SHIPPED (cycles v180–v193, ~3h window 5/11 02:43Z → 05:36Z):** landing-page#731 (Step 3.2 outbox-write D1) MERGED 02:43Z; #732 (Step 3.3 outbox GET D1 flip) MERGED 03:43Z; #737 (Step 3.4 KV cleanup) MERGED 04:45Z; #739 (Step 3.5 write-path auth → D1 + tenant-discriminator security positive) MERGED 05:36Z. Step 4 (#730 KV-write removal) unblocked, PR not yet filed.
- **Trading-comp Phase 3.1 verifier FULLY APPROVED (cycles v189–v195):** landing-page#738 (biwasxyz) absorbed 4-loop substantive review arc by me: (1) v189 initial review STX event_type fix; (2) v193 pending-cache short-circuit empirical finding + fix landed; (3) v194 idempotency-UX `inserted` flag finding → biwasxyz shipped 409+structured-error+existing_row+readSwap-before-Hiro (stronger than my proposal); (4) v195 final APPROVE on commit 344df7bb. Both arc + me APPROVED, mergeable=CLEAN, awaiting whoabuddy merge.
- **#651 Portfolio leaderboard rebased + APPROVED (v192, 05:30Z):** biwasxyz rebased 12 commits onto main + 2 nit fixups (sentinel TTL 600s + cold-miss poll budget 30s/500ms). My v192 APPROVE named: sentinel_ttl >= 1.3×p99(rebuild) calibration rule + cold-miss cost-ratio framing + multi-track closure (Score track files as follow-up under #652). Awaiting arc + whoabuddy re-clearance + merge.
- **mcp-server Zest fix cluster OPENED + REVIEWED (cycles v195–v196):** arc opened #512 (fresh Pyth VAAs for borrow/collateral-add/collateral-remove-redeem, fixes #476 — closes my v54 issue filed 5/8) + #513 (vaaInFlight dedup + ZestPythUnavailableError + 8 unit tests — implements all 3 of my non-blocking #512 followup-suggestions verbatim). Both APPROVED by me; #512 has stacked APPROVEs at 03:56Z + 06:48Z (second adds TTL/mining-latency clarifying question + defensive hex parse nit + #513-pre-aging-cross-ref).
- **Bitflow STX→stSTX trade executed as Phase 3.1 verifier acceptance test:** txid `fa62f847df933b6b5e5a92f3e6a2b04c80c94b5b488a9277c53a95e9d9baf3c1` broadcast 05:48Z, confirmed block 7929497 (ok u429262), end-to-end verified on preview deploy. Surfaced 2 #738 behavior gaps (pending-cache short-circuit + missing-`inserted`-flag) both fixed in-cycle.
- **#735 partner-dedup APPROVED, awaiting merge.**
- **mcp-server #511 (Sovereign Protocol, azagh72-creator) FLAGGED-NOT-ENGAGED:** 14694 LOC by brand-new author, adds .github/workflows/publish.yml (auto-publish-to-npm), modifies x402.service.ts + mempool-api.ts + scaffold.service.ts, adds btc-chain.ts + universal-bridge.ts + psi-consensus.ts + seed-identity.ts, embeds external "flying-whale-marketplace" inside repo, Arabic philosophical framing. Supply-chain-attack pattern. Operator notified; awaiting whoabuddy security review.

### Phase 2.5 cutover hygiene + Step 3 series end-state (v164 → v196)

| Surface | v164 state | v196 state | Action |
|---|---|---|---|
| `landing-page#722` Step 3.1 inbox-list read flip | MERGED v163 | MERGED + smoke CLEAN | Done |
| `landing-page#726` cache-invariant single-source extraction | n/a | MERGED 22:53Z 5/10 | Done — `lib/inbox/CACHE_INVARIANTS.md` + 1-line pointer comments + posture markers + structural enforcement test |
| `landing-page#727` Cycle 27 absorption | n/a | MERGED 23:41Z 5/10 | Done — steel-yeti Cycle 27 advisory absorbed in 35min via stale-marker check + glob discovery + POSTURE_PATTERN + single-source-of-truth refactor |
| `landing-page#731` Step 3.2 outbox-write D1 | n/a | MERGED 02:43Z 5/11 | Done |
| `landing-page#732` Step 3.3 outbox GET D1 flip | n/a | MERGED 03:43Z 5/11 | Done — sentCount/partners restoration; 8 acceptance criteria; convergent APPROVE arc+me within 4min |
| `landing-page#737` Step 3.4 KV cleanup | n/a | MERGED 04:45Z 5/11 | Done — mechanical KV cleanup post-#732 |
| `landing-page#739` Step 3.5 write-path auth → D1 | n/a | MERGED 05:36Z 5/11 | Done — 4 call-sites moved from app-level toBtcAddress check (403 with leaked existence) to SQL-level WHERE clause (null → 404). New getReplyForMessageFromD1 with tenant-discriminator (from_btc_address = ?) closes false-409-cross-agent edge |
| `landing-page#730` Step 4 KV-write removal | n/a | UNBLOCKED, PR not yet filed | Awaiting whoabuddy to open PR (expected within 1-2 cycles) |
| `landing-page#738` Phase 3.1 verifier (Bitflow trading-comp) | n/a | OPEN, both APPROVED, mergeable=CLEAN | Maintainer ball whoabuddy; 4-loop substantive review arc closed |
| `landing-page#651` Portfolio leaderboard | rebased pending | OPEN, my v192 APPROVE on rebased state | Awaiting arc + whoabuddy re-clearance after biwasxyz's force-push reset approvals |
| `landing-page#735` partner-dedup | n/a | OPEN, APPROVED | Awaiting merge |
| `landing-page#728` Step 3.3 spec | n/a | CLOSED-by-merge via #732 | — |
| `landing-page#725` Step 3.2 spec | OPEN | CLOSED-by-merge via #731 | — |
| `aibtc-mcp-server#512` Zest fresh Pyth VAAs | n/a | OPEN, APPROVED 2x | Awaiting maintainer merge — base PR fixes #476 |
| `aibtc-mcp-server#513` Zest vaaInFlight + typed error + tests | n/a | OPEN, APPROVED | Awaiting maintainer merge — follow-up to #512, stacked branch |
| `aibtc-mcp-server#510` competition trading tools (mine) | OPEN, arc APPROVED | OPEN, my v144 follow-up Q1+Q3+Q4 + nit-PR offer awaiting biwasxyz response (~36h+ silent) | Mirror #738 409 + justSubmitted handling once #738 merges |
| `aibtc-mcp-server#504` mcp #487 Gap 1 (mine) | OPEN, ~3.5d post-arc-APPROVE | OPEN, ~4d+ post-arc-APPROVE (7d threshold ~5/15, ~3d remaining) | Maintainer ball whoabuddy |
| `aibtc-mcp-server#511` Sovereign Protocol (azagh72-creator) | n/a | OPEN, NOT-ENGAGED, security-flagged | Awaiting whoabuddy security review |
| `x402-sponsor-relay#369` (mine, verifyMessage asymmetry) | arc ~3d silent | arc ~5d+ silent (7d threshold ~2026-05-14, ~3d remaining) | Awaiting arc response |
| `agent-contracts#9`/`#10` (mine, security PRs from 4/14) | 26d stale | 27d stale | Drift surface — neither rebase+ping nor close happening |

### Patterns codified during this window (memory/learnings/active.md)

- **v167** scout-pre-position-BEFORE-AUTHORING (extending v159/v166 review-prep lineage)
- **v169** design-pivot mid-implementation when false-positive surface discovered
- **v170** regex-coverage-drift requires structural pinning via pattern-test-block
- **v171** post-merge-multi-lens-advisory as parallel-correctness substrate
- **v172** two-code-paths-diverged-silently as test-coverage failure mode; single-source-of-truth refactor as structural answer
- **v173** fold-actionable-findings / defer-convention-shape split as reusable Cycle-N-absorption posture
- **v179** implementor-cites-reviewer cadence: PR body cites prior PRs + steel-yeti template fields by name (without per-PR reviewer @-mention) — patterns travel without attribution because they're the way the team writes PRs now
- **v181** 6-sec-fast-merge cadence on #731 (whoabuddy mechanical)
- **v182** 2-issue parallel-engagement-burst from arc (7-sec interval between #487 + #476 comments); partnership-density at strongest post-pivot
- **v183** 18-decimal token Score-track-SUM-overflow concern (re-cited from sign-off on #651)
- **v187** post-merge-empirical-verification: STX event_type fix verified on preview deploy via canonical Bitflow STX→stSTX trade fa62f847; surfaced 2 #738 behavior gaps (pending-cache + inserted-flag)
- **v189–v195** 4-loop review arc on #738 with each cycle tighter than the last (6min → 16min → 24min → tightest); empirical-test-then-find shape consistently produced findings stronger than maintainer's proposals
- **v195 lesson recurrence (v145 instance):** drafted second APPROVE on #512 without re-querying state — duplicate framing on stacked review; content additive (TTL question + hex parse nit + cross-ref) but timeline ambiguous. v145 personal-checklist (re-query state before synthesis-style comment >5min drafting) still load-bearing; re-codify as agentic-rather-than-personal habit

### Counts movement (verified at v196 boot)

- **landing-page open PRs:** v164: 9 → v196: 8 (#722 + #726 + #727 + #731 + #732 + #737 + #739 all merged in window; #738 + #651 + #735 + #710 still open; #653 dependabot axios + #645 release + #638 Operator Console + #634 grouped bumps + #621 claims tests + future Step 4 #730)
- **aibtc-mcp-server open PRs:** v164: 11 → v196: 14 (+#512 + #513 + #511; #501 closed by Snyk merge?)
- **Total merged this window (~10h):** 7 landing-page PRs (#722/#726/#727/#731/#732/#737/#739)

### Drift tells active 2026-05-11T06:55Z

- **landing-page#710** still OPEN at v196, ~5+ cycles since last activity — drift candidate
- **aibtc-mcp-server#504** approaching 7d-since-arc-APPROVE threshold (~3d remaining), maintainer-merge-ping queued for v200ish
- **x402-sponsor-relay#369** ~5d arc-silent, 7d threshold ~5/14 — partnership-thread-silent watch
- **agent-contracts#9/#10** 27d stale — drift surface, decision (rebase + ping vs close) still not made

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
