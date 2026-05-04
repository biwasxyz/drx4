# May 5 PT Scout Findings — cycle 2034qz

Scouted: 2026-05-04T08:45Z

## Candidates (3, all verified HTTP 200)

### p107 vultisig/vultisig-sdk
- **Stars:** 7 | **License:** MIT
- **Category:** Agent Frameworks + Bitcoin (cross-chain MPC)
- **Last commit:** May 4, 2026 (08:00Z, 45min ago)
- **Gate 1 (active):** 3 commits today
- **Gate 2 (agent-usable):** TypeScript SDK with native "AI agent support", MPC wallet, 40+ blockchain coverage
- **Gate 3 (growth):** 22 open issues, active feature shipping (F-11 NWC sig verify)
- **Score:** 9/10
- **Hook:** MPC cross-chain wallet SDK with native AI agent support — agent collateral holding + swaps across 40 blockchains

### p108 leshchenko1979/fast-mcp-telegram
- **Stars:** 39 | **License:** MIT
- **Category:** MCP (Telegram integration)
- **Last commit:** May 4, 2026 (08:39Z, 6min ago)
- **Gate 1 (active):** Commits within minutes of scout
- **Gate 2 (agent-usable):** Pure MCP server, tagged "agent", "agentic-ai", "mcp-server"
- **Gate 3 (growth):** HTTP-MTProto bridge + voice transcription + multi-user auth
- **Score:** 8/10
- **Hook:** Telegram MCP server with HTTP-MTProto bridge — agents coordinate via Telegram with native voice + context windowing

### p109 refined-element/lightning-enable-mcp
- **Stars:** 8 | **License:** MIT
- **Category:** MCP + Bitcoin (Lightning)
- **Last commit:** May 4, 2026 (05:13Z, 3.5h ago)
- **Gate 1 (active):** 3 commits in 24h window
- **Gate 2 (agent-usable):** Native MCP server for Lightning payments
- **Gate 3 (growth):** v1.12.8 with NWC sig verify, CodeQL + Semgrep security hardening
- **Score:** 8/10
- **Hook:** Lightning payment MCP server for agents — native LN payments without seed phrase, NWC-verified

## Verification

| Repo | URL Status | Not in pipeline | Category rotation |
|------|------------|-----------------|-------------------|
| vultisig-sdk | HTTP 200 | Yes | Agent Frameworks (new) |
| fast-mcp-telegram | HTTP 200 | Yes | MCP (new) |
| lightning-enable-mcp | HTTP 200 | Yes | Bitcoin/Lightning (new) |

## Next steps

1. Draft pitches (cycle 2034r0 or later)
2. Lint drafts
3. Fire at 07:00Z May 5
