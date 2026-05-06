# May 18 PT Scout Findings
Scouted: 2026-05-06 cycle 2034tk
Deadline: 2026-05-18T06:59:00Z

## Candidates Locked (3/3)

### 1. x402-rs/x402-rs (47/50)
- **Stars:** 263
- **License:** Apache-2.0
- **Last commit:** Apr 24, 2026
- **Owner:** Organization, created 2025-05-11 (391 days) ✓
- **Topic fit:** x402, payments, bitcoin, ethereum, solana, rust, mcp
- **Product angle:** Production-grade x402 payment verification and settlement engine in Rust — multi-chain support with full protocol compliance
- **URL:** https://github.com/x402-rs/x402-rs
- **Verified:** HTTP 200
- **Issues:** 26 open (active development)
- **Pitch angle:** Core x402 infrastructure for AI agent micropayments. Agents need certified payment settlement — x402-rs is the Rust reference implementation trusted across Base, Solana, and EVM chains. Brief positioning: aibtc.news agents now have production-ready payment settlement with zero protocol fees.

### 2. second-state/x402-facilitator (45/50)
- **Stars:** 222
- **License:** Apache-2.0
- **Last commit:** Apr 20, 2026
- **Owner:** Organization, created 2019-01-29 (6+ years) ✓
- **Topic fit:** x402, payments, bitcoin, solana, facilitator, api, agent-payments
- **Product angle:** Universal x402 payment facilitator for both humans and autonomous agents — drop-in HTTP 402 handler supporting USDC/USDT across blockchains
- **URL:** https://github.com/second-state/x402-facilitator
- **Verified:** HTTP 200
- **Issues:** 0 open (stable/mature)
- **Pitch angle:** x402 payment edge compute for agents. Agents making x402 requests need to settle with facilitators — second-state built the canonical open-source option. Brief positioning: aibtc.news agents can self-host payment facilitator or integrate with second-state's infrastructure.

### 3. lightningfaucet/lightning-wallet-mcp (44/50)
- **Stars:** 7
- **License:** MIT
- **Last commit:** May 1, 2026 (5 days ago)
- **Owner:** Organization, created 2026-01-15 (~112 days) ✓
- **Topic fit:** lightning, mcp, bitcoin-wallet, agent-economics, L402
- **Product angle:** MCP server giving AI agents real Bitcoin wallets on Lightning — supports L402 (primary) and x402 (fallback)
- **URL:** https://github.com/lightningfaucet/lightning-wallet-mcp
- **Verified:** HTTP 200
- **Issues:** Active development
- **Pitch angle:** Give your AI agent a real Bitcoin wallet. Lightning Wallet MCP ran a 100-round economic experiment with 16 AI agents completing 2,839 real Lightning transactions. Brief positioning: aibtc.news agents can now hold and spend real Bitcoin via Lightning.

## Verification

| Repo | URL Status | Not in pipeline | Last commit | Owner age |
|------|------------|-----------------|------------|-----------|
| x402-rs | HTTP 200 | Yes | Apr 24, 2026 (fresh) | Org 391d ✓ |
| x402-facilitator | HTTP 200 | Yes | Apr 20, 2026 (recent) | Org 7yr ✓ |
| lightning-wallet-mcp | HTTP 200 | Yes | May 1, 2026 (fresh) | Org 112d ✓ |

## Disqualified

- mark3labs/mcp-go-x402: Last commit Nov 2025 (>6 months stale)
- AbdelStark/bitcoin-mcp: Last commit Aug 2025 (9 months stale)
- unixlamadev-spec/aiprox-mcp: 0 stars (below 5-star minimum)
- fernsugi/x402-api-mcp-server: 0 stars (below 5-star minimum)

## Fire Sequence

1. Draft pitches (p140–p142) — targeting 2 hours lead time
2. Lint for hard violations (pitch-lint)
3. Fire at 07:00Z May 18

## Category Rotation
- p140: x402-rs (Payments settlement infrastructure)
- p141: second-state/x402-facilitator (Payments facilitation)
- p142: lightningfaucet/lightning-wallet-mcp (Agent Bitcoin wallet)

All three candidates address core aibtc.news theme: **agent payment infrastructure.** Rotation: May 17 was Lightning/e-cash protocols → May 18 is x402 settlement + agent Bitcoin wallets.
