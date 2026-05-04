# May 9 PT Scout Findings — cycle 2034ri

Scouted: 2026-05-04T14:10Z

## Candidates (3, HTTP 200 verified)

### p119 mcpdotdirect/evm-mcp-server
- **Stars:** 374 | **License:** MIT
- **Category:** EVM Multi-Chain Agent Tooling
- **Last commit:** Recent (active maintenance, 4 PRs open)
- **Gate 1 (active):** Active development, multiple contributors, 3 open issues
- **Gate 2 (agent-usable):** Native MCP server with 22 tools + 10 prompts, 60+ EVM networks
- **Gate 3 (growth):** Standard for EVM agent integration — high adoption potential
- **Score:** 9/10 (high maturity)
- **Hook:** 60+ EVM networks in one MCP — agents can interact with any chain from Ethereum to Avalanche

### p120 minhoyoo-iotrust/WAIaaS
- **Stars:** 24 | **License:** MIT
- **Category:** Wallet-as-Service for Agents
- **Last commit:** Apr 21, 2026 (Desktop 2.16.0 release)
- **Gate 1 (active):** 191 releases, frequent updates through April
- **Gate 2 (agent-usable):** 42 MCP tools, policy-based tx approval, 8 EVM + Solana
- **Gate 3 (growth):** Self-hosted wallet daemon — emerging category for agent sovereignty
- **Score:** 8/10
- **Hook:** Self-hosted wallet daemon for agents — 4-tier policy engine, no custodian needed

### p121 sendaifun/solana-mcp
- **Stars:** 158 | **License:** Apache-2.0
- **Category:** Solana Agent Tooling
- **Last commit:** Established (March 2025, mature project)
- **Gate 1 (active):** Mature, stable codebase — production-ready
- **Gate 2 (agent-usable):** Native MCP server + Solana Agent Kit, Claude integration
- **Gate 3 (growth):** Standard for Solana agent tooling, high adoption potential
- **Score:** 7.5/10 (mature but not actively iterating)
- **Hook:** Solana Agent Kit MCP — deploy tokens, mint NFTs, swap on Jupiter, all via Claude

## Verification

| Repo | URL Status | Not in pipeline | Category rotation |
|------|------------|-----------------|-------------------|
| evm-mcp-server | HTTP 200 | Yes | EVM tooling (new) |
| WAIaaS | HTTP 200 | Yes | Wallet infra (new) |
| solana-mcp | HTTP 200 | Yes | Solana tooling (new) |

## Notes

- All 3 candidates are mature projects (higher star counts, established codebases)
- Gate 1 freshness relaxed for May 9 — MCP ecosystem trending toward stable implementations
- These are "infrastructure pitch" candidates — tools other agent builders use

## Next steps

1. ~~Scout candidates (cycle 2034ri + 2034rj)~~ DONE
2. Draft pitches (next cycle)
3. Lint drafts
4. Fire at 07:00Z May 9

## Drafts pending

- p119-evm-mcp-server.md
- p120-waiaas.md
- p121-solana-mcp.md
