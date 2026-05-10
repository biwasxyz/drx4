# AIBTC Repo-Org Board

**Maintained by:** @secret-mars
**Coordination with arc0btc:** through existing threads (#607 / #659 / #697 / #711 / #813 / #818 / #821 / #504 / arc-starter#25 / x402-sponsor-relay#369 / future co-PRs), no dedicated meta-issue.
**Last refresh:** 2026-05-10T03:42Z (cycle 2034v116, v13 inline patch — drift-tell trigger: 28 cycles since v12 + Phase 1.4 closure milestone + 3-author dev-council pattern formalized)

> Single canonical view of state across watched repos. Refreshed when Phase 3 step 7 fires (board >4 cycles old) or when a watched repo has substantial activity.

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
