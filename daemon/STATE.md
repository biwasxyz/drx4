# State -- Inter-Cycle Handoff
## cycle 2034v246 — lp#738 doc-drift via preview probe (route.ts:31 "501 Not Implemented" stale)

cycle: 2034v246
at: 2026-05-12T05:28Z
status: shipped

## OPERATOR DIRECTIVE (active — /start args 2026-05-11)
> "we need to closely look into the prs and updates on the trading competition on both mcp and landing-page so we need to keep looking into the PRs review them test them using the preview url focus your 100% on those okay file an issue tag whoabuddy/arc"

## v246 ship
**lp#738 non-blocking comment** (issuecomment-4427595315, verified 200) — preview-probe drift finding on /api/competition/trades self-doc:
- Probed all 3 endpoints on 592fe2ec preview: trades (GET+POST), allowlist, cron
- `/api/competition/trades?docs=1` top-level `description` claims POST is "(ships in Phase 3.1 PR-B; currently 501 Not Implemented)" at route.ts:31
- Actual POST behavior: HTTP 400 on bad txid validation, HTTP 404 on tx_not_found — fully wired, NOT 501
- Sub-section `post` already describes the implemented contract (200/202/400/404/409 codes)
- 1-line fix; non-blocking; fine for fixup-here or follow-up docs PR

## v246 endpoint probe findings (positive)
- `/api/competition/allowlist` → HTTP 200, returns 4 contracts (stableswap-stx-ststx + xyk-core + xyk-swap-helper + dlmm-swap-router) with their function whitelists
- `/api/competition/cron` GET self-doc → HTTP 200, auth via X-Cron-Secret header
- `/api/competition/trades?address={my_stx}` → HTTP 200, returns 1 sample trade (preview DB pre-seeded with my address as test data)
- POST validation gate: rejects empty/malformed txid with "Invalid `txid`. Expected a 64-character hex string (optionally 0x-prefixed)" + `retryable:false`
- POST happy-path-near-miss: 0x000...0001 → tx_not_found, retryable:false (correct propagation)

## v246 boot SHA-compare
- All comp surfaces unchanged since v245 (lp#651, lp#738/5224a0d9, lp#743/412f91ff, mcp#510/521c2466)
- main lp HEAD unchanged 60622b2f
- Side observation: mcp#497 (closed) had whoabuddy closure-confirmation comment at 05:24Z citing my v149 tracking comment positively; not actioning, just noting

## Pending on resume
- arc re-review on **lp#738 5224a0d9** + my v246 doc-drift fix-up
- arc re-review on **lp#743 412f91ff** (stale APPROVE on dd48fcf7)
- whoabuddy/biwasxyz response on **lp#651** scope question (v241)
- **#738 merge** = primary gate; **mcp#510 merge** unblocks after

## Cadence
- 1800s. Tighten to 900s on engagement.
