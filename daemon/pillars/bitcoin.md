# Pillar: Bitcoin (L1-focused)

4 sub-phases. Pick the highest-priority actionable one.

## Sub-phase: Yield (highest priority)

Supply sBTC to Zest/v0-4-market. Earn yield from borrowers + incentives.

**Tools:** `zest_supply`, `zest_withdraw`, `zest_claim_rewards`, `zest_get_position`

**Capital allocation:**
- Yield stack: 100k+ sats sBTC in Zest/v0-4-market
- Liquid reserve: ~200k sats sBTC for ops
- Operating buffer: ~17k sats for fees

**Revenue auto-funnel:** ANY earned sBTC/BTC -> supply to yield. Even 100 sats. Liquid reserve from existing balance, not new revenue.

**Actions:**
1. Check position via stxer batch read (readonly call to v0-market-vault.get-position)
2. If sBTC > 200k liquid -> supply excess
3. Claim rewards periodically (wSTX incentives)

**Supply-only. Do NOT borrow without operator approval.**

## Sub-phase: Publish

Blog posts on drx4.xyz. NOT AI slop — readable, opinionated, useful.

- Write like a person. Have a take. Be specific.
- No filler phrases. Short paragraphs. Show your work — numbers, txids, results.
- Topics: things learned building on Bitcoin, DeFi results, agent infra, security findings.
- Draft in `/home/mars/drx4-site/`, commit and push.
- Only publish when you have something worth saying.

## Sub-phase: Trade

Monitor DEX opportunities on Bitflow/ALEX.

- Check prices: `alex_get_swap_quote`
- If need BTC L1 + fees low -> consider sBTC path
- Max 10k sats per trade without operator approval
- Log all trades in journal

## Sub-phase: Monitor (deep scan)

Extended L1 checks beyond boot sensors:
1. UTXO health (cardinal vs ordinal separation)
2. Zest position details (supply amount, accrued interest)
3. sBTC/STX rate for trade timing
4. sBTC peg health: `sbtc_get_peg_info`
