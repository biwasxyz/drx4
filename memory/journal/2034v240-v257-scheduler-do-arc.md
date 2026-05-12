# 2034v240→v257: SchedulerDO architectural arc

**Session window:** 2026-05-12T02:26Z (v240 boot from /stop) → 08:55Z (v257 closing APPROVE on lp#743/46e6badb), ~6.5h.

**Operator directive (active throughout):** "100% focus on trading-comp PRs across MCP + landing-page, review/test via preview URLs, file ONE issue tagging @whoabuddy + @arc0btc."

## Headline

The full architectural thread for `SchedulerDO` (Tenero price refresh + competition Hiro sweep as Durable Object alarm-driven background work in `aibtcdev/landing-page`) closed cleanly across 4 pivots, 1 production incident, and 18 cycles. My finding-thread carried through each transition; **2 of my static-analysis hypotheses appeared verbatim in maintainer fix-commit messages** (b8abf98f and #772 PR body).

## Surfaces touched

- **lp#651** (dashboard balance/portfolio) — superseded by #743 architecture; my v241 scope clarification surfaced 3 drifts (route names, file-level collision, schema drift)
- **lp#738** (Phase 3.1 verifier + read routes + allowlist + cron) — 5 APPROVES from me on bed7cd0 (comp-start gate) + 5224a0d9 (KV→D1 cursor refactor); my v246 doc-nit on stale "501 Not Implemented" string
- **lp#743** (/leaderboard MCP-trade-count + USD volume + SchedulerDO) — 3 APPROVES (412f91ff, 46e6badb closing), 3 operational flags during bundling+migration incident; v249 pre-staged scout adapted to v257 final review
- **lp#764** (rework dashboard rebuilder to DO-alarm, filed by whoabuddy) — v218/v220 second-opinion + NonceDO trigger-semantics empirical read
- **lp#765** (DO-alarm scheduler bridge for verifier cron) — my v242 event-driven-vs-poll-driven distinction drove biwasxyz to close #765 and pivot to D1-cursor
- **lp#768** (SchedulerDO design) — my v247 comment landed 3 findings + cross-PR clarification; materialized as #743's 12-commit batch within ~1 hour
- **lp#772** (v2 deleted_classes hotfix) — production restoration after misdirected v1 migration hit production worker; my v254 hypothesis #2 verbatim-confirmed in the body; +1 reaction shipped
- **mcp#510** (competition trading tools + Bitflow provider) — chained behind #738; arc re-APPROVED at 03:21Z

## Decision pivots (chronological)

1. **v218** — whoabuddy filed #764 proposing DO-alarm rework for the dashboard rebuilder. My second-opinion APPROVED the pattern with substantive observations.
2. **v220** — Did a deeper read of `nonce-do.ts` to empirically verify trigger-semantics. Found NonceDO is event-driven (ACTIVE on deposit-arrives), unlike the chunked-sweep verifier which is poll-driven. Worth-naming-for-impl finding.
3. **v242** — biwasxyz filed #765 (DO-alarm scheduler bridge for verifier cron) cc'ing me, arc, whoabuddy. My response surfaced the event-vs-poll distinction with concrete trigger-gate suggestion. **biwasxyz closed #765 at v244** with explicit reasoning that state-store + scheduler-primitive selection are orthogonal once the cursor moves to D1.
4. **v244** — biwasxyz pushed lp#738 5224a0d9 implementing the cursor KV→D1 refactor. My APPROVE with non-blocking KV-orphan observation (cron's `INSERT OR IGNORE` makes restart-from-head correctness-safe).
5. **v247** — whoabuddy filed #768 broadening scope (Tenero prices + competition Hiro sweep under one `SchedulerDO`), cc'ing me. My response identified two orthogonal adaptive directions: find-rate-from-below (my v242) + rate-limit-from-above (whoabuddy's Option C). They compose.
6. **v249** — biwasxyz materialized #768 in 12-commit batch within ~1 hour, with Claude Co-Authored-By trailer. I pre-staged a scout review (`daemon/scouts/743-scheduler-do-comment.md`) instead of shipping immediately — chose restraint during active iteration.

## Bundling + migration incident (v250 → v257)

**v250-v251:** Build green on `62fb3b09` per CF check_runs but every route on the branch preview returned HTTP 404 with `x-preview-user-error: true`. CF's "Deployment successful" status only confirms build+upload, not runtime correctness — operator's "test via preview URL" directive specifically closes this gap. I shipped a brief flag on #743.

**v252:** Static-analysis hypothesis posted in STATE narrative: "Universal 404 must be in bundle-time machinery (OpenNext.js bundling failing to handle `cloudflare:workers` DurableObject import)."

**v254:** Build still failing after biwasxyz's inline-SchedulerDO fix at b8abf98f. Posted second flag listing 2 hypotheses: (1) DurableObject base class still stripped despite inline; (2) migration-tag conflict with OpenNext-managed DOs.

**Production incident:** biwasxyz had temporarily flipped the deploy command from `wrangler versions upload` to `wrangler deploy --env preview`. Cloudflare Workers Builds overrode `--env preview` worker name back to `landing-page` (production). v1 SchedulerDO migration was applied to PRODUCTION worker, not preview. Result: orphaned namespace on aibtc.com; rollback refused by CF (couldn't roll past applied migration).

**v256:** biwasxyz filed + merged #772 at 08:30Z — `v2: deleted_classes` forward migration cleans up the orphan. Production restored. My v254 hypothesis #2 ("migration-tag conflict") was the actual root cause (with a different shape than I'd guessed — preview-vs-production target confusion, not OpenNext-DO collision). +1 reaction shipped.

**v257:** biwasxyz force-pushed rebased #743 branch at 08:38Z onto main+#772, then posted 08:42Z platform-constraint write-up (error 10211 — non-prod CI can't apply DO migrations; no preview URL for DO workers; v4 deleted_classes rollback path baked in). Adapted my pre-staged scout to post-rebase reality and shipped closing APPROVE.

## Hypothesis-validation closed loops

Two of my static-analysis hypotheses got verbatim-confirmed in maintainer commit messages:

| Hypothesis | Shipped where | Confirmation |
|---|---|---|
| "Universal 404 must be in bundle-time machinery (e.g., OpenNext.js bundling failing to handle `cloudflare:workers` DurableObject import)" | v252 STATE narrative + v251 PR comment | biwasxyz's b8abf98f commit message: "workerd refused to start with 'no such actor class; c = SchedulerDO'... importing SchedulerDO from ./lib/scheduler/scheduler-do and re-exporting from worker.ts didn't survive the OpenNext + wrangler esbuild pipeline. The class was stripped from the deployed bundle..." |
| "Migration-tag conflict surfaced once the class registered" | v254 PR comment | biwasxyz's #772 PR body: "v1 SchedulerDO migration was applied to the production worker, not the intended preview worker" |

The pattern (codified in v255 learning): when you can't access debug artifacts, well-bounded static-analysis hypothesis SHIPPED publicly as a PR comment becomes a validation oracle via the maintainer's fix-commit message. Prerequisites: hypothesis must be testable + shipped publicly.

## Patterns codified during this arc

(see `memory/learnings/active.md`)

- **v246/v248 preview-URL deep-probe** — 4-axis runtime probe (self-doc, validation, idempotency, cursor) after PR APPROVE closes the gap between PR-review architectural correctness and runtime-edge-case validation drift
- **v253 engagement-cadence-with-maintainer-iteration** — 3 modes (active-iteration / diagnostic-stall / hard-wait), each with different cadence + ship-vs-hold posture; operational signals ≠ nits; build status ≠ runtime status; cadence-vs-cache-miss tradeoff
- **v255 hypothesis-validation-via-commit-message** — diagnostic-without-trace-access as a third hypothesis channel after PR-review-time substantive + post-APPROVE probe
- **v260 drift-tell-verification under operator-narrow override** — when operator-narrow override is active, periodic broader-sweep verification confirms no missed signal without acting outside scope

## Coordination dynamics observed

- **biwasxyz**: high iteration velocity (12 commits in 5 min). Uses Claude (Co-Authored-By trailer on all fix commits). Cites my findings in fix-commit messages — implies my comments feed into their Claude prompts. Fast-iteration cycles produced both speed AND mid-flight bugs (production incident) that explicit pre-merge lessons baked in (#743 08:42Z comment).
- **whoabuddy**: architecture-decision owner. Files cluster-shaping issues (#768 SchedulerDO design, #772 hotfix). Less review-side engagement. Tag me explicitly when scope-deciding.
- **arc**: active on parallel surfaces (mcp#510 re-APPROVE at 03:21Z, x402-sponsor-relay separately) but quiet on trading-comp landing-page during this arc. Stale-but-not-revoked APPROVE on lp#743's dd48fcf7 (the PR-level APPROVED reviewDecision was carried forward).

## Closing state at v257

- lp#651 BLOCKED — scope question to whoabuddy pending
- lp#738 5224a0d9 CLEAN — my APPROVE×5, awaiting arc/whoabuddy formal approve on this SHA
- lp#743 46e6badb DIRTY APPROVED — my closing APPROVE, CI red expected (10211), awaiting whoabuddy merge
- mcp#510 521c2466 — both APPROVE+CLEAN, chained behind lp#738 merge
- main lp HEAD a0b16768 (production restored via #772)
- 3 pre-staged scouts ready (`daemon/scouts/`) for post-merge actions
