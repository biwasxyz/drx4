# Code Scout: PR #8 aibtcdev/agent-contracts — Pegged DAO v2

**Date**: 2026-03-11
**PR**: https://github.com/aibtcdev/agent-contracts/pull/8
**Repo**: aibtcdev/agent-contracts
**Author**: pbtc21 + Claude Opus 4.6

## Summary

Removes guardian council, replaces with reputation-weighted treasury governance (80% threshold). 6 new contracts (reputation-registry, treasury-proposals, auto-micro-payout, token-pegged, dao-pegged, upgrade-to-free-floating) + init proposal + 109 comprehensive tests.

**Verdict**: APPROVE with H2 fix required before mainnet.

## Key Findings

### HIGH

1. **H1: Auto-micro-payout treasury drain risk** — Depends on checkin/proof registry audit. Rate-limited but unguarded. Acceptable if external registries are audited.

2. **H2: Dissenter refund double-spend via token transfer** — Snapshot taken during voting period, claim checked post-vote. Agent can:
   - snapshot-my-balance() while holding 100 tokens
   - transfer all 100 tokens to another address
   - claim dissenter refund for 100 tokens anyway
   - Result: same tokens refunded twice, ledger inconsistent
   
   **Fix**: Snapshot post-vote OR check current balance >= snapshotted balance at claim time
   
   **Location**: upgrade-to-free-floating.clar lines 1207-1215 vs 1270-1320

### MEDIUM

1. **M1: Unlimited proposal size** — Member with 1 rep can propose entire treasury drain. 80% vote needed to pass, but phishing/vote-buying risk. Add max-size limit as % of treasury.

2. **M2: Zero entrance tax at init** — Tax set as constant in init proposal. Founders could init with 0%, accumulate deposits, then raise tax. Document tax in charter.

3. **M3: Epoch boundary rate limit bypass** — Agent can claim 10 payouts before epoch boundary, 10 after, totaling 20 in ~1 minute. Per-epoch limit, not per-time. Low risk but document as feature.

### LOW

1. **L1: Treasury.conclude() doesn't pre-check balance** — If sBTC insufficient, proposal stays "active" instead of failing
2. **L2: SIP-010 compatibility** — redeem() doesn't match standard burn signature

### INFORMATIONAL

1. **I1: PR #9 phase ratchet** — Merge PR #9 first (adds one-way phase ratchet to prevent regression)
2. **I2: Missing test cases** — Reputation changes during active vote, treasury balance insufficient at conclude()

## Audit Trail

- **File**: /tmp/pr8.diff (3080 lines, full diff of PR)
- **Tests**: 109 passing, covers construction/voting/upgrade/edge cases
- **Contracts affected**: 6 new pegged/ contracts, 1 init proposal, 2 deployment stages
- **Lines reviewed**: All 6 contract files (reputation-registry.clar through upgrade-to-free-floating.clar)

## Posted Review

Detailed review posted as GitHub comment: https://github.com/aibtcdev/agent-contracts/pull/8#issuecomment-4039593083

## Actionable Next Steps

1. **Before merge**: Fix H2 (dissenter refund snapshot)
2. **Before mainnet**: Audit checkin/proof registries (H1 dependency)
3. **By next vote**: Add M1/M3 governance improvements
4. **Coordination**: Ensure PR #9 (phase ratchet) merges with this PR

## Architecture Notes

- Removes privileged guardians → full on-chain reputation-weighted voting
- 80% threshold (up from 75% in v1) provides strong supermajority requirement
- 3 independent treasury access paths: auto-payout (unguarded), proposals (voted), dissenter refunds (voted)
- Token pegged to sBTC 1:1 during Phase 1, upgradable to free-floating (Phase 2)
- All v1 security fixes (M1/M2/M3/C2/H1/H3/H4/L4/L8) carried forward

## Related PRs

- PR #7: Original guardian council design (superseded by v2)
- PR #9: Phase ratchet fix + 23 additional tests (should merge with or before #8)
- PR #3: Fixed treasury address in init (merged)
