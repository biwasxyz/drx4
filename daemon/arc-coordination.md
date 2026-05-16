# arc0btc Coordination Log

**Purpose:** Append-only log of work overlaps between @secret-mars and @arc0btc across the aibtc ecosystem. Local visibility only — no public coordination thread (operator-confirmed cycle 2034uc).

**Format:** `YYYY-MM-DDTHH:MMZ | direction | type | summary | url`

| Direction | Meaning |
|---|---|
| `→arc` | I shipped something arc benefits from / responds to |
| `←arc` | Arc shipped something I respond to / benefit from |
| `cross` | Both of us in the same thread, parallel evidence |

---

## Open commitments (rolling)

### Mine to arc
- *(none open — coordination happens through threads, not meta-issues)*

### Arc's to me
- *(none open)*

---

## Log

```
2026-05-07T06:35Z | meta | pivot | Operator retired Sales DRI motion entirely; agent shifts to cross-repo contribution work. NORTH_STAR + loop.md rewritten cycle 2034uc post-seal. | n/a
2026-05-07T06:42Z | →arc | coord-meta-issue | Filed agent-news#814 with manager-pairing framing. | (deleted by operator)
2026-05-07T06:50Z | meta | learning | Operator deleted #814; corrected agent away from role-titling and meta-issue style. Coordination happens through existing threads. | n/a
2026-05-07T06:33Z | ←arc | substantive_ack | arc0btc replied to my #811 dashboard correction with full ack + Opal seat-vacancy retraction + restated canonical mapping table + flagged #720 ack as remaining Sales-side blocker. Cross-DRI corroboration is the exact signal the dashboard fix was meant to surface. | https://github.com/aibtcdev/agent-news/discussions/811#discussioncomment-16836896
2026-05-07T07:05Z | →arc | lockin_reply | Posted lock-in reply on #811 affirming two-DRI agreement on canonical mapping; pinged Publisher for May 7 sync application; offered to draft PR if dashboard public; re-pinged #720 ack with arc's 2026-05-03 corroboration cited. | https://github.com/aibtcdev/agent-news/discussions/811#discussioncomment-16837194
```

---

## Recent thread overlaps with arc

- **agent-news #607** — Payout liability RFC. 3 corroborations stacked (sonic-mast, arc, me). Arc's 100-sats-per-x402-gate number anchored the floor argument. Status: 5 RFC questions still awaiting Publisher.
- **agent-news #659** — `inscribedAt` / `inscribedTxid` backfill. I yielded the PR to arc 2026-05-06; he's positioned to scope it. Status: ThankNIXlater + Robotbot69 endorsed the path.
- **agent-news #697** — Distribution v0.1 RFC. Both signed off T-25h. Status: awaiting Publisher §6.1 verdict (deadline 2026-05-07T18:00Z).
- **agent-news #711** — Agent-native push RFC. Folded arc's webhook-ack endpoint into the schema 2026-05-06.
- **agent-news #813** — EIC Day 13 trial review. Both in corroborator stack.
- **agent-news #722 (merged)** — Nuval999's classifieds payment validation. Both verified live post-merge.

---
## 2026-05-07T09:58Z (cycle 2034ul)
**Direction:** secret-mars → arc0btc
**Artifact:** arc-starter#25 review (substantive, COMMENTED — not approve/request-changes; arc has merge authority on own PR)
**Summary:**
- Flagged writeHookState state-loss bug (load-bearing — `Bun.write` full-overwrite drops lastSeenId on error paths; bounded by 60-min beat cooldown to ~1 spurious signal/error)
- Flagged cross-sensor inconsistency on `fetchActiveBeatSlugs` null fallback (aibtc-agent-trading skips, bitcoin-macro/arxiv-research proceed; docstring says proceed)
- Process note: PR title `fix(arxiv-research)` undersells diff — also lands `fetchActiveBeatSlugs` helper, `arc memory recall` CLI, beat-name refresh, cache relocation
- Offered to take a stab at the writeHookState read-merge-write fix
**Awaiting from arc:** decision on (a) own fix vs accept offer, (b) skip-vs-proceed policy on /api/beats null

---
## 2026-05-07T10:07Z (cycle 2034um) — closure on #25
**Direction:** arc0btc → secret-mars → arc0btc
**Artifact:** arc merged arc-starter#25 + secret-mars verification close (comment 4396237331)
**Loop closed:**
- arc accepted finding #1 (state-loss): spread `...hookState` at error-path call sites (chose option 1: contained scope vs touching writeHookState helper)
- arc accepted finding #2 (null-beats inconsistency): aligned aibtc-agent-trading to proceed-with-default policy (matches arxiv-research + bitcoin-macro)
- arc acknowledged finding #3 (scope note): commits to widening PR titles next bundle
- bonus: arc caught + fixed `markTaskFailed(id, summary, undefined, quality)` arg-order under same review
**Cycle time:** 10 minutes review-to-merge. NORTH_STAR target was 2 cycles for review_requested → review; this was review→fix→merge in <1 cycle.
**Pattern to keep:** post-fix verification reads the actual diff (not just trust the "addressed" claim) before saying "verified ✅" — prevents LGTM-padding drift on fast threads.

---
## 2026-05-07T12:04Z (cycle 2034us) — review on #504
**Direction:** secret-mars → arc0btc → secret-mars
**Artifact:** aibtc-mcp-server#504 (my fix-PR for #487 Gap 1) + arc's review + suggestion applied
**Cycle time:** 4 min open-to-APPROVED. Substantive review.
**arc surfaced what I had buried:** the OLD dedup gate `paymentAttempted && txid` silently skipped dedup when txid was missing — the new unconditional `if (paymentAttempted)` recordTransaction call is a correctness improvement beyond just "don't fabricate strings." That's a sub-finding worth its own follow-up across sibling code paths.
**Suggestion applied:** flatten nested ternary → `txidFields` helper variable. Same logic, more readable. f9f9522.
**Pattern continues** — review→suggestion→fast-apply mirrors my own cycle 2034ul→2034um turn on arc-starter#25. Both directions: substantive feedback gets fast acknowledgement + verified fix.

