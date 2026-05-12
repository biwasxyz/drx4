# State -- Inter-Cycle Handoff
## cycle 2034v248 — preview deep-probe pattern codified; limit-validation inconsistency queued

cycle: 2034v248
at: 2026-05-12T06:42Z
status: shipped

## OPERATOR DIRECTIVE (active — /start args 2026-05-11)
> "we need to closely look into the prs and updates on the trading competition on both mcp and landing-page so we need to keep looking into the PRs review them test them using the preview url focus your 100% on those okay file an issue tag whoabuddy/arc"

## v248 ship
**Learning codified to memory/learnings/active.md (~30 lines)** — "preview-URL deep-probe as substantive value-add after APPROVE" pattern crystallizing v246+v248 lineage:
- After APPROVE, pivot to endpoint probing on branch preview URL
- 4-axis probe set: self-doc endpoints, validation edge cases, idempotency re-submission, cursor/pagination robustness
- Closes gap between PR-review correctness and runtime-edge-case validation drift
- Pre-merge multi-lens complement to v167-v173 post-merge advisory
- Throttle: max 1 nit-comment per PR per ~30min session window to avoid pile-on

## v248 endpoint probe — new finding queued (NOT yet posted)
**lp#738 limit-validation inconsistency at route.ts:130-140:**
- `limit=banana` (non-numeric) → HTTP 400 reject with "Expected integer in [1, 200]"
- `limit=0` / `limit=-1` / `limit=10000` (numeric out-of-range) → silently clamped via `Math.min(Math.max(parsed, 1), 200)`, 200 OK response
- `limit=200.5` (float) → parseInt strips decimal → 200, accepted
- Inconsistency: error message implies range gate but only NaN check rejects; out-of-range numerics silently clamp
- **NOT a bug, but contract drift**. Deferred to avoid pile-on (v246 doc-nit already on #738 awaiting biwasxyz response)

**Positive v248 endpoint findings:**
- Idempotency: re-submit seeded txid → HTTP 409 `txid_already_verified` with full `existing_row` payload (helpful)
- Address validation: SP=accept, SM=accept-empty, ST(testnet)=reject, malformed=reject, missing=reject — all with helpful 400+example
- Cursor: malformed-base64 → clean 400 error
- Seeded sample trade in preview DB for my address (test fixture)

## v248 boot SHA-compare
- All comp surfaces unchanged since v247 (lp#651, lp#738/5224a0d9, lp#743/412f91ff, lp#768/issue, mcp#510/521c2466)
- main lp HEAD: `45e70f94` (#769 rate-limit migration to RATE_LIMIT_STRICT — unrelated to comp surface)
- v246 doc-nit + v247 SchedulerDO comment no maintainer response yet

## Pending on resume
- biwasxyz response on **lp#738 v246 doc-drift** + possibly v248 limit-validation if I file
- whoabuddy/biwasxyz pivot/response on **lp#768 SchedulerDO** + implementation PR
- arc re-review on **lp#738 5224a0d9** + **lp#743 412f91ff**
- whoabuddy/biwasxyz response on **lp#651** scope question
- **#738 merge** = primary gate

## Cadence
- 1800s. Tighten to 900s if SchedulerDO PR opens or any thread engages.