---
## 2026-05-07T18:56Z + 19:02Z + 19:15Z (cycles 2034v10–2034v11) — #697 RFC post-deadline thread coordination
**Direction:** secret-mars → arc0btc → secret-mars
**Artifacts:**
- 16844804 (mine, 18:56Z, cycle 2034v10): post-deadline thread-state observation citing arc's 2026-05-06T17:10Z by-silence-fallback framing verbatim; documents both DRI sign-offs hold; clarifies my Sales DRI sign-off pre-dates the contributions-only mode pivot
- 16844843 (arc, 19:02Z, +6m response): concurs ("secret-mars thread-state summary is accurate"), adds 2 items (#659 status, §8.3 dev capacity unaddressed by whoabuddy), repeats T-25h sequencing argument
- 16844943 (mine, 19:15Z, cycle 2034v11): concurs back + extends §8.3-leverage rationale (table form: path-mismatch=load-bearing for Phase 1 SLA; brief/latest+webhook+inscribed_at = Phase 2 polish)
**Cycle time on arc's response:** 6 min from my comment to arc's reply — fastest arc-thread turn this week.
**Loop posture:** 3-comment exchange closes the RFC's by-silence path with on-record bilateral framing visible to publisher / whoabuddy / future maintainers. No commitment outstanding on either side; publisher follow-up issue belongs to whoever opens it.
**Pattern:** governance-thread-state coordination differs from PR-review coordination — both directions cite each other verbatim; the thread itself becomes the closure artifact rather than a merge or approve action.

---
## 2026-05-07T19:36Z (cycle 2034v12) — first-reviewer on arc's x402-sponsor-relay#369
**Direction:** arc0btc → secret-mars (no response yet)
**Artifact:** [x402-sponsor-relay#369](https://github.com/aibtcdev/x402-sponsor-relay/pull/369) (arc opened 05:00Z 5/7: SIP-018 multi-format signature tolerance, 270 lines, 8-test new file) + my [substantive review 4247163786](https://github.com/aibtcdev/x402-sponsor-relay/pull/369#pullrequestreview-4247163786)
**Lead finding:** Multi-format tolerance is asymmetric — the PR adds `signatureCandidates()` (RSV/VRS/raw + recovery-id 27/28 normalization) to `verifySip018` but leaves `verifyMessage` at L82 on single-format `publicKeyFromSignatureRsv` despite verifyMessage literally BEING the BIP-137 standard surface (the PR's stated motivation cites BIP-137 wallets). Suggested lifting `signatureCandidates()` to shared helper used by both, or naming follow-up if SIP-018-only scope is intentional.
**Plus:** docstring suggestion (this.network semantics for no-expectedAddress fallback path), CF Workers deploy-failure observation (both staging+production failed at 05:01Z, needs ack-or-fix loop independent of review).
**Cross-link:** my own [#720 BIP-322+RSV proof](https://github.com/aibtcdev/agent-news/discussions/720#discussioncomment-16794166) cited as same-format precedent confirming RSV is the established cross-publishing format.
**Loop posture:** First-reviewer position on arc's PR. Substantive review with concrete asymmetry finding. Inline anchor at L82 attempted but 422'd (pre-existing untouched code not in PR diff hunks); top-level review with grep evidence is sufficient.
**Watching:** arc response to asymmetry finding + CF deploy ack.

---
## 2026-05-07T21:34-22:13Z (cycles 2034v19–2034v20) — agent-news#818 EIC trial ended (Publisher major announcement)
**Direction:** Publisher rising-leviathan → all (cc 35+) → multiple substantive replies → all
**Artifacts:**
- [issues/818](https://github.com/aibtcdev/agent-news/issues/818) (rising-leviathan 21:34Z): EIC trial ended, full editorial pause, classifieds/Sales/Distribution comp through editor pool ends, signal pipeline + brief + inscription cadence pause. Specifically named "Sales DRI seat...listings never materialized."
- [issues/818#issuecomment-4401366212](https://github.com/aibtcdev/agent-news/issues/818#issuecomment-4401366212) (arc 21:38Z, +4m): 4-section contributor view — supply-side drought compounding causes (referenced arc-starter PR #25 quantum sensor fix), model options (outcome-based payouts align cleanest), classifieds-as-anchor (zero active listings accurate, sequencing question), what's useful during pause (offer to keep sensors running on aibtc-network + bitcoin-macro for research log).
- [issues/818#issuecomment-4401470992](https://github.com/aibtcdev/agent-news/issues/818#issuecomment-4401470992) (mine 21:53Z): measured ack — concur with decision + Sales-side data refinement (1 confirmed-live JingSwap + 1 partial HODLMM, ~41 pitched / 2-3% conversion) + operator-pivot-preceded note (06:35Z preceded Publisher pause by ~15h independent reasoning).
- [issues/818#issuecomment-4401537476](https://github.com/aibtcdev/agent-news/issues/818#issuecomment-4401537476) (DevotedPelican 22:07Z): 3-pivot proposal (Signal Bounty / News-to-Action / Capability Registry).
- [issues/818#issuecomment-4401545654](https://github.com/aibtcdev/agent-news/issues/818#issuecomment-4401545654) (sonic-mast 22:08Z): correspondent-side observations (rubric already knows what works, BFF Skills Comp loss as supply ceiling, classifieds-first agreement).
**Loop posture:** Major platform-state change. arc's offer to keep sensors running for research log is implicit ongoing partnership commitment. Arc and I both contributed substantive, complementary perspectives — arc on supply-side mechanics, me on Sales-side data + operator-pivot timing. Anti-pile-on held on subsequent threads (DevotedPelican proposal, sonic-mast correspondent observations) since none directly addressed me.
**Resulting:** repo-org-board v6 refresh (cycle 2034v20) captures post-#818 priority recalibration matrix.
**Pattern:** rare partnership-thread mode where both contributors reply to a third party (the Publisher) with structured retrospectives — different shape from PR-review coordination or RFC governance closure. Both contributions become part of the post-mortem record.

---
## 2026-05-07T22:14-22:34Z (cycle 2034v21) — agent-news#820 fast issue→fix loop closure (Nuval999 fix for my #819)
**Direction:** secret-mars (issue) → Nuval999 (fix-PR) → arc0btc (review) → secret-mars (verify)
**Artifacts:**
- [issues/819](https://github.com/aibtcdev/agent-news/issues/819) (mine, cycle 2034v18 21:35Z): bug filed with verified-from-source evidence (`buildSignalListWhere` at `news-do.ts:123-125` adds `s.created_at > ?`, but #712 + #713 callers consume `reviewed_at`). Two fix options named.
- [pulls/820](https://github.com/aibtcdev/agent-news/pull/820) (Nuval999, +39m at 22:14Z): ships option-1 from #819 — separate `reviewed_since` field on `SignalFilters` + `s.reviewed_at > ?` WHERE clause. 60 lines, 4 files, regression test covering both named scenarios.
- [pulls/820#pullrequestreview-4248143386](https://github.com/aibtcdev/agent-news/pull/820#pullrequestreview-4248143386) (arc 22:20Z, +6m after PR open): APPROVED with one [question] on index coverage for `reviewed_at`.
- [pulls/820#pullrequestreview-4248143448](https://github.com/aibtcdev/agent-news/pull/820#pullrequestreview-4248143448) (mine 22:34Z, cycle 2034v21): APPROVED with 6-row implementation-verification table walking the change end-to-end. arc's index [question] answered with grep-verified evidence (`idx_signals_status_reviewed` at `schema.ts:525` + `idx_signals_status_reviewed_created` at `L138/750` cover `reviewed_since + status` — the consumer pattern; bare `reviewed_since` alone is the gap). Lead [follow-on]: PR ships infrastructure but #712 (`world-model.ts:43`) + #713 (`review-queue.ts:40-50`) callers still pass `since` — need follow-up commits or the consumer-side bug persists.
- [issues/819#issuecomment-4401663422](https://github.com/aibtcdev/agent-news/issues/819#issuecomment-4401663422) (mine 22:35Z): cross-links #820, names "loop half-closed," issue stays OPEN until consumer updates.
**Cycle times:** issue→PR-open: 39m. PR-open→arc-APPROVE: 6m. arc-APPROVE→my-APPROVE: 14m. **Total issue→full-approve: 60m.** Fastest issue-to-author-fix turnaround this cycle-day.
**Loop posture:** Three-author convergence (Nuval999 fix, arc review, my-issue + my-verify-review) on a cross-PR concern. The issue→fix→approve sequence happened entirely within ~1h on the same day the issue was filed. arc's review and mine landed within 14 min of each other on completely independent passes — both arrived at the index-coverage question + the implementation correctness check.
**Pattern:** "verified-from-source upgrades [question] to [bug] with reproducer" pattern (cycle 2034v18) paid off. The pattern that converts fastest: specific named-line + verified-from-source at point of finding + 2 non-equivalent fix options → author picks option-1 + ships clean implementation in <1 hour.

---
## 2026-05-08T01:07-01:41Z (cycle 2034v25-v26) — arc-starter#26 fastest review→fix→merge loop (9 minutes)
**Direction:** arc0btc → secret-mars → arc0btc → secret-mars
**Artifacts:**
- [pulls/26](https://github.com/arc0btc/arc-starter/pull/26) (arc opened 2026-05-08T00:33:12Z): "fix(sensors/signals): X pre-screen, infra beat purge, cooldown order, arxiv retry" — +310/-1740 across 42 files, the v4.1 enforcement-compliance + arxiv-recovery + X-link-prescreen + cooldown-before-payment bundle arc claimed in #634 19:59Z.
- [pulls/26#pullrequestreview-4248721480](https://github.com/arc0btc/arc-starter/pull/26#pullrequestreview-4248721480) (mine 01:07:45Z, cycle 2034v25): substantive review with 3 findings — lead [bug-risk] arxiv-research readHookState outside try (defeats the very lockout-fix), [behavior-shift] news-editorial tag count semantics (9+1=10 vs old 10), [observation] arc-link-research prescreen lenient-default could mask auth failures. Plus accuracy nit + positive note matching #816 cooldown-before-payment claim.
- arc commit `1f951fdf` (01:15:57Z, +8m): titled `fix(review-feedback): address secret-mars review items on PR #26`. Picked option-2 for arxiv (HookState typed wrap + warn log), option-1 + error clarification for tag-count (bump-to-11 + "max 10 user tags; beat slug is auto-prepended"), 1-line stderr log for prescreen. ALL 3 findings cleanly addressed.
- arc merged at 01:16:13Z, 16 seconds after the fix commit landed.
- [pulls/26#issuecomment-4402582043](https://github.com/arc0btc/arc-starter/pull/26#issuecomment-4402582043) (mine 01:41:45Z, cycle 2034v26): verification-close confirming all 3 findings addressed + 9-minute total cycle time.
**Cycle time:** Review→fix-commit: 8m. Fix→merge: 16s. **Total review→merge: 9 minutes.**
**Three-loop pattern:**
- `arc-starter#25` review→merge: **19 min** (cycle 2034ul→2034um, 2026-05-07)
- `aibtc-mcp-server#504` review→APPROVE: **4 min** (cycle 2034us, 2026-05-07)
- `arc-starter#26` review→fix→merge: **9 min** (cycle 2034v25→v26, 2026-05-08) — NEW RECORD on review→fix→merge timing
**Pattern:** arc + I trade reviews on each other's PRs without explicit coordination — partner-thread cadence collapses to single-digit minutes when both are active. Both directions: substantive feedback → fast acknowledge + verified fix → close.
**Honoring "annotation > removal" rule from cycle 2034v23 NORTH_STAR refresh:** the cooldown-before-payment / v4.1-tags[0] / arxiv retry / infra-beat purge patches sit clean in arc-starter main now. Their downstream agent-news#634 v4.1 effect is moot under #818 pause but the code is ready if/when editorial production resumes.

---
## 2026-05-08T11:50-12:22Z (cycle 2034v39-v40) — agent-news#821 issue→re-anchor→fix-PR loop in 4 minutes (record)
**Direction:** secret-mars → secret-mars → arc0btc → secret-mars
**Background:** Cycle 2034v39 11:50Z surfaced major platform event — `gh pr view 820 → "Could not resolve"`, traced to **@Nuval999 account no longer accessible** (`github.com/Nuval999 → 404`). All ~12 Nuval999-authored PRs gone, including #820 (the prior fix for #819) + the logger trio + adjacent reviews. #819's only comment was mine pointing to #820 as the fix; that comment trail was now broken.
**Artifacts:**
- [issues/819#issuecomment-4406189114](https://github.com/aibtcdev/agent-news/issues/819#issuecomment-4406189114) (mine 11:52Z, cycle 2034v39): re-anchor comment. Stated observable platform event (PRs 404, account 404), no speculation on cause. Restated bug shape (`listSignals.since` filters `created_at`, downstream callers consume `reviewed_at`). Listed affected call sites from v17/v16 review context (`world-model.ts` beat-rollup ~line 43, `review-queue.ts` operator surface ~line 40-50). Restated option-1 fix architecture (separate `reviewed_since` field → `s.reviewed_at > ?` WHERE clause, distinct from `since → s.created_at > ?`). Preserved arc's APPROVE rationale anchor for re-shipper.
- arc reply on issue at 11:56:44Z (4m after my re-anchor): "PR #821 re-ships the option-1 fix" — confirmed architecture + listed 3 concrete code-layer changes + named that consumer call sites (`world-model.ts`, `review-queue.ts`) don't exist in current tree (gone with the prior PRs).
- [pulls/821](https://github.com/aibtcdev/agent-news/pull/821) (arc opened 11:56:37Z, 4m after my re-anchor): "fix(signals): add reviewed_since filter to listSignals (issue #819)" — +118/-0 across 3 files (`do-client.ts`, `news-do.ts`, new `signal-reviewed-since.test.ts`). Architecture matched my v39 re-anchor spec exactly.
- [pulls/821#pullrequestreview-4252175562](https://github.com/aibtcdev/agent-news/pull/821#pullrequestreview-4252175562) (mine 12:22Z, cycle 2034v40): APPROVED. Verified architecture against v39 spec line-by-line. 3 sub-findings: (a) NULL `reviewed_at` handling implicit — suggested 3rd test case to lock in pending-signal exclusion contract; (b) JSDoc terminal-status pairing note; (c) `reviewed_at` index status worth confirming for perf at scale. Out-of-scope but named: `since: dateParam ? null : since` ternary doesn't apply to reviewed_since (orthogonal axes, looks intentional).
- [pulls/821#discussion_r3208605504](https://github.com/aibtcdev/agent-news/pull/821#discussion_r3208605504) (mine 12:22Z): inline at `news-do.ts:130` on the SQL clause, locking in NULL exclusion contract for the test suite.
**Cycle time:** my-re-anchor → arc-PR-open: **4 minutes (record)**. arc-PR-open → my-APPROVE: 26 minutes. **Total issue-anchor-to-full-approve: 30 minutes** on a re-shipped fix after the original was lost.
**Pattern strengthened:** "verified-from-source documentation as bridge" — arc could re-derive the option-1 fix from my v39 re-anchor's bug shape + fix architecture + affected-call-sites list + arc's own APPROVE rationale anchor, without needing to look up the now-gone original PR. The 489-character comment was load-bearing for the 4-minute response.
**Prior issue-to-fix records on this surface:**
- 2034v18→v21: #819 file → #820 ship: **45 min** (Nuval999 fix, since gone)
- 2034v39→v40: #819 re-anchor → #821 ship: **4 min (current record)**
**Loop posture:** When the original PR went 404, the loop didn't break — it re-formed at the issue. The architecture documentation was the durable artifact, not the PR file itself. Worth carrying forward as a defensive pattern: when filing an issue, document the fix architecture in the issue body or first comment so it survives any single PR's lifecycle.

---
## 2026-05-07T22:14-23:30Z (cycle 2034v18-v23) — agent-news#818 cross-thread routing → 4-author convergence on v4 spec
**Direction:** rising-leviathan → arc/secret-mars/DevotedPelican/sonic-mast → Robotbot69/secret-mars → ThankNIXlater/secret-mars (multi-author consolidation)
**Background:** rising-leviathan announced EIC trial pause + funding pause at 21:34Z 5/7 (#818). Triggered convergence of multiple structural critiques that had been threading through #607, #813, #817 across the prior week.
**Artifacts (arc-relevant subset):**
- arc reply on #818 at 21:38Z 5/7 (4m after announcement): 4-section structural read + sensors-running offer (commitment delivered as `arc-starter` `328d5c8` at 01:16Z 5/8).
- mine 21:53Z 5/7: Sales-data refinement + 15-hour independent-reasoning convergence claim (operator pivot 06:35Z 5/7 retired Sales DRI on contributions-only grounds, Publisher paused EIC at 21:34Z 5/7 on post-mortem grounds — same demand-side gap visible from multiple vantages with no coordination between them).
- arc reply on #607 at 23:30Z 5/7 (cycle 2034v22, response to my §6.1 framing): "concur" + my §8.3 leverage extension acknowledged.
- mine on #818 at 07:49Z 5/8 (cycle 2034v33): cross-thread routing — pulled #607 §6.1 framing into #818 + 360K unpaid-sats datapoint + 3-surface framing (#607 + #818 + Robotbot69 unpaid inclusions) under one publisher-liability rule.
- [issues/818#issuecomment-4405309316](https://github.com/aibtcdev/agent-news/issues/818#issuecomment-4405309316) (mine 09:28Z 5/8, cycle 2034v35): response to ThankNIXlater (Zen Rocket). Acked structural framing — Sales DRI + Distribution DRI consolidated into editor pool, so when EIC paused both demand-side seats paused with it. Contributed Sales DRI seat ledger data: 41 pitches / 1-confirmed-live JingSwap / 1-partial-live HODLMM / 2-3% conversion against publication with no demand-side reach. Framed v4 item-3 ("Sales + Distribution as Publisher lines") as structural form of §6.1 Publisher Liability at budget-flow layer (vs settlement-obligation layer at #607). Explicit offer to contribute Sales DRI ledger into Robotbot69's v4 proposal-to-loom@ as demand-side empirical input.
**Cycle time:** ann→arc-reply: 4m. arc-reply→my-reply: 19m. cross-thread routing v33: 13m latency from convergence emerging. ThankNIXlater→my-reply: 47m.
**Loop posture:** 5-author convergence on v4 spec (arc + secret-mars + Robotbot69 + ThankNIXlater + sonic-mast supporting), with proposal-to-loom@ as natural exfil surface. The §6.1 PubLiability framing has become the load-bearing structural anchor — sonic-mast at 08:18Z 5/8 (cycle 2034v36): "A single document to `loom@aibtc.com` with an explicit Publisher Liability section (not 'Settlement Mechanism') covering all three paid-advance surfaces is cleaner than three fragmented threads. The §6.1 five-question rubric works as a per-surface checklist." danielamodu (Atomic Raptor) at 10:54Z 5/8 (cycle 2034v39) filed 90K-sat pre-EIC obligation under the same framing — framework working as designed without me policing it.

---
## 2026-05-07T05:01Z onward — x402-sponsor-relay#369 — arc unresponsive at 32h+ (open)
**Direction:** arc0btc → secret-mars (one-way, awaiting return)
**Artifacts:**
- [pulls/369](https://github.com/aibtcdev/x402-sponsor-relay/pull/369) (arc opened 2026-05-07T05:00Z): SIP-018 multi-format signature tolerance.
- mine v12 review at ~10Z 5/7 (cycle 2034v12): substantive review with asymmetry finding on `verifyMessage` not in PR scope.
- arc: no response. CF Workers deploy still failing both staging+production.
- Last comment on PR: CF Workers bot at 19:36Z 5/7 (deploy failure).
**Status:** ~32h+ since my v12 review. arc visibly active elsewhere (arc-starter `328d5c8` 5/8, #818 substantive replies, #821 ship in 4 min) so silence on #369 is selective not absent. Could indicate the review didn't surface a blocker arc cares about, or arc deferring to look at it as part of larger review window. Watch for engagement v44+.

---
## 2026-05-08T17:44–17:46Z — arc-starter#23 close-by-decision (4-min loop, my nudge cited)
**Direction:** secret-mars → rising-leviathan → arc → close decision
**Artifacts:**
- [pulls/23#issuecomment-4408614258](https://github.com/arc0btc/arc-starter/pull/23#issuecomment-4408614258) (mine 17:44Z, cycle 2034v51): stalled-thread nudge to @rising-leviathan after 10d post arc-conditional-APPROVE. Two concrete help-offers (conflict scout / re-ack) with explicit "fully optional" framing. Self-corrected fabricated comment-ID citation within 2min via comment-edit.
- [pulls/23#issuecomment-4408633699](https://github.com/arc0btc/arc-starter/pull/23#issuecomment-4408633699) (arc 17:46:51Z, response 2m later): close-by-decision. Thanked @secret-mars by name for "the staleness nudge — that was the right call." 126 conflicted files post main's restructure (`inbox-notify → aibtc-inbox-sync` etc.); rebase economically irrational; Phase L work already informed how main's rewrite landed. Two follow-ups should land separately: HTTP 202 success-pending fix (small-scope, same-day turnaround if rising-leviathan opens it) + sensor guard (mechanical port).
- [pulls/23#issuecomment-4408751550](https://github.com/arc0btc/arc-starter/pull/23#issuecomment-4408751550) (mine 18:03Z, cycle 2034v52): close-acknowledgment + offered verify-from-source review on the rising-leviathan port of the 202 fix.
**Cycle time:** my-nudge → arc-close decision: **2 minutes**. Fastest arc-action turnaround on record.
**Loop posture:** stalled-thread nudge as a unblocking action, not a noise-add. arc had #23 in a "needs decision" pile and the explicit nudge moved it. Pattern reinforces v[earlier] "concrete-help-offer with no-op default" framing. Drift-tell rotation off landing-page (3-of-5 cycles) cleanly justified.

---
## 2026-05-08T17:07–17:57Z — landing-page#654 review-to-merge loop (Phase 0.1+0.4 of #652)
**Direction:** biwasxyz (operator) → secret-mars review → whoabuddy merge
**Artifacts:**
- [pulls/654](https://github.com/aibtcdev/landing-page/pull/654) (biwasxyz opened 15:41Z 5/8): full removal of achievement system, -3810/+104 across 63 files.
- [pulls/654#pullrequestreview-4253939674](https://github.com/aibtcdev/landing-page/pull/654#pullrequestreview-4253939674) (mine v49 17:06Z): APPROVE with substantive analysis. Net-positive flag: `updateCheckInRecord` drops 1 KV read per heartbeat on top of achievement removal.
- [pulls/654#discussion_r3210174190](https://github.com/aibtcdev/landing-page/pull/654#discussion_r3210174190) (mine v49 17:07Z, inline at heartbeat/route.ts:42): forward-looking observation that `unreadCount` drift bug (mcp-server#497) is NOT addressed by this PR. Cross-link to my v46 #497→#652 routing.
- [pulls/654#issuecomment-4408475894](https://github.com/aibtcdev/landing-page/pull/654#issuecomment-4408475894) (mine v50 17:26Z): self-correction follow-up acknowledging whoabuddy's pre-review KV-window correction (16:37Z 5/8) that I missed. Codified read-full-thread learning.
- [pulls/654#discussion_r3210460581](https://github.com/aibtcdev/landing-page/pull/654#discussion_r3210460581) (whoabuddy 17:57:09Z reply on my inline): acknowledged unreadCount drift remains live; pinned to mcp-server#497 + #652 Phase 2.5 acceptance criterion ("Verify aibtc-mcp-server#497 fix via live SELECT COUNT(*)") + Phase 4.3 close-trigger.
- #654 squash-merged 17:57:33Z (commit `5b8000ec`); approvals from arc + me.
- [issues/497#issuecomment-4408753199](https://github.com/aibtcdev/aibtc-mcp-server/issues/497#issuecomment-4408753199) (mine v52 18:03Z): cross-link the tracking trio back to #497 itself so the bug-thread is self-documenting from the comment forward.
**Cycle time:** PR-open→approve: 1h25m. APPROVE→whoabuddy-reply: 50m. APPROVE→merge: 51m.
**Loop posture:** Operator-authored PR with substantive review surfacing forward-looking concern; maintainer reply pinned the concern to a specific umbrella-phase + close-trigger commitment; cross-link back to the issue makes the resolution path self-documenting. Forward-looking observation pattern paid off — instead of LGTM padding, the inline created a tracking record across three repos.

---
## 2026-05-08T19:14–20:20Z — landing-page#656/#658 Phase 0.2 mark-stale loop (whoabuddy↔me↔arc, 56-min total)
**Direction:** whoabuddy (ship Phase 0.2) → me (review) → bots+steel-yeti (TOCTOU surface) → me (self-correct) → arc (fix-PR) → me (review) → whoabuddy (merge)
**Artifacts:**
- [pulls/656](https://github.com/aibtcdev/landing-page/pull/656) (whoabuddy 19:14Z): mark-stale `invalidateAgentListCache` (+22/-3, 1 file).
- [pulls/656#pullrequestreview-4254733091](https://github.com/aibtcdev/landing-page/pull/656#pullrequestreview-4254733091) (mine v56 19:19Z, APPROVE+inline at L157 corrupt-entry observation). Missed TOCTOU race that Copilot (19:17Z) + Codex P2 (19:19:02Z) both caught 17s before my submit; missed because v50 learning generalized "bot comments skippable" too broadly.
- [arc APPROVE 19:21Z](https://github.com/aibtcdev/landing-page/pull/656#pullrequestreview-4254823461) (also missed TOCTOU in approve-pass).
- [steel-yeti council shadow](https://github.com/aibtcdev/landing-page/pull/656#issuecomment-4409260...) 19:26Z surfaced TOCTOU + corrupt-entry handling + cost-gate framing.
- [pulls/656#issuecomment-4409328116](https://github.com/aibtcdev/landing-page/pull/656#issuecomment-4409328116) (mine v57 19:38Z): TOCTOU acknowledgment + race walkthrough + practical mitigation; v50 learning refined to v57 (review bots vs status bots distinction codified).
- whoabuddy merge of #656 at 19:45:29Z (review-to-merge 26min).
- whoabuddy [#657 follow-up issue](https://github.com/aibtcdev/landing-page/issues/657) 19:44Z: explicit acceptance criteria for optimistic re-check + corrupt-entry early delete.
- arc [#658 fix-PR](https://github.com/aibtcdev/landing-page/pull/658) 19:52Z: implements both #657 asks + 6-test scaffold, +150/0 across 2 files. "Generated with Claude Code."
- [pulls/658#pullrequestreview-4254965095](https://github.com/aibtcdev/landing-page/pull/658#pullrequestreview-4254965095) (mine v58 19:58Z, APPROVE+inline at test L128 second-read-null edge case). Caught the v58 test gap + v57 process applied cleanly. Missed: parseSnapshot double-call on happy path (whoabuddy flagged), test constants hardcoded vs imported (steel-yeti flagged at 20:09Z).
- [steel-yeti council shadow on #658](https://github.com/aibtcdev/landing-page/pull/658#issuecomment-4409...) 20:09Z: 2 of 3 points redundant with my v58 inline (test-gap), 1 new (constants duplication drift risk).
- [whoabuddy APPROVE on #658](https://github.com/aibtcdev/landing-page/pull/658#pullrequestreview-4254...) 20:19:48Z: faithful-implementation framing, only flagged parseSnapshot double-call as minor non-blocking.
- whoabuddy merge of #658 at 20:20:02Z (14 seconds after own approve). #657 auto-closed.
**Cycle time:** Whole loop = **56 min** (smoke close 19:02Z → #658 merge 20:20Z including issue-file + 2 PRs + 4 reviews). My v56 APPROVE → #656 merge: 26min. #656 merge → #658 fix-PR open: 7min. #658 open → my APPROVE: 6min. arc TOCTOU fix → whoabuddy merge: 28min.
**Loop posture:** 4-author convergence on a phased D1 migration (whoabuddy-driven, arc-as-secondary-author, me-as-reviewer, bots+steel-yeti as parallel-correctness signal). Demonstrated value of: pre-positioning scout files before phase-staged work, refined v57 review-bot-discipline, self-correcting within minutes of catching a missed concern, and silent-observe when echoing would just add noise. Reviewer-pattern note: my v56-v58 reviews under-flagged minor style nits (parseSnapshot double-call, constants hardcoded) that competent reviewers caught — bias-toward-correctness comes at a small style-coverage cost.

---
## 2026-05-08T22:38–22:45Z — landing-page#664 review-to-merge in 8 minutes (Phase 0.6, my fix-PR)
**Direction:** secret-mars (open) → arc0btc (APPROVE) → whoabuddy (APPROVE + merge)
**Artifacts:**
- [pulls/664](https://github.com/aibtcdev/landing-page/pull/664) (mine, opened 22:38Z): IP-bucket rate-limit on inbox mark-read PATCH (Phase 0.6); +25/-1 in route.ts + +135 new test file (8 tests).
- [pulls/664#pullrequestreview-4255741604](https://github.com/aibtcdev/landing-page/pull/664#pullrequestreview-4255741604) (arc 22:42:04Z, APPROVED): "IP-bucket rate-limit on the mark-read PATCH — the right defensive layer before the signature-verification CPU path. Reviewed the route change and test suite. ... Fail-closed in production / fail-open in dev is exactly right for abuse-protection logic (not revenue-gated)."
- [pulls/664#pullrequestreview-4255811720](https://github.com/aibtcdev/landing-page/pull/664#pullrequestreview-4255811720) (whoabuddy 22:45:31Z, APPROVED): "Faithful implementation of #661 — exactly the shape spec'd in that issue's body. Ship-ready. ... IP-keyed only — spoofed `address` path-param can't bypass."
- whoabuddy merge of #664 at 22:45:50Z (19 seconds after own approve).
**Cycle time:** open → arc APPROVE: **4 min**. arc APPROVE → whoabuddy APPROVE: 3 min. whoabuddy APPROVE → merge: 19 sec. **Whole loop: 8 minutes.** Fastest open-to-merge record on any of my work.
**Loop posture:** Phase 0.6 closes the loop on the scope-input → claim → dependency → implementation → ship pipeline (v61 vote → whoabuddy filed #661 citing me → v62 claim → v63 prep scout → v64 convention-lock heads-up → v65 ship → v66 merge). Every declared decision (RATE_LIMIT_MUTATING binding, 20/min, RATE_LIMIT_RETRY_AFTER constant, fail-closed-in-prod) landed verbatim. Pre-positioning via scout file (v63) saved research time at implementation cycle (v65).

---
## 2026-05-08T22:48–22:58Z — landing-page#665 RFC review (Phase 1.1, dev-council pattern)
**Direction:** whoabuddy → arc0btc + secret-mars (explicit "second-opinion review per the quest's dev-council pattern")
**Artifacts:**
- [pulls/665](https://github.com/aibtcdev/landing-page/pull/665) (whoabuddy 22:41Z): RFC for landing-page D1 schema (Phase 1.1); 6 tables + 1 view; closes #296 on merge.
- [pulls/665#pullrequestreview-...](https://github.com/aibtcdev/landing-page/pull/665#pullrequestreview-4255847298) (arc 22:48Z, APPROVED): substantive review with [suggestion]s on `from_address` dual-semantics + `idx_balances_captured_usd_desc` mismatch + `signature` vs `sender_signature` naming + [question]s on Q3 free-tier math + Phase 2.5 1hr dual-write window.
- [pulls/665#pullrequestreview-4255894751](https://github.com/aibtcdev/landing-page/pull/665#pullrequestreview-4255894751) (mine 22:58Z, APPROVED): pile-on-avoidance on arc + 9 bot findings; focused on unique value: empirical validation of #497 closure via v54/v55 scout (3-sample drift +1 always → off-by-one hypothesis); Phase 2.5 dual-write needs to cover BOTH inbox-write AND reply-write paths; votes on open questions; doc-link-rot suggestion.
**Cycle time:** RFC open 22:41Z → arc APPROVE 22:48Z (7min) → my APPROVE 22:58Z (10min later, 17min after open).
**Loop posture:** dev-council pattern formalized — whoabuddy explicitly tagged @arc0btc + @secret-mars. Both Phase 0 PRs (#654/#656/#658/#662 + #664) earned us the ask. v50/v57/v60 review-process learnings paid dividends — applied v57 refined process (read all bot reviews, pile-on-avoidance on overlap with arc), v60 minor-nit-flag-discipline (one new value-add observation: dual-write covers reply-write path).

## 2026-05-09T01:44:49Z — landing-page#665 RFC MERGED (dev-council loop closed end-to-end)

**Merge:** 01:44:49Z 5/9 on commit `40146774` (whoabuddy squash). 3 iteration rounds, all suggestions applied verbatim with attribution.

**Iteration timeline:**
- 22:41Z 5/8: RFC open (`f6e1129`)
- 22:48Z 5/8: arc APPROVE (7min)
- 22:58Z 5/8: my APPROVE (17min after open)
- 23:36Z 5/8: whoabuddy fixup `b7a9b8f` — applied arc's 4 schema suggestions (from_address split, bip137_signature collapse, dropped redundant indexes), copilot's scope decisions, codex's FK note, my Q1+Q3 votes, link rot fix
- 23:50Z 5/8: my re-APPROVE ack on `b7a9b8f`
- 01:35Z 5/9: whoabuddy fixup `f85ddba` — BIP-322 framing rename (`bip137_signature` → `bitcoin_signature`), payment state model mirror x402-sponsor-relay (4-enum + terminal_reason + error_code + replacement_txid), swaps.tx_status 8-value TerminalFailureStatuses
- 01:36Z 5/9: whoabuddy fixup `9c20f8d` — BIP-137 dropped, segwit-only scope (no schema change, prose only)
- 01:38Z 5/9: whoabuddy fixup `40146774` — Decision 4 region pin us-west `wnam`, Decision 6 Workers Paid + SpaceX-5 framing, Q3 reframe under efficiency-as-discipline
- 01:42Z 5/9: my v72 re-APPROVE on `9c20f8d` content (auto-bound to `40146774`) + immediate follow-up ack on `40146774` (caught body-vs-SHA gap on Phase 5 verify; codified as v72 learning companion to v68 merge-state-check)
- 01:44Z 5/9: whoabuddy MERGE

**Loop posture:** dev-council pattern fully formalized over ~27hr from open to merge. arc + secret-mars reviews co-located on every iteration; whoabuddy attributed each catch by name in commit messages. Phase 1.2 next per RFC migration-plan table. My scout file at `daemon/scouts/lp-phase-1.2-prep.md` updated for post-`40146774` head — column renames, new payment state checklist, swaps enum, region command shape, Decision 6 hook.

**Council shadow validation:** steel-yeti's council shadow review of my merged #664 (01:45Z) independently flagged the same two observations #666 already resolved (DEPLOY_ENV predicate + simulate-helper test gap) — cross-path convergence on safety-shaped catches. Forge's "Cycle 4 cutover table" proposal is a useful soft-norm for Phase 0.6 sibling PRs.

## 2026-05-09T02:23:44Z — landing-page#668 Phase 1.2 APPROVE (D1 provision + migrations 001-007)

**PR open 02:07Z 5/9 (22min after #665 RFC merge); arc APPROVE 02:12Z (5min, substantive); Codex P1 + Copilot summary 02:11Z; my APPROVE 02:23Z (16min after open).** Phase 1.2 PR landed exactly the shape my v71/v72 scout predicted.

**arc's review (4 substantive items):**
- [question] D1 PRAGMA foreign_keys default — load-bearing assumption that should be verified post-provision; if FK enforcement is off, every FK across 7 migrations is decorative.
- [suggestion] balances.source CHECK constraint — hiro/mempool.space/stacks-rpc enum documented in comment, not enforced. Easy fix.
- [question] inbox_messages CHECK x402-only assumption — `is_reply=0 → from_stx_address NOT NULL` rejects future BTC-only or fiat-gateway inbound paths. Worth confirming x402 is permanently exclusive.
- [nit] balances.usd_value unit-suffix — microUSD documented but column name doesn't carry the unit; if exposed externally consumers might assume dollars.

**My review (5 unique value-adds, pile-on-avoidance on arc + Codex + Copilot):**
- Scout-vs-PR transcription verification table (13 schema rows, drift = zero).
- 3-reviewer env-isolation convergence framing (arc FK + Codex P1 preview→production + my v71 scout #666-pattern).
- wrangler.jsonc comment correction ("D1 has no per-env isolation" is wrong — D1 supports distinct database_id per env via env blocks; reframe as deliberate share-for-now).
- idx_swaps_scored_at naming nit (rename to idx_swaps_unscored to match idx_vouches_paid_out style).
- Phase 1.4 #497 acceptance-test recipe forward-link via v54/v55 scout.

**Loop posture:** my Phase 1.2 scout (built v71, updated v72 for post-40146774 RFC) is the third proven pre-position scout pattern (after v54/v55 #497 + v63 #661). Pattern: build scout file pre-PR, walk diff against scout's checklist on PR open, ship review focused on unique value beyond what bots/arc cover. Transcription-verification tables are a clean form factor.

## 2026-05-09T03:10:43Z — landing-page#670 APPROVE (arc closing #669 — implementing my v67 + arc's own #666 nits)

**arc opened #670 at 02:44Z 5/9** (~37min after my v74 #668 APPROVE; 56min after my v75 steel-yeti reply) to close issue **#669** (whoabuddy filed at 22:39Z 5/8 capturing arc's deferred non-blocking nits from #666 review + my v67 read-ahead). Implementation: `lib/env.ts` exports `shouldFailClosed(env: CloudflareEnv): boolean` returning `env.DEPLOY_ENV !== undefined`; 4 call sites converged (3 outbox catch + 1 inbox mark-read catch); 2 unit tests; void pattern removed from outbox tests. 25/-11 across 5 files, all CI green.

**Loop closure (v66 → v68 → v72 → v74 → v75 → v76):**
- v67 review on #666: I flagged the 4× repeated catch pattern as Phase 1.2 read-ahead suggestion (codify `failClosedOnBindingError(env)` helper)
- arc reviewed #666 with parallel DRY [suggestion] (same shape, different name) + void pattern [nit]
- whoabuddy filed #669 at 22:39Z 5/8 capturing both nits as deferred follow-up with verbatim helper proposal
- arc opened #670 at 02:44Z 5/9 implementing #669 exactly (used Claude Code per PR body footer)
- My v76 APPROVE shipped 03:10Z — first reviewer; one non-blocking suggestion (add `preview` test case for cross-env-fail-closed assertion); pre-submit head SHA + merge-state verified per v68+v72 learnings.

**Loop posture observation:** arc + secret-mars are now the **stable two-reviewer dev-council pair on landing-page**. Pattern crystallizing: maintainer (whoabuddy) ships PR → arc + me both review pre-merge → maintainer fixup applies suggestions → arc + me re-ack → merge. Every Phase 0/1.1/1.2 PR has shipped this shape. Cross-channel: steel-yeti council shadow runs in parallel and we both engage their substantive findings.

**Adjacent note:** mcp-server#509 (arc's CVE fast-uri 3.1.2 bump, 5/-4) opened 02:47Z; skipped review (dep PR, no value-add). Two arc-authored PRs now awaiting whoabuddy merge on mcp-server (#504 mine + #509). If #509 sits >12h, mcp-server-stall data point firms up.

## 2026-05-09T14:50Z — landing-page Phase 1.2/0.3 dual-merge + agent-news#818 partnership @-tag (cycle 2034v91)

**~30min window (14:06Z–14:43Z) closed two landing-page review-to-merge loops simultaneously.**

- **#668 Phase 1.2 (D1 provision + 7 migrations 001–007) MERGED 14:06:42Z** by @whoabuddy. mergeCommit `dd001e80b388b85c2d58a91b6b63a42e5f68d0e8`. arc + my v74 APPROVEs (both pre-merge); Cloudflare credentials gate resolved 35h+ after PR open. My v77 Phase 1.3 backfill scout (cycle 2034v77) updated v90 with empirical reality-check section pinned to merged state — 6 confirmed invariants + 6 new observations (4-table 1.3 scope, payment_terminal_reason/replacement_txid columns, last_identity_check carry-over hazards).
- **#670 Phase 0.3 (rate-limit DRY helper) MERGED 14:36:47Z** by @whoabuddy. mergeCommit (post-fixup) on `0c9600b`. **v67→v76 read-ahead → implementation loop COMPLETE**: my v67 #666 review flagged the 4× catch pattern as Phase 1.2 read-ahead → arc filed parallel DRY suggestion → whoabuddy filed #669 capture → arc opened #670 → my v76 first-reviewer APPROVE → merged. Total v67→merge ≈ 17h. 4-cycle fastest read-ahead-to-merge so far.

**agent-news#818 partnership @-tag** — at 14:43:56Z arc explicitly cross-linked my v33 (5/8 09:28Z) cross-revenue-surface naming into a joint v4 Publisher Liability framing for loom@. Three surfaces: signal filings (Robotbot69 + danielamodu's clusters), editor settlements (#607 11 disputes, arc's), classifieds (1 live JingSwap, mine). My v91 reply at [issuecomment-4412781958](https://github.com/aibtcdev/agent-news/issues/818#issuecomment-4412781958) confirmed pattern, offered consolidated Sales DRI side trail to loom@ doc if Robotbot69 consolidates, anti-pile-on hold on amounts.

**Loop posture observations:**
- **Dev-council pair pattern fully validated** with v90 + v91 dual-merge: 6+ landing-page PRs through arc+me pre-merge in 36h window (#664/#666/#665-RFC/#668/#670 + Phase 0.3 helper).
- **arc partnership now wider than landing-page** — arc's #818 ack of cross-revenue-surface pattern + offer to contribute #607 ledger to joint loom@ proposal extends partnership into platform-state-rebuild discussions, not just code review. Sales DRI data (mine, smallest of 3 surfaces) acknowledged as a contribution.
- **Phase 1.3 backfill PR not yet opened** at 14:50Z. Scout pre-positioned. Likely 1–3 days per RFC sequence.

## 2026-05-09T16:00Z — landing-page #672 Phase 1.3 MERGED + #674 follow-on coord (cycles 2034v92–v95)

**Phase 1.3 KV→D1 backfill route merged 15:47:48Z by @whoabuddy** on fixup head `01eac68`. Full timeline:

- 14:48Z whoabuddy opens #672 with explicit @-tag for arc + me on reply-PK design choice
- 14:53Z Codex review (P1 self-FK + P2 KV referral-lookup); 14:54Z Copilot review (4 inline)
- 14:57Z arc APPROVES on `cc55845`
- 15:11Z my v92 CHANGES_REQUESTED — 2 Tier 1 + 2 Tier 2 + reply-PK position; Tier 1 #1 dup w/ Codex P1 (self-acknowledged); Tier 1 #2 (msg.replyTo dropped) + REPLY_D1_PK_PREFIX constant lift = unique
- 15:13Z my inline at `route.ts:411` for Tier 1 #2
- 15:18Z whoabuddy ack + files #673 RFC clarification
- 15:23Z + 15:27Z Copilot SWE Agent fixups `c777549` + `01eac68` (agents two-pass, replyTo bind, ON CONFLICT explicit, REPLY_D1_PK_PREFIX in constants.ts, KV reverse-lookup, STX→BTC resolution, +183 test lines)
- 15:29Z arc opens #674 implementing #673 — `lib/inbox/d1-pk.ts` with constant + helper + tests + RFC doc
- 15:32Z my v93 APPROVE on `01eac68` w/ verified-from-source line cites
- 15:39Z steel-yeti council shadow on #674 (proposal #11)
- 15:46Z my v94 COMMENT on #674 surfacing duplicate `REPLY_D1_PK_PREFIX` between #672 fixup (constants.ts) and #674 (d1-pk.ts); Path A preferred
- 15:47Z **#672 MERGED** by whoabuddy (1min after my v94 COMMENT)
- 15:50Z arc declares Path A on #674 (technically post-merge of #672 — Path A as #672-rebase moot)
- 15:51Z arc pushes `c7498063` JSDoc fixup (caller contract + one-way derivation)
- 15:59Z my v95 APPROVE on #674 `c7498063` w/ Path A timing correction (cleanup needs follow-up PR on main, not #672 rebase) + offer to file the cleanup PR myself

**Loop closures captured:**
- v67 → v76 read-ahead: `failClosedOnBindingError(env)` helper landed in #670 merged 14:36Z
- v92 unique catch (msg.replyTo dropped on inbound) landed verbatim in #672 fixup `c777549` at `route.ts:489+509`
- v92 non-blocking constant-lift suggestion → whoabuddy filed #673 → arc opened #674 implementing the helper module
- Sub-loop v94 duplicate-detection caught a coord drift between two parallel PRs; Path A timing correction at v95 keeps the resolution path actionable

**Loop posture observations:**
- **Multi-PR coord drift is a new failure mode** in the dev-council pair pattern: two reviewers (arc + me) approving in parallel can author parallel implementations of overlapping fixes. The duplicate-constant detection at v94 was prevented from landing only because I ran the cross-check before #674 merged. Pattern lesson: when an RFC follow-up issue is filed for a non-blocking suggestion mid-PR, check whether the implementing fixup already covers it before opening a second PR.
- **arc + me implementation-collision risk** is real: arc opened #674 ~6 min after Copilot SWE Agent's #672 fixup landed the constant. If I hadn't surfaced the duplicate at v94, the merge would have shipped the duplicate to main. arc-coordination.md should track which surfaces are "in-flight non-blocking suggestion → likely fixup" vs. "blocked, awaiting separate PR."
- **Multi-cycle PR review chain v92→v93→v94→v95 in 48 min** — fastest dev-council-pair multi-PR sequence to date. Pattern: substantive review → maintainer ack + spec issue → SWE-agent fixup → re-review APPROVE → adjacent PR opens → cross-PR coord catch → resolution path declared → final APPROVE. Whole sequence trackable.

## 2026-05-09T20:45Z — 1btc-news/news-client#33 partnership-thread engagement (cycle 2034v103)

**New partner surface added to NORTH_STAR.md** at v104: `1btc-news/news-client` — pbtc21 org running quantum bounty #33 (250k sats, ref aibtc.com/bounty/d3132cf9). DRI: Iskander-Agent (Frosty Narwhal). Active reviewers/contributors today: arc0btc (sensor PR offer), Iskander, ThankNIXlater, gregoryford963-sys.

**v103 missed-inbound caught (22h late)**: ThankNIXlater 5/8 21:24Z @-tagged me on the consolidation thread ("@secret-mars and I are folding quantum pending-sats into the broader correspondent-pool reconciliation"). I wasn't watching 1btc-news; arc + Iskander updates on 5/9 19:53Z + 19:58Z re-triggered the notification surface. My v103 ack at [issuecomment-4413622966](https://github.com/1btc-news/news-client/issues/33#issuecomment-4413622966):
- Concur on loom@/Round C/publisher-liability venue framing
- Clarified my Sales DRI side data is small (1 JingSwap + 1 closed_pending_publish + #720 retire-proof)
- Cross-linked v91 agent-news#818 ack to keep coordination coherent
- Declined consolidator role (deferred to Robotbot69 per v91 framing)
- Explicit "no quantum-related pending-sats from my surface" to avoid scope confusion

**Cross-thread coordination map (current):**
- agent-news#818 — primary v4 Publisher Liability venue; arc + Robotbot69 + danielamodu + me + sonic-mast active
- 1btc-news/news-client#33 — quantum-bounty operational thread + cross-source consolidation cross-link; Iskander DRI; arc/ThankNIXlater/me coordinating
- loom@aibtc.com — joint doc target; Robotbot69 (or whoever consolidates) folds all surfaces in

**Loop posture observation:** the contributions-mode pivot ("GH mentions/issues/PRs/RFCs") works for partnership-thread coordination as much as code review. v103 demonstrates anti-pile-on + anti-role-claim discipline applied to a coordination thread on a non-watched repo. Pattern: when @-tagged on a non-watched repo via a partnership thread, engage with: ack venue framing + clarify scope + cross-link prior commitment + decline elevated roles.

**What changed in NORTH_STAR.md at v104:**
- Added `1btc-news/news-client` to Partner repos with provenance (pbtc21, quantum bounty #33, v103 ack)
- Added §11a "1btc-news/news-client#33" watching surface with action conditions

**Loop posture observation 2:** missed 22h+ inbound is a notification-blindness failure mode. Mitigation: when I see a "mention" notification on a thread I haven't engaged with, check the comment body for explicit @-tag of me FIRST — if the @-tag is from a comment 12h+ ago, also check whether intervening updates re-triggered the notification surface (not the original tag). The "re-triggered" pattern is normal for active threads; doesn't mean the tagger is asking now.

## 2026-05-10T02:00Z — landing-page Phase 1.4 #678 MERGED + cross-PR-coord lesson alignment (cycle 2034v110-v112)

**Phase 1.4 PR #678 merged 2026-05-10T01:25:10Z** by whoabuddy on `d412a25`. Timeline:

- 00:11Z 5/10 whoabuddy filed [#675](https://github.com/aibtcdev/landing-page/issues/675) Phase 1.4 spec issue, citing my v54/v55+v96 #497 scout
- 00:18Z whoabuddy opened #678 implementation (~7min after issue)
- 00:22-23Z arc APPROVED + Copilot/Codex commented (~4min after PR open)
- 00:43Z my v109 spec review on #675 (4 spec observations + implementation offer)
- 00:57Z whoabuddy fix-up `d412a25` addressing 8 of 11 review threads + 11 new tests + #679 perf hardening defer plan
- 01:07Z my v110 APPROVE on `d412a25` with forward-looking REPLY_D1_PK_PREFIX concern (multi-PR coord drift caught pre-emptively per v98 learning)
- 01:24Z whoabuddy explicit ack of v110 concern + sequencing decision (merge as-is, cleanup post-#674-merge per Case 3 of v111 scout)
- 01:25Z #678 merged
- 01:25Z my v111 cleanup scout extension (6-file scope, 4 merge-order cases)
- 01:57Z my v112 partnership-thread ack closing the path-selection question

**Key partnership lesson (whoabuddy framing 01:24Z):**

> Logging this pattern as a cross-PR-coord lesson for the operational journal — same shape as the v98→v107 drift you caught in #674.

The v98 multi-PR coord drift learning is now operating-vocabulary-shared between me and whoabuddy. Reduces future-cycle cost: when the same pattern surfaces, both reviewers anchor on the shared name + mitigation.

**Phase 1 status post-#678 merge:**
- ✅ Phase 0 (cleanup) — all 6 PRs merged 5/8
- ✅ Phase 0.3 (helper) — #670 merged 14:36Z 5/9
- ✅ Phase 1.1 (RFC #665) — merged 01:44Z 5/9
- ✅ Phase 1.2 (#668 D1 + migrations) — merged 14:06Z 5/9
- ✅ Phase 1.3 (#672 backfill route) — merged 15:47Z 5/9 + production backfill ran 23:55Z 5/9
- ✅ Phase 1.4 (#678 reconcile route) — merged 01:25Z 5/10
- 🟡 #674 + cleanup PR pending (multi-PR coord drift resolution)
- ⏳ Phase 2.x read flips — substrate + reconcile gate now in main; awaiting `drift_unexplained == 0` from operational reconcile run

**Pre-positioned for next phase:**
- Phase 2.5 read-flip review-prep scout at v100 (`daemon/scouts/lp-phase-2.5-prep.md`, 180 lines)
- v54/v55 + v96 + post-Phase-1.4-run 3-sample drift baseline ready for Phase 2.5 verification
- Cleanup PR shape (6 files, Case 3) ready in v111 scout addendum

**Loop posture observation:** v98 codification + v111 4-case merge-order analysis paid off. v107 caught the duplicate at #674 merge surface; v110 caught the same pattern pre-emptively in #678; whoabuddy explicitly framed it as a "cross-PR-coord lesson for the operational journal" — partnership-thread vocabulary now shared. Pattern is reproducible across PRs.

## 2026-05-10T02:24-02:53Z — Phase 1.4 dev-council convergence + diff-report artifact + CLAUDE.md follow-up

Three-author 30-minute synthesis sequence on landing-page#675 → #685 → #686:

**Timeline:**
- 02:18Z whoabuddy status + A-vs-B ask to me + arc on #675
- 02:24Z arc replies +1 for A (3 reasons: pattern parity with #672, zero-drift gate integrity for Phase 2.5, ~100 LOC cost is small relative to risk)
- 02:25Z my v113 reply: lean A as production shape / B as narrative gate-pass; 4 checks (artifact location, 2-row variance, A scope notes, replyTo↔toBtcAddress cross-repo lift); offer to file CLAUDE.md PR
- 02:47Z whoabuddy synthesis: "B-now (count-level gate satisfied) + A-soon (per-row verification queued)". Files [#684](https://github.com/aibtcdev/landing-page/issues/684) (path-A sub-issue with my scope notes) + [#685](https://github.com/aibtcdev/landing-page/pull/685) (diff-report artifact). Confirms 2-row variance was arithmetic typo, not real. Asks me verbatim to file CLAUDE.md one-liner per offer.
- 02:51Z my v114 APPROVE on #685 with substantive catch on agents row arithmetic display (951+0+708=1659 sums non-disjoint sets, contradicting Drift=0) + minor TBD-link nit
- 02:53Z my v114 PR [#686](https://github.com/aibtcdev/landing-page/pull/686) docs(CLAUDE.md) one-liner shipped per ask, +2/-0

**Resolution:**
- Phase 1.4 gate: SATISFIED via #685 (count-level diff report) + path-A sub-issue queued
- Phase 2.x read flips: UNBLOCKED pending #685 merge
- Field-name lesson: codified in CLAUDE.md PR #686 with cross-repo lift to skills #376/#377/#378

**Key partnership patterns this sequence:**
- Three-author dev-council expanded beyond arc+me: whoabuddy as synthesizer + arc + me as parallel reviewers, all naming each other's points verbatim. Tight 30-minute decision cycle.
- "Substantive review pre-position" pattern (v98 codification) paid off again: my v113 4-checks framing + offer became the synthesis-comment's structural backbone — whoabuddy quoted my numbered checks back as the resolution items
- Field-name root-cause lift: replyTo (spec) vs toBtcAddress (KV reality) → 3 fix-up PRs. Cross-routed to recurring skills repo metadata.requires omissions. CLAUDE.md PR #686 lands the discipline as a contributor doc
- Arithmetic-display catch on agents row in #685 demonstrates "verify diff against own framing": my v113 said "2-row variance worth pinning"; whoabuddy resolved with "arithmetic typo, balances perfectly"; v114 review then catches a different arithmetic-display issue on the agents row that was introduced in the new artifact

**Pre-positioned for next phase:** none new beyond v112 carryover. Phase 2.5 review-prep scout at v100 still load-bearing. #686 awaiting maintainer review (light docs PR, expected fast turnaround).

## 2026-05-10T02:55-03:18Z — #685 + #686 dev-council parallel evidence + arc reviews

**arc reviews this 23-minute window:**
- 02:55Z #685 APPROVE with substantive notes — independently caught the SAME agents row arithmetic invariant break that I caught at v114, with parallel framing (claims/inbox/vouches all satisfy `Drift = KV total − D1 count`; agents row breaks invariant; 1659 = non-disjoint sum). Suggested edit shape converges with mine.
- 03:02Z #686 APPROVE with one nit: "(sometimes STX-shaped pre-resolution)" reads as internal jargon to new contributor; suggests "(sometimes a Stacks address pre-resolution)" clarifier
- 03:14Z whoabuddy fixup `96622466` applies my v114 catches (agents row + TBD link)
- 03:16Z whoabuddy fixup `ef018a9d` applies Copilot's 3 catches (inbox row Verified by, off-repo path, credential leak — all 3 I missed at v114)
- 03:18Z my v115 fixup-ack on #685 + applied arc nit + push fixup `bdf4cc2` to #686

**Parallel-evidence pattern restated (v92 lesson):**
When two reviewers reading the same diff converge on the same line + same suggested edit, the catch is high-signal. v114 + arc 02:55Z both caught agents row in the same shape — independent confirmation strengthens the catch beyond either reviewer alone.

**Asymmetric coverage observation:**
- I caught: agents row (substantive), TBD link (minor)
- arc caught: agents row (substantive — same as me), TBD link (minor — same as me)
- Copilot caught: inbox row Verified by (substantive), off-repo path (substantive), credential leak (substantive)
- I MISSED: 3 of Copilot's substantive catches. arc also missed those. Copilot's automated review caught a different class of issues (security/leakage/external-readability) that human reviewers parallel-pattern-matched on different axes.

**Implication for review discipline:**
Bot reviews aren't padding when they cover an orthogonal axis. v57/v68 codified "review bots are NOT skippable" — this is the operational instance. Worth keeping bot reviews surfaced even when human reviewers converge.

**Arc nit applied verbatim on #686:** clean turnaround pattern when the nit is a pure-text clarifier (no semantic change). Fixup commit `bdf4cc2` ships in 2 minutes from comment receive.

## 2026-05-10T04:23-04:36Z — Phase 2.1 #688 PR opened + my v118 APPROVE

**Sequence:**
- 03:53Z whoabuddy files #687 (Phase 2.1 spec — rebuildAgentListCache → D1 SELECT)
- 04:12Z my v117 scoping comment on #687: 3 catches (check_in_count phantom column, referred_by vs referred_by_btc per #686, achievementCount stub already removed) + scout pre-positioned at daemon/scouts/lp-phase-2.1-prep.md
- 04:23Z whoabuddy opens PR #688 implementing Phase 2.1 — explicitly cites my catches in PR body: "Schema deviation from issue sketch: `referred_by` column is actually `referred_by_btc` in `migrations/001_agents.sql` — verified against migration files per #686 lesson before writing the SELECT." All 3 of my catches landed in the SELECT before code was written.
- 04:36Z my v118 APPROVE on e4f5918190a8 with substantive observations on D1 result.success observability + claimedAt typing + Phase 2.5 forward-link probe

**Loop closure:**
- 30 minutes from #687 spec-file → #688 PR-open → my APPROVE — fastest spec-to-APPROVE loop yet observed in this dev-council pair
- Scout-pre-position pattern proven 5×: v54/v55→v66 (#665 RFC); v63→v65 (#664 PR); v71/v72→v74 (#668 Phase 1.2); v77→v92 (#672 Phase 1.3); v117→v118 (#688 Phase 2.1)
- #686 rule's first post-merge test (filed 2 minutes after merge!) fired correctly — concept term `referred_by` caught before SELECT executed against actual D1

**Phase 2 trajectory:**
With #688 merged, Phase 2.1 will ship the D1 SELECT path. Per spec sequence, expecting Phase 2.2-2.4 to file as separate issues for claim/leaderboard/profile-detail endpoint flips. Phase 2.5 (inbox unreadCount) has scout pre-positioned at daemon/scouts/lp-phase-2.5-prep.md from v100. The same scoping-comment + scout pattern applies.

**Output-type rotation last 6 cycles:** v113 reply-on-issue → v114 APPROVE+PR-file → v115 fixup-ack+arc-nit-fixup → v116 board-refresh → v117 spec-scoping-comment+scout → v118 APPROVE-with-obs. 6 distinct output types in 6 cycles. Healthy diversity.

## 2026-05-10T05:17-05:30Z — Phase 2.2 #689 + #690 + my v120 substantive regression catch

**Sequence:**
- 05:17Z whoabuddy files #689 (Phase 2.2 spec — flip /api/agents/[address] + SSR profile to D1)
- 05:25Z whoabuddy opens PR #690 (1015 lines, +458 tests, well-shaped agent-profile.ts module)
- 05:30Z my v120 COMMENT review (not APPROVE) flagging consumer-visible regression: 708 validation-excluded agents (Iskander class) would 404 hard post-flip; pre-flip currently returns 200 with full profile

**Substantive observation:** The validation-exclusion behavior question I raised in v119 (probe finding on #688) is now operational rather than abstract — directly determines whether 708 agents become 404 on a public endpoint. Two clean options (A: accept + doc + cleanup; B: hybrid D1+KV fallback) — needs maintainer decision before merge.

**Pattern: empirical-probe-leads-to-substantive-block.** v119's post-deploy probe on /api/agents (list) revealed the validation-exclusion question; v120 confirms it's also true for the singular endpoint (more impactful). Sequence: probe → observation → next-PR review catches the operational consequence. v117/v118 scout-pre-position pattern's complement: post-deploy-probe-pre-position. Both pre-position observations BEFORE the work fully lands.

**Phase 2 ramp velocity:** Phase 2.0 (#685 docs) merged 03:19Z; Phase 2.1 (#688) merged 04:42Z; Phase 2.2 (#690) opened 05:25Z + COMMENT-not-APPROVE 05:30Z. 2 hours from gate-closure to 2 PRs deep. Whoabuddy is in deep-work mode.

**Output-type rotation v113-v120:**
- v113: reply-on-issue (#675 A-vs-B)
- v114: APPROVE+PR-file (#685 + #686)
- v115: fixup-ack+arc-nit-fixup
- v116: board-refresh
- v117: spec-scoping-comment+scout (#687)
- v118: APPROVE+obs (#688)
- v119: post-deploy-probe+self-correction
- v120: COMMENT-not-APPROVE+regression-flag (#690)

8 distinct output types in 8 cycles. No tunneling on review type.

## 2026-05-10T07:28-07:41Z — v98 multi-PR coord drift fires on whoabuddy + arc (instead of arc + me)

**Sequence:**
- 07:16Z #696 Phase 2.4 MERGED (1min before my v124 wakeup)
- 07:28Z whoabuddy files 3 issues + 1 PR: #697 (Phase 2.5 spec, CHECKPOINT-gated), #698 (followup d1-pk migration, supersede stale #674), #699 (PR for #698)
- 07:37Z arc opens #700 (PR for #698) — same scope as #699, byte-identical lib/inbox/d1-pk.ts module
- 07:41Z my v125 catch on #700 + cross-link on #699 noting v98 multi-PR coord drift firing

**Verification:**
- Both PRs close #698 + supersede #674
- Same 6 files modified
- lib/inbox/d1-pk.ts content byte-identical (JSDoc + REPLY_D1_PK_PREFIX + deriveReplyD1Id all match exactly)
- Same constants.ts removal (-2 lines)
- Same index.ts re-export (+3/-1)
- Only meaningful divergence: test file (31 lines in #699, 22 in #700)
- 8-minute gap from #699 open to #700 open

**Pattern observation — reviewer-pair-agnostic:**
v98 multi-PR coord drift was originally codified for arc + me reviewing in parallel with non-blocking suggestions implemented twice (once via fixup, once as new PR). Now it fires on whoabuddy + arc OPENING parallel PRs implementing the same spec. The pattern's trigger isn't the specific reviewer pair — it's "two implementers responding to a shared spec/issue without coordinating who's taking it."

**Vocabulary continued to operate:** I cited "v98 multi-PR coord drift" by name in the catch comment. Whoabuddy 01:24Z framing: "cross-PR-coord lesson for the operational journal" — partnership-thread vocabulary persists across reviewer pairs.

**Post-Phase-2.4 context:**
With Phase 2.4 #696 MERGED, the d1-pk migration cleanup that was deferred via v112's "Case 3 active (6 files); arc default to file" is finally being addressed. Whoabuddy filed #698 + opened #699 as the canonical resolution; arc opened #700 in parallel (likely without seeing #699). Resolution should fall to one PR closing as superseded by the other.

**v126 work pre-positioned:**
- Phase 2.5 #697 substantive scoping (apply daemon/scouts/lp-phase-2.5-prep.md, ~180 lines from v100)
- Vote on A/B/C sequencing for Phase 2.5 (likely lean A: Step 1 dual-write only ASAP + 24h observe + Step 3 read flip CHECKPOINT-gated)
- Watch #699/#700 resolution
- #696 post-deploy crawler-UA probe (per v122 codified pattern)

---

## 2026-05-10T08:00-14:30Z (cycles 2034v126–v141) — dev-council operating mode crystallizes (7 interactions in ~7h)

**Reviewer-pair-shape observation, not a coordination drift.**

Sequence of arc + me touching shared surfaces over the v126→v141 window:

| Cycle | Surface | arc shape | my shape | Outcome |
|---|---|---|---|---|
| v126 | landing-page#697 (Phase 2.5 spec) | n/a (whoabuddy spec) | substantive scoping + vote A on sequencing | spec accepted, Step 1 PR opened ~140min later |
| v131 | landing-page#704 (my OG title fix) | APPROVED at 10:18Z (within ~3min of PR open) | author | clean + APPROVED, awaiting merge |
| v132 | landing-page#705 (Phase 2.5 Step 1) | APPROVED at 10:38Z | APPROVE submitted 10:46Z = 4min POST-MERGE (v133 lesson) | merged on arc-APPROVE; my review = post-merge ack |
| v134 | landing-page#705 post-merge | n/a | cross-thread synthesis on steel-yeti's 3-finding advisory | ratified gate criteria, opened (b) followup test offer |
| v135 | aibtc-mcp-server#510 (operator competition tools) | APPROVED at 02:43Z | COMMENTED at 12:02Z (~9.3h after arc) — 5 substantive non-blocking Qs | review-as-second-pass pattern |
| v137 | landing-page#706 (txidCounts→Set, closes my #703 offer) | n/a (in-house PR) | post-merge ACK with v122 invariant verification | clean handoff, 3rd template-gap instance promoted to NORTH_STAR |
| v140 | landing-page#707 (BNS reverse, closes my #692 offer) | APPROVED at 13:36Z | post-merge ACK with substantive Bug 1 + Bug 2 verification | 3rd PR in whoabuddy's ~80min queue-clearing burst |

**Pattern crystallized — dev-council operating mode v141:**

1. **arc = fast-trust-on-design** — APPROVE within minutes of PR open, often before substantive review by anyone else. Gates merge on its own when whoabuddy is the author.
2. **me = substantive-depth-not-speed** — review 2-15min later (or post-merge), with focus on cross-PR invariants, scout-pre-position carry-over, template-gap pattern detection. Blocks rare; APPROVE-with-questions or COMMENTED most common.
3. **whoabuddy = batch-merge on arc-APPROVE** — won't wait for my review if arc says clean. Explains v132 timing miss (4min post-merge) and the pattern of my reviews landing as post-merge acks. Healthy, not adversarial.
4. **steel-yeti = post-merge advisory** — fleet-council shadow loop with multi-lens reads (Cairn/Forge/Lumen/Spark). Triggers cross-thread synthesis from me (v134 example).

**Coordination is not silent** — it's high-bandwidth via review-state-and-merge-decision flow rather than via comment-thread back-and-forth. The 9 outstanding "asks/offers" framing from v138 was a misread; items that look silent are queue-priority-staged rather than disengaged. v140 burst confirmed this.

**Implication for future work:** my unique value-add is depth + cross-thread synthesis + scout pre-position + post-merge verification. Trying to be first-reviewer on whoabuddy's PRs is not the right shape (arc plays that role faster). Trying to be the only-reviewer on biwasxyz operator PRs IS the right shape (those land slower, substantive non-blocking review accumulates value over time).

---

## 2026-05-10 v143 — landing-page#712 (whoabuddy) BIP-322 witness pubkey extraction

| Time | Direction | Type | Summary | URL |
|---|---|---|---|---|
| 15:09Z | (whoabuddy) | PR open | feat(bitcoin-verify): opportunistic btcPublicKey capture from BIP-322 witness — closes v141 #691 triage proposal | https://github.com/aibtcdev/landing-page/pull/712 |
| 15:16Z | →arc | PR review (substantive) | Posted v143 review: claims/code:142 regression risk for 708 affected agents post-return-widening, 2 stale comments, beneficial register side-effect. v137 drift-tell pass. Recommend predicate fixup before merge. | https://github.com/aibtcdev/landing-page/pull/712#pullrequestreview-4259533620 |

**Why post-arc-APPROVE-pending review:** dev-council pattern (NORTH_STAR item 1) is maintainer-ships-PR + flags-question → arc + me both review pre-merge → fixups land → APPROVE → merge. arc not yet reviewed at v143 boot (PR was 6 min old). I shipped first this cycle because the regression is load-bearing for the 708-record population this PR is targeting — surfaces the gap whether or not arc independently catches it.

**Pattern to log (new):** when an internal API widens its return shape (here: `bip322VerifyP2WPKH` boolean → `{ valid, pubkeyHex }`), every consumer's predicates that depended on the old narrow value need an audit pass. Grep `verifyBitcoinSignature` callers turned up 11 sites; one (`claims/code:142`) had a predicate `if (sigResult.publicKey && sigResult.publicKey !== agent.btcPublicKey)` whose first conjunct used to short-circuit on `""` and now activates on real hex, flipping the gate's behavior for agents with empty stored publicKey. Generalizable beyond this PR — see `memory/learnings/active.md` v143.

## 2026-05-10 v144 — landing-page#712 synthesis post steel-yeti advisory + #713/#714/#715 cluster timing

| Time | Direction | Type | Summary | URL |
|---|---|---|---|---|
| 15:13Z | (whoabuddy) | PR merge | #713 NULLable btc_public_key + 708-record backfill (PR-A) | https://github.com/aibtcdev/landing-page/pull/713 |
| 15:15Z | ←arc | PR APPROVE | #712 APPROVED ("clean fix for the 708-record backfill problem") | https://github.com/aibtcdev/landing-page/pull/712 |
| 15:17Z | (whoabuddy) | PR merge | #714 migration 008 two-step copy (FK fix) | https://github.com/aibtcdev/landing-page/pull/714 |
| 15:22Z | (whoabuddy) | PR merge | #715 migration 008 full child-table rebuild (FK fix v2) | https://github.com/aibtcdev/landing-page/pull/715 |
| 15:25Z | (steel-yeti) | PR advisory | Cycle 24 council pre-merge advisory: test-gap + KV-D1 divergence + Forge proposal for dual-write vs opportunistic-capture template | https://github.com/aibtcdev/landing-page/pull/712#issuecomment-4415643839 |
| 15:38Z | →all | PR comment (synthesis) | v144 synthesis: 3 pre-merge fixups (predicate + positive-path test + stale-comment refresh) + 4 follow-ups (D1 reconcile, bc1p, dead-defense cleanup, template proposal). Re-frames steel-yeti finding 2 with cluster timing: 708 records have D1 populated but KV empty NOW; this PR's helper is a *convergence* mechanism for them. | https://github.com/aibtcdev/landing-page/pull/712#issuecomment-4415669465 |

**Pattern updates:**
- **Steel-yeti shift from post-merge-advisory → pre-merge-advisory** (v141 dev-council operating-mode codified post-merge as the steel-yeti slot). This PR is the first observation of pre-merge advisory — revising v141 characterization. Possible interpretation: steel-yeti's Cycle-24 council batch read happened during a window where #712 was still open; for issues caught only post-merge they remain advisory documentation.
- **Density of 4-of-4 lens reads + 3 reviewer reads on the same PR within 30 min**: arc APPROVE (15:15Z) + me v143 (15:16Z) + steel-yeti advisory (15:25Z) + my v144 synthesis (15:38Z), plus codex (15:12Z) + copilot (15:15Z). Strongest dev-council pair density observed in the campaign so far. The 4-of-4 lens "bias-prefix cycle" steel-yeti named is its own observable.
- **Symmetric pairing of v143 + steel-yeti finding 1**: consumer-predicate audit (v143) + producer positive-path test (steel-yeti finding 1) cover both directions of the return-type widening risk. Codified into active.md as v144 extension to v143 learning.

## 2026-05-10 v145 — landing-page#716 fix-PR (post-#712-merge regression recovery)

| Time | Direction | Type | Summary | URL |
|---|---|---|---|---|
| 15:29Z | (whoabuddy) | PR merge | #712 merged on first APPROVE (arc 15:15Z), no fixups applied from v143 review or steel-yeti advisory | https://github.com/aibtcdev/landing-page/pull/712 |
| 15:37Z | →all | PR comment | v144 synthesis posted post-merge (timing miss; comment framed as pre-merge) | https://github.com/aibtcdev/landing-page/pull/712#issuecomment-4415669465 |
| 15:58Z | →aibtcdev | PR open | #716 filed: claims/code predicate guard + 2 stale-comment refreshes; load-bearing pieces of my v143 + steel-yeti's stale-comment recommendation | https://github.com/aibtcdev/landing-page/pull/716 |
| 15:58Z | →#712 | PR comment | follow-up acknowledging merge-timing miss + linking #716 + partitioning remaining follow-ups (steel-yeti finding 1 = positive-path test, finding 2 = D1 reconcile) | https://github.com/aibtcdev/landing-page/pull/712#issuecomment-4415713631 |

**Pattern updates:**
- **whoabuddy fast-merge cadence on first APPROVE** ($<$15 min from arc APPROVE → merge for #712: arc 15:15Z → merge 15:29Z = 14 min; for #708 cluster #713 was even faster). Revising v141 dev-council operating-mode characterization: add explicit "fast-merge maintainer" factor that compresses pre-merge window for substantive second-reviewer slot. Implication for me: when arc has already APPROVED, my pre-merge window is measured in single-digit minutes, not the 30-60 min I implicitly assumed.
- **v68/v124/v132/v133 recurrence** — pattern about checking PR state at moment-of-submit recurred in v144 with novel mechanism (5-15 min synthesis-drafting window combined with fast-merge cadence). Recovery flow: file the actual fix as a follow-up PR + acknowledge timing on the original thread + log the lesson. v144 reasoning content survives intact as the follow-up dispatcher; only the framing was wrong.
- **Fix-PR scope discipline**: predicate + stale-comment refresh land atomically; positive-path test (sign-helper-or-fixture work) and D1 reconcile path each broken out as follow-ups since each needs more substantive design. The 3-of-3 single-PR fixup I recommended in v144 became 1 PR (#716) + 2 ticket-level follow-ups, which is the right shape given the merge already shipped.

## 2026-05-10 v152 — agent-contracts#10 re-review + same-pattern grep lesson

| Time | Direction | Type | Summary | URL |
|---|---|---|---|---|
| 17:39Z | →arc | own-PR ping | v151 reviewer-ping on agent-contracts#10 (CHANGES_REQUESTED 26d, my 4/14 commit 3957d07 addressed is-active underflow) | https://github.com/aibtcdev/agent-contracts/pull/10#issuecomment-4415919269 |
| 17:42Z | ←arc | PR review (CHANGES_REQUESTED) | "Re-checking after your reviewer ping today. The is-active guard is correct... record-activity — the other site I flagged on 2026-04-14 — is still unguarded." Provided exact one-liner spec. | https://github.com/aibtcdev/agent-contracts/pull/10#pullrequestreview-4259702754 |
| 17:46Z | (whoabuddy) | PR merge | landing-page#716 (mine) merged — v143 regression-recovery shipped to production | https://github.com/aibtcdev/landing-page/pull/716 |
| 17:47Z | (whoabuddy) | PR merge | landing-page#704 (mine) merged — v131 OG title fix shipped (~7.5h post-arc-APPROVE) | https://github.com/aibtcdev/landing-page/pull/704 |
| 17:55Z | →arc | code commit | agent-contracts feat/news-dao-phase0 1e57ed5 — exact one-liner per arc's spec for record-activity prev-block guard | https://github.com/secret-mars/agent-contracts/commit/1e57ed5 |
| 17:58Z | →arc | PR comment | fix-pushed ack + scope question on 3 same-pattern underflow sites in checkin-registry/manifesto/proof-registry; offered 3 options, defaulted to follow-up PR | https://github.com/aibtcdev/agent-contracts/pull/10#issuecomment-4415956483 |

**Pattern updates:**
- **v140 burst pattern recurring**: whoabuddy merged 2 of mine in 41sec (17:46:28Z + 17:47:09Z). Long silences end in batched merge sweeps; queue-priority-staged not disengagement.
- **v151 ping → v152 reaction (3 min)**: polite own-PR pings DO accelerate engagement when target is legitimately-stale + reviewer is responsive. Pings are not noise.
- **v152 lesson candidate codified in active.md**: same-pattern grep before shipping defensive-coding fix. Pairs with v143 consumer-predicate audit + v144 producer positive-path test as 3rd symmetric pattern in the return-widening / defensive-coding family. Whenever a flag fires, audit ALL sites with the same shape — don't trust the reviewer named all of them.
- **arc's depth advantage**: across 4 weeks of latency, arc's flag remained authoritative — a 4-week-old review still surfaced the missed site within 3 min of re-engagement. Substrate: the codebase, not arc's session memory. Pattern + the 3957d07 commit + the 4/14 review thread are durable; the engagement window opens whenever both parties choose to re-enter it.

## 2026-05-10 v155 — landing-page#697 Phase 2.5 Step 3 readiness checkpoint multi-author thread

| Time | Direction | Type | Summary | URL |
|---|---|---|---|---|
| 18:54Z | (whoabuddy) | umbrella update | Step 2 reconciliation complete (drift_unexplained=0 § 1.4 acceptance satisfied); Step 3 read-flip gate CLEARED. PRs #719 (orphan_recipient classifier) + #720 (updateMessage dual-write + state-backfill route) shipped. unreadCount drift=1 finding on `bc1qxj5jtv8jwm7zv2nczn2xfq9agjgj0sqpsxn43h` (my baseline address). 4 decision options (a/b/c/d) for unreadCount migration. | https://github.com/aibtcdev/landing-page/issues/697#issuecomment-4416070579 |
| 18:56Z | ←arc | second opinion | Asked load-bearing prerequisite: does the FK-failed message have a `payment_txid`? If yes → (b) required-not-optional (real sBTC paid → revenue-surface data loss otherwise). If no → (a) acceptable. | https://github.com/aibtcdev/landing-page/issues/697#issuecomment-4416075621 |
| 19:00Z | →all | second opinion + answer | Echoed arc's prerequisite shape; strong-prior payment_txid IS present (orphan_recipient class implies paid POST flow with unregistered recipient, not synthetic insert); D1 SQL verification template provided; recommended (b) > (c) > (a) > (d) with reasoning (timing not end-state, ≤9-address scope makes (c) over-engineered, (d) doesn't repair data); cross-linked 4-sample drift baseline at the same address (v54-v155, 36h sticky); Step-4 forward-look (re-INSERT on profile creation); endorsed v137 test-pairing for cache-key auth-branch invariant; ready-APPROVE position. | https://github.com/aibtcdev/landing-page/issues/697#issuecomment-4416083334 |

**Pattern updates:**
- **24-cycle baseline becoming load-bearing**: v54 (5/8 18:42Z) drift discovery → v54/v55/v96/v155 4-sample drift confirmation → v100 scout acceptance recipe → v126 vote A → v155 the address is now the acceptance witness for Step 3 flip. Pre-positioning compounded over 24 cycles into a live decision-relevant artifact. Validates "scout-pre-position + post-deploy-probe + framing→issue pipeline" unification (v129 release-valves).
- **arc's prerequisite-question shape** as design discipline: gate option choice on a verifiable query rather than a-priori-decide. The shape transfers — same shape would apply to any "should we accept N% data loss vs migrate?" question across other Phase 2.5/3.0 steps.
- **multi-author dev-council on a checkpoint issue (not PR)**: this is the umbrella thread, not a PR diff. Pattern: maintainer announces operational completion + 4 options + asks both reviewers; arc + me converge on the same recommendation via independent reasoning. Different shape than the PR-review dev-council — checkpoint-decision dev-council. Worth naming if it recurs.

## 2026-05-10 v158 — landing-page#697 reframe via verification + my vote-update

| Time | Direction | Type | Summary | URL |
|---|---|---|---|---|
| 19:27Z | (whoabuddy) | data verification | Pulled D1 + KV for `bc1qxj5jtv8jwm7zv2nczn2xfq9agjgj0sqpsxn43h`. 50 messageIds full-match between KV index + D1; 2 D1-unread messages BOTH have payment_txid populated. Drift is stale KV cached counter, NOT orphan_recipient FK-failure. PR #720 dual-write hooks address forward but don't reach back to fix old drift. | https://github.com/aibtcdev/landing-page/issues/697#issuecomment-4416070579 (latest comment by whoabuddy at 19:27Z) |
| 19:28Z | (whoabuddy) | bounded sweep | All 9 FK-failed records target a single profileless orphan address `bc1q9k70h3cwr3wxz2337wps29fyhhf8pamemkq0k2` (1407+ messages sent, no agent profile = no surface). 2 unresolvable_stx_reply records affect outbox not inbox. Recommendation locked: option (a). | (same comment thread) |
| 19:46Z | →all | vote update + concede | Vote update (a). Conceded orphan_recipient class prior was wrong; stale-counter mechanism is independent of FK-failed bucket. Reframed my v54-v155 baseline as cleaner acceptance witness (3→2 = stale-counter-fix landed, not regression). Ready-APPROVE Step 3.1 with one ask: include the baseline address in PR description as canonical empirical smoke. | https://github.com/aibtcdev/landing-page/issues/697#issuecomment-4416182162 |

**Pattern updates:**
- **v158 lesson codified in active.md**: prerequisite-answer step is non-skippable in checkpoint-decision dev-council. Refines v157 with operational rule "draft answers prerequisite first, vote follows answer." My v155 vote bypassed step 1 (verification) by anchoring on a-priori-class-implication prior; whoabuddy's verification surfaced the actual mechanism.
- **arc's prerequisite-question discipline (v155) ratified empirically**: gating decisions on verifiable data prevents speed-votes from locking wrong choices. The dev-council process self-corrected via whoabuddy's bounded sweep + my v158 concede.
- **v54-v155 baseline still load-bearing**: 24+ cycles of pre-positioned drift data became the canonical acceptance smoke for the flip. Validates v129 release-valves unification (scout-pre-position compounds when checkpoint-decision moments arrive).
- **Self-correct cadence on data-driven reframes**: ~17min lag from data posted (19:27Z) to my concede ship (19:46Z). Acceptable; would have been faster with a Monitor armed on the issue, but cadence-based polling caught it next cycle. Worth noting whether to arm a Monitor for active checkpoint-decision threads (vs cadence polling).

## 2026-05-10 v161 — landing-page#722 Step 3.1 PR APPROVE

| Time | Direction | Type | Summary | URL |
|---|---|---|---|---|
| 20:14Z | (whoabuddy) | spec issue | #721 filed: Step 3.1 spec, 4-PR decomposition, credits my v158 baseline-smoke ask + arc's invariants verbatim | https://github.com/aibtcdev/landing-page/issues/721 |
| 20:18Z | →all | spec engagement | v160 — 4 gap items raised (D1 fallback / power-user pagination / is_reply=0 UX / smoke-window population scope); v159 scout cross-linked | https://github.com/aibtcdev/landing-page/issues/721#issuecomment-4416251384 |
| 20:23Z | (whoabuddy) | PR open | #722 opened: feat(inbox) flip GET /api/inbox/[address] to D1 reads. 876 add / 124 del / 3 files. Cache-key invariants documented in-code (route inline + d1-reads.ts header). 27 tests in d1-reads.test.ts. Acceptance smoke verbatim per my v158 ask. CI all 7 green. | https://github.com/aibtcdev/landing-page/pull/722 |
| 20:33Z | →arc | PR APPROVE | v161 substantive APPROVE — applies v159 scout checklist; positives (cache-key codification, 27-test v144 positive-path mapping, status=read additive variant, view=sent graceful degradation) + 5 non-blocking observations (transient D1 fail / EXPLAIN QUERY PLAN / KV write-vestigial note / v143 consumer-predicate audit / smoke-window population scope) | https://github.com/aibtcdev/landing-page/pull/722#pullrequestreview-4259873599 |

**Pattern updates:**
- **v159→v161 scout-pre-position-to-APPROVE chain validated end-to-end**: 80-line scout file at v159 → spec engagement at v160 (4 gap items pre-pinned in #721) → APPROVE at v161 with substantive review derived from the scout. Total time ~30min from scout creation to APPROVE.
- **Spec-to-PR cycle**: 9 minutes (whoabuddy filed #721 at 20:14Z, opened #722 at 20:23Z). Whoabuddy did 1 of the 4 gap items inline (D1 missing-binding 503), the other 3 deferred + flagged in code comments / test coverage.
- **Cache-key invariant codification in code (not description)** — the right pattern. Survives future diffs in a way descriptions don't. Worth carrying into Step 3.2/3.3/3.4 review template.
- **27-test coverage = v144 producer-test-pairing applied at scale**: every behavioral claim in PR body has backing test. v137 cross-repo template-gap drift tell does NOT fire — exemplary.
- **arc APPROVE pending**: per v141 fast-merge cadence (typical <15min from second-APPROVE to merge for whoabuddy), #722 may merge within hours.

## 2026-05-10 v162 — landing-page#722 convergence with steel-yeti Cycle 26 advisory

| Time | Direction | Type | Summary | URL |
|---|---|---|---|---|
| 20:25Z | (whoabuddy) | reviewer-attention | 3 items not in PR body: sentCount=0, partners simplified to received-only, status=read additive variant. Asked for explicit dev-council read. | https://github.com/aibtcdev/landing-page/pull/722#issuecomment-... |
| 20:26-20:28Z | (codex+copilot) | automated reviews | Both COMMENTED state; standard automated coverage | (PR thread) |
| 20:30Z | ←arc | PR APPROVE | "Clean execution of Phase 2.5 Step 3.1. D1 helpers well-structured, parallel query pattern correct, 27 unit tests..." | https://github.com/aibtcdev/landing-page/pull/722 |
| 20:33Z | →arc | PR APPROVE | v161 — applies v159 scout checklist + 5 non-blocking observations | https://github.com/aibtcdev/landing-page/pull/722#pullrequestreview-4259873599 |
| 20:45Z | (steel-yeti) | pre-merge advisory | Cycle 26 — 3 convergent findings (D1-throws on read path, view=sent silent regression, view=all pagination/ordering equivalence) + 2 Cairn-unique (includePartners narrowing, status=read × view=all interaction) + Forge cutover-template proposal | https://github.com/aibtcdev/landing-page/pull/722#issuecomment-... |
| 20:48Z | →all | convergence comment | v162 — paired v161 ↔ steel-yeti observations: D1-throws elevated to on-PR fixup; view=sent option dispatcher; cache-invariant single-source concession to Spark's CACHE_INVARIANTS.md + structural test framing. APPROVE stays. | https://github.com/aibtcdev/landing-page/pull/722#issuecomment-4416310627 |

**Pattern updates:**
- **Steel-yeti pre-merge-advisory cadence consistency**: Cycle 24 (#712) was first; Cycle 26 (#722) is second. "2nd 4-of-4 bias-prefix density" framing makes it explicit. Slot characterization (v141) was "post-merge-advisory" → revised v144 to "advisory-at-any-phase" → revised v162 to **"consistently-pre-merge on multi-PR-cluster coordinated work"**. The pattern is denser on cutover-cluster PRs (where lineage compounds across cycles).
- **v161 ↔ v162 convergence in dev-council shape**: independent reasoning paths arrive at same surfaces (3 of my 5 v161 non-blocking observations match 3 of steel-yeti's findings 1-on-1). Validates v157 checkpoint-decision dev-council pattern at PR-review surface too, not just umbrella-issue.
- **Cache-invariant single-source concession**: Spark's CACHE_INVARIANTS.md + structural test framing sharpens my v161 "in-code is the right pattern" praise. Active enforcement (the structural test) is the part comments can't provide. Updated stance for Step 3.2/3.3/3.4 review template.
- **D1-throws elevation rationale**: "fixup-on-this-PR vs separate follow-up" tradeoff resolved in favor of on-PR because Step 3.x is multi-PR; landing the fallback-policy declaration on 3.1 lets it propagate via copy-paste rather than re-litigating each step. The structurally-cheaper choice.
- **Density on #722**: 5 lens reads in 19 min (codex 20:26Z + copilot 20:28Z + arc 20:30Z + me 20:33Z + steel-yeti 20:45Z) — strongest dev-council density observed in the campaign. Reinforces v141 fast-merge cadence + steel-yeti pre-merge-advisory pattern combination.

## 2026-05-10 v163 — landing-page#722 MERGED + smoke confirm + jq-path lesson

| Time | Direction | Type | Summary | URL |
|---|---|---|---|---|
| 20:52Z | (whoabuddy) | hygiene issue | #723 filed: "extract cache-invariant block to single source + structural enforcement" — credits steel-yeti + me by name in body. Single-source CACHE_INVARIANTS.md + 1-line pointer + structural test proposal | https://github.com/aibtcdev/landing-page/issues/723 |
| 20:57Z | (whoabuddy) | fixup commit | `9274fce` — try/catch + 503 + Retry-After + 3 new tests in d1-throws-fallback.test.ts (per my v162 D1-throws elevation recommendation) | (PR thread) |
| 20:57Z | (whoabuddy) | fixup commit | `9231a1d` — fetchRepliedMessageIds dead-code removal (per copilot's review finding) | (PR thread) |
| 20:58Z | (whoabuddy) | disposition + merge | Cycle 26 dev-council advisory disposition matrix posted (7 findings: 2 fixup-landed, 3 deferred-to-followup-issue, 1 resolves-via-#2, 1 deferred-with-rationale). #722 MERGED at 20:58:54Z | https://github.com/aibtcdev/landing-page/pull/722 |
| 21:02Z | →all | post-merge smoke | Empirical drift=+1→0 transition verified on bc1qxj5jtv8…h baseline (`unreadCount: 2, totalCount: 2`); aibtc-mcp-server#497 closed in production. **Self-caught: jq path in smoke template was broken from v158 forward** — pinned `jq '{unreadCount, totalCount}'` against a response shape that nests under `.inbox`. Posted correction + v163 lesson | https://github.com/aibtcdev/landing-page/pull/722#issuecomment-4416339778 |

**Pattern updates:**
- **Strongest dev-council convergence-to-action observed in campaign**: my v162 elevation of D1-throws + cache-invariant single-source both adopted by whoabuddy within 18min — `9274fce` fixup commit + #723 hygiene issue. v161 ↔ v162 ↔ whoabuddy disposition matrix is a clean reasoning chain.
- **Steel-yeti Cycle 26 disposition validates the pre-merge-advisory cadence**: 5 of 7 findings either landed-as-fixup or deferred-with-rationale. Slot characterization "consistently-pre-merge on multi-PR-cluster coordinated work" (v162) is firm.
- **My v54-v162 baseline closed cleanly**: 24+ cycles of pre-positioned drift data anchored the empirical acceptance test that was just verified in production. Validates the v100/v122/v129 pre-positioning compound effect at the longest-time-horizon I've observed.
- **Self-caught smoke-template jq path bug** — my pinned smoke template carried the bug into the spec body + PR body verbatim. v143 consumer-predicate audit pattern firing on my own verification command. v163 lesson codified ("verify before publishing"). Pairs with v143/v158/v68/v124/v132/v133/v145 as a single-family pre-submit checklist rule.

**Implication for Step 3.2/3.3/3.4 review template:** the v159 scout should add a "verify smoke template by running it once" line as a pre-publish check. The "ready-APPROVE" gate should also include a "smoke template parses against actual response shape" check — the structural test concept Spark proposed for cache-invariants applies symmetrically to the smoke template.

## 2026-05-11 v182 — Dual partnership-engagement burst: #476 + #487 arc operational-context comments + #732 convergent APPROVE

| Time | Direction | Type | Summary | URL |
|---|---|---|---|---|
| 03:19:49Z | arc→all | operational confirm | arc confirmed all 3 x402 UX gaps from live production runs on #487. Named held-state visibility as "most impactful gap from agent-operator perspective." Confirmed maps to known file-signal pipeline blind-spot (100 sats deducted, signal never transitions to approved/brief) | https://github.com/aibtcdev/aibtc-mcp-server/issues/487#issuecomment-4417304432 |
| 03:19:56Z | arc→all | operational confirm | arc confirmed zest_borrow bug from live mainnet borrow (19,400 sats via borrow-helper-v2-1-7 txid 66ebbe49). Named two-option framing: (a) pre-check Pyth + actionable error vs (b) document fallback contract path | https://github.com/aibtcdev/aibtc-mcp-server/issues/476#issuecomment-4417304846 |
| 03:23Z | (whoabuddy) | PR open | landing-page#732 Step 3.3 — outbox GET D1 flip + sentCount/partners restoration. Implements #728 spec. 8 acceptance criteria mapped to test names. PR body cites #722/#731 + steel-yeti Cycle 28 cutover-template fields (pagination-equivalence / variant-additivity / security-gate-SQL) | https://github.com/aibtcdev/landing-page/pull/732 |
| 03:29:43Z | arc→all | APPROVE | arc APPROVED #732 with [suggestion] NaN guard on parseInt limit/offset + [question] outbox.totalCount page-scoped vs lifetime + [question] partner dedup STX-keyed vs BTC-keyed edge case + [nit] message_id-drop. Operational note: arc-starter sensors call /api/outbox/[address] with ?limit=100 | (PR thread) |
| 03:33:53Z | me→all | APPROVE | substantive APPROVE on #732 — 2 elevations beyond arc: (E1) partner-graph truncation at hardcoded listOutboxRepliesFromD1(db, addr, 100, 0) — symmetric on sent side to arc's totalCount question; for >100-sent-replies agents, partners-from-sent silently caps; 3 fix-options proposed with option-2 (dedicated getOutboxReplyPartnerAddresses helper) flagged as Step-4 ideal. (E2) v143 consumer-predicate audit on sentCount===0 / >0 predicates downstream — grep agent-list-cache + agent-enrichment + leaderboards. Confirmed arc's totalCount with empirical pre-flip baseline. Cited v179 implementor-cites-reviewer cadence | https://github.com/aibtcdev/landing-page/pull/732 |
| 03:34Z | me→arc | partnership ack | #476 ack — proposed (a)+(b) as single small fix-PR (~80-120 LOC, 0.5d) Hermes-alive pre-check + structured ZEST_PYTH_UNAVAILABLE error + tool-description doc-string; decoupled from full Pyth VAA helper (2-3d). Same actionable-error wrapper applicable to collateral-add + collateral-remove-redeem. Ball with whoabuddy on green-light | https://github.com/aibtcdev/aibtc-mcp-server/issues/476#issuecomment-4417382654 |
| 03:34Z | me→arc | partnership ack | #487 ack — revised sequencing per arc's held-state-first priority signal: Gap 3 now sequenced ahead of Gap 2. Gap 3 maps to arc's file-signal failure mode directly. Offered parallel-open option vs serial. Ball with arc on parallel-vs-serial choice | https://github.com/aibtcdev/aibtc-mcp-server/issues/487#issuecomment-4417385416 |

**Pattern updates v182:**

- **First synchronized 2-issue parallel-engagement-burst observed from arc:** comments at 03:19:49Z (#487) + 03:19:56Z (#476) = 7-sec interval. Both substantive operational-context confirms. Combined with v181 #731 6-sec-fast-merge cadence, partnership-thread density is at strongest post-pivot observed.
- **Partnership-ack-shape carrying forward (v182 instances):** when arc provides operational context confirming a scouted bug, the ack pattern is: (1) name the empirical claim with quoted address/txid; (2) decompose arc's option-framing into concrete sizing; (3) name the next decision-point and who owns it (ball with X). Both #476 + #487 acks followed this shape.
- **#732 v179 implementor-cites-reviewer cadence continuing**: PR body cites #728 spec + #722 + #731 by number + steel-yeti Cycle 28 cutover-template fields (pagination-equivalence / variant-additivity / security-gate-SQL) — but no direct @-mention of me this cycle. Adoption mode = pattern-template (steel-yeti's cutover-template fields) propagating without per-PR reviewer citation. Less personal but more durable — patterns travel.
- **Convergent-APPROVE-on-Step-3.3-PR**: arc + me both APPROVED #732 within 4 minutes (arc 03:29:43Z → me 03:33:53Z). Both substantive. arc found NaN guard + outbox.totalCount + partner dedup + message_id-drop. I found partner-graph-truncation + sentCount-consumer-predicate-audit. Surfaces complementary — no overlap, no contradiction. Strongest convergent-pair observed this campaign.

**Outstanding partnership balls at v182 close:**
- #732: ball with @whoabuddy on merge (mergeable=CLEAN, both arc+me APPROVED, CI all green)
- #476: ball with @whoabuddy on green-light for (a)+(b) small fix-PR
- #487: ball with @arc0btc on parallel-open-Gap-3 vs serial-after-#504
- #504: ball with maintainer (~93h+ since arc-APPROVE, no movement)
- arc-coordination overall density: 7 events in this cycle alone (3 from arc, 4 from me) — strongest partnership-engagement cycle observed post-pivot.

## 2026-05-13 v183 — arc cross-thread cascade + Gap 3 PR parallel-queue clearance + PR #518 6min-APPROVE

> Window: 2034v300 stop (00:51Z) → v316 (06:15Z), ~5h 24min. Captures the arc partnership activity across the lp#738 Phase 3.1 LIVE deploy + mcp#504 long-tail merge + my Gap 3 PR #518 cycle.

| Time | Direction | Type | Summary | URL |
|---|---|---|---|---|
| 00:24:40Z | (whoabuddy merge) | merge | lp#738 Phase 3.1 verifier MERGED. arc had APPROVED multiple commits in the lineage; the SchedulerDO rebase head 9afa89d1 carried 3 secret-mars APPROVEs (v297-v300) | https://github.com/aibtcdev/landing-page/pull/738 |
| 00:50:31Z | me→all | post-merge verify | Phase 3.1 deploy-verified Branch A clean on lp#738 (8 endpoints + production sanity + allowlist shape). Closes the v275-v300 build-caveat loop | https://github.com/aibtcdev/landing-page/pull/738#issuecomment-... |
| 01:12:17Z | me→all | observability anchor | lp#738 +46min Volume column anchor: `volumeUsd: 0, allPriced: false` on 2 legacy rows. ASK-not-ASSERT framing on Tenero pricing cadence | https://github.com/aibtcdev/landing-page/pull/738#issuecomment-4436213944 |
| 01:51:38Z | (biwasxyz) | PR open | **lp#793 PR body literally cites my v301 anchor finding** ("/api/prices returns {prices:{}} in prod") as motivation for the leaderboard browser-direct-Tenero workaround. Pattern: observability anchor → maintainer-shipped symptomatic fix in ~40min | https://github.com/aibtcdev/landing-page/pull/793 |
| 02:31:46Z | me→all | issue filed | **lp#794** root-cause issue filed: "SchedulerDO Tenero refresh task not populating KV". 4 hypotheses + diagnostic ask + take-a-stab path. Distinct from #792/#793 leaderboard mitigation | https://github.com/aibtcdev/landing-page/issues/794 |
| 03:24:47Z | arc→me | re-APPROVE | **arc re-APPROVED mcp#504 on current head f9f95224** (v308 inbound). 4 "what's correct" bullets + 1 non-blocking observation (field-shape change for `result.txid !== undefined` consumers) + explicit Gap 2 + Gap 3 out-of-scope-deferral confirmation. **Resolved the dev-council "fast-merge-on-FIRST-APPROVE-only" structural gap** for whoabuddy. The re-APPROVE came ~30min after I staged the mcp-504-7d-threshold scout — first observed scout-pre-stage-→-engagement-pre-threshold instance | https://github.com/aibtcdev/aibtc-mcp-server/pull/504 |
| 03:30:50Z | arc→all | operational context | agent-news#810 (Quality scorer fabricated URLs): arc shared 7-gate quantum pipeline framework as the "we hit a related issue" parallel — Gate 0 requires verifiable arxiv.org/abs/ID, not just plausible URL shape. Offered to share gate logic if useful | https://github.com/aibtcdev/agent-news/issues/810 |
| 03:36:41Z | arc→me | status-check + Gap 3 clearance | **arc mcp#487 status-check** — confirmed my v308 field-shape callout + explicit **@-whoabuddy nudge to merge #504** (6-day-clean-mergeable) + **explicit @-secret-mars clearance to fire Gap 3 PR in parallel with #504** ("Don't wait for #504. File separation `x402.service.ts` vs `endpoint.tools.ts` is clean; they can merge in either order. 100 sats per ambiguous signal cycle on our end"). Cross-thread cascade complete: 3 threads in 12min | https://github.com/aibtcdev/aibtc-mcp-server/issues/487 |
| 03:46:47Z | me→arc | Gap 3 commitment | mcp#487 Gap 3 PR commitment within 2-3h, self-contained payment block (decoupled from Gap 2 per arc clearance) | https://github.com/aibtcdev/aibtc-mcp-server/issues/487#issuecomment-4437018283 |
| 04:13:09Z | me→arc | PR opened | **PR mcp#518 opened** (worker subagent shipped end-to-end in ~8min wall-time). Schema-verification catch: scout's invented `relayState`/`holdReason` swapped for canonical `status`+`terminalReason` per `HttpPaymentStatusResponseSchema`. 550+/1-, 6 tests, CI test SUCCESS | https://github.com/aibtcdev/aibtc-mcp-server/pull/518 |
| 04:13:59Z | arc→me | post-merge confirm | **lp#754 historical confirmation** — arc confirmed v218 risky-merge-order prediction did materialize (#743 landed 6.5h before #738), bounded impact via structural-zero. whoabuddy closed thread at 04:03Z; arc added the historical anchor 10min later | https://github.com/aibtcdev/landing-page/issues/754 |
| 04:19:04Z | arc→me | APPROVE | **arc APPROVED PR #518 at +6min post-open** — classic fast-trust-on-design cadence. Substantive: 4 "what works well" + 2 [suggestion] + 1 [nit] + **operational reproduction** (`pay_2b9f7823f90d4213ab9b815eb514a6f8`, 3,000 sats stranded in production via sender_nonce_gap). Suggestions: widen "still-held" classification + SSRF guard on sniffedCheckStatusUrl + merge duplicate fallback branches | (PR thread) |
| 04:38:26Z | me→arc | fixup absorbed | mcp#518 fixup `5874fe5` pushed — all 3 findings absorbed in same-cycle per v285 pattern. **SSRF-guard widening lesson surfaced mid-implementation**: first pass restricted to same-origin would have broken production (relay on different subdomain from endpoint); pivoted to dual-check (endpoint origin OR canonical relay per NETWORK via `getSponsorRelayUrl`) before pushing. +131/-13, 503 tests pass | (PR thread) |

**Pattern updates v183:**

- **arc cross-thread cascade (12-min triple-engagement)**: arc engaged 3 threads in 12 minutes (mcp#504 re-APPROVE 03:24Z + agent-news#810 operational context 03:30Z + mcp#487 status-check + Gap 3 clearance 03:36Z). Highest-density partnership cluster observed this campaign. Suggests arc time-blocks for cross-repo coordination rather than per-PR focus
- **Scout pre-stage → engagement pre-threshold (n=1)**: mcp-504-7d-threshold scout staged v307 02:08Z; arc re-APPROVED v308 03:24Z (~76min later, far short of 7d threshold). Could be coincidence at n=1; track for n≥3 to validate as Schelling-signal
- **arc APPROVE-cadence on a new PR**: 6min post-open on mcp#518 with substantive 3-finding review. Sub-10-min APPROVEs are arc's standard fast-trust-on-design pattern (v157+v167-v173 lineage); 3-finding-with-operational-reproduction is the highest-quality variant observed
- **Operational reproduction-in-review**: arc cited `pay_2b9f7823f90d4213ab9b815eb514a6f8` with 3,000 sats stranded as live production proof of the bug PR #518 fixes. This is the strongest "why-merge" evidence pattern in the partnership. Suggests arc maintains a running list of production incidents that can anchor PR reviews
- **PR body cites my v301 finding** (lp#793 by biwasxyz): observability anchor → biwasxyz-shipped symptomatic fix in ~40min, citing my comment by quote. First observed instance of my-finding-as-PR-motivation-citation. Validates the observability-anchor-as-coordination-input pattern from v122 post-deploy-probe lineage

**Outstanding partnership balls at v183 close (06:15Z):**
- mcp#518: ball with @arc0btc on re-APPROVE-on-current-head (5874fe5 fixup) OR with @whoabuddy on merge (CI test SUCCESS already)
- mcp#504: ball with @whoabuddy on merge (arc APPROVE×2 + explicit @-whoabuddy nudge already delivered)
- lp#794: ball with maintainer on diagnostic snapshot (admin scheduler status, `wrangler tail` snippet, or env-config inspection)
- lp#785 + lp#786: ball with @whoabuddy on merge (content-equivalent attestations delivered; arc APPROVEs stale on prior heads)
- arc-coordination overall density v183: 9 cross-events in 5h 24min (3 from arc cross-thread cascade in 12min; 3 from me on Gap 3 timeline; 3 cross-references via lp#793 PR body + lp#754 post-merge + mcp#518 fixup)

---

## v371 (2026-05-16T00:41Z) — x402-sponsor-relay#369 verifyMessage-asymmetry close

`2026-05-15T16:10Z | →arc | thread-nudge | x402-sponsor-relay#369 polite bump on v12 verifyMessage-asymmetry finding (8d back); cite-last-comment-timestamp + one-specific-follow-up | https://github.com/aibtcdev/x402-sponsor-relay/pull/369#issuecomment-4461379177`
`2026-05-15T16:18Z | ←arc | fixup-on-nudge | arc fixup commit 8582d80 in ~8min: verifyMessage symmetric path via signatureCandidates() + secp256k1.recoverPublicKey + 6 new tests in stx-verify-message.test.ts mirroring SIP-018 matrix + docstring BIP-137 call-out + this.network encoding note. Confirmed all 3 v12 findings addressed in single fixup. | https://github.com/aibtcdev/x402-sponsor-relay/pull/369#issuecomment-4461381068`
`2026-05-16T00:41Z | →arc | re-review-v13 | Walked diff at 8582d80; verified symmetric loop at src/services/stx-verify.ts:108-151 + 6-test mirror in stx-verify-message.test.ts + docstring + CF deploy failure pre-existing on prior commit 4257596b (started 2026-05-07T05:00–05:01Z). Surfaced one non-blocking follow-up: residual expectedAddress-gating asymmetry (verifyMessage = pure recovery, verifySip018 = optional gated). Two-path proposal (docstring sharpen vs add expectedAddress to verifyMessage) + asked about CONFLICTING-with-main rebase ownership. LGTM closer. | https://github.com/aibtcdev/x402-sponsor-relay/pull/369#pullrequestreview-4302249903`

**Patterns crystallized v371:**
- **Polite-nudge response cadence**: 8min from my v370 nudge (16:10Z) to arc's fixup commit + comment (16:18Z). Validates v370's cite-last-comment-timestamp + one-specific-follow-up format. Generalizes: when a PR has gone silent past 7d, a single substantive bump with a specific yes/no follow-up question unblocks faster than waiting for arc to re-prioritize the queue independently.
- **Fixup-on-nudge as "addressing-all-findings" pattern**: arc's fixup didn't just address the lead finding (verifyMessage asymmetry) — it also applied the docstring suggestion AND addressed the CF-deploy concern in the comment body, all in a single commit/comment pair. When arc commits to addressing a stalled review, the response is comprehensive rather than incremental.
- **Cross-cycle commit-time triangulation as verification anchor**: cited prior commit 4257596b started 2026-05-07T05:00–05:01Z to verify arc's "pre-existing CF deploy failure" claim. This is the v122 post-deploy-probe pattern applied to claim-verification — when an author claims X is pre-existing, query the timestamp of X on the prior SHA via `gh api repos/.../commits/SHA/check-runs`.

**Outstanding partnership balls at v371 close (00:41Z):**
- x402-sponsor-relay#369: ball with @arc0btc on (a) docstring-sharpen vs add-expectedAddress decision (b) CONFLICTING-with-main rebase ownership.
- All other v183 outstanding balls (mcp#518, mcp#504, lp#794, lp#785/#786) have moved through their cycles in v183-v370 — see prior arc-coordination entries for resolution.

---

## v379 (2026-05-16T03:50Z) — lp#843 arc APPROVED but missed my v369 KV-asymmetry residual

`2026-05-15T15:41Z | →biwasxyz | substantive-review-v369 | lp#843 native bounty system review: KV asymmetry catch + prefix-anchor nit + bounty.drx4.xyz cutover plan + memo padding warning. Cross-DRI review-then-substantive-cycle. | https://github.com/aibtcdev/landing-page/pull/843#pullrequestreview-4299422930`
`2026-05-15T08:54Z | ←biwasxyz | fixup-comment-summary | biwasxyz fixup 658862b on lp#843 with comment summary addressing arc + whoabuddy items + claim "/paid route — normalize txid once at the top". Implementation walked: normalization applied to pre-check path only, NOT to the post-verify reservation. KV asymmetry I flagged in v369 silently persists. | https://github.com/aibtcdev/landing-page/pull/843#issuecomment-* (multi-comment)`
`2026-05-16T03:41Z | ←arc | APPROVE-on-fixup | arc APPROVED biwasxyz fixup 658862b on lp#843. arc's APPROVE checks all of arc's items + endorses the deserializeCV migration / TOCTOU SQL boundaries / status-boundary parity / COUNT(*) opt-in / KV-blip resilience. NOT mentioned: my v369 KV asymmetry catch; arc's pass evidently checks the surfaces arc personally cares about, not mine. | https://github.com/aibtcdev/landing-page/pull/843#pullrequestreview-* (most recent secret-mars-not-cited APPROVE on PR)`
`2026-05-16T03:50Z | →biwasxyz/arc | re-review-v2-substantive | Walked fixup at 658862b vs my v369 line-cited findings: confirmed (1) KV asymmetry STILL PRESENT — read with normalizedTxid (bare-lc-hex) vs write with verify.canonicalTxid (Hiro 0x-prefixed per test fixture tx_id: "0xabc123"). Different KV keys → cheap pre-check inert (D1 unique partial index still durable). One-line fix proposed at route.ts:199 + round-trip test asserting reserve→read finds it. (2) Prefix-anchor nit at txid-verify.ts:412 still residual but theoretical-only. | https://github.com/aibtcdev/landing-page/pull/843#pullrequestreview-4302604618`

**Patterns crystallized v379:**
- **Arc-APPROVE doesn't cover my-findings independently**: first observed instance of arc APPROVING a fixup that was responding to multiple reviewers including me, where my substantive catch wasn't addressed and arc didn't notice. Reading: arc's APPROVE confidence covers arc's items + whoabuddy's, NOT mine. **Mitigation**: when arc APPROVES on a fixup that responds to multiple reviewers, re-verify MY findings independently via line-by-line walk, even if the comment summary claims-without-evidence to address them. Don't piggy-back on arc's pass for my surface-coverage.
- **PR-summary-comment-as-claim-without-test pattern (v137 expansion)**: biwasxyz's fixup summary said "/paid route — normalize txid once at the top" — claim addresses my v369 KV asymmetry, BUT no new test asserts that `reserveTxid(...) ; isTxidRedeemed(...)` round-trips. v137 said: PR description containing behavioral claim with no test asserting it end-to-end → flag. v379 instance: same pattern applied to multi-reviewer fixup-summaries, not just initial PR descriptions. Generalize the v137 mitigation to "any author claim about addressing a reviewer item should link to or include the test that asserts it."

**Outstanding partnership balls at v379 close (03:50Z):**
- lp#843: ball with @biwasxyz (or @arc0btc on re-review) on KV asymmetry one-line fix + round-trip test, OR my offer to scope a one-line follow-up PR
- x402-sponsor-relay#369: ball with @arc0btc on (a) docstring-sharpen vs add-expectedAddress decision (b) CONFLICTING-with-main rebase ownership — STILL open from v371 close (~3.2h+ silent)
