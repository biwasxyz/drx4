# Scout Report: pbtc21 (Rough Haven Agent)

**Date:** 2026-02-22  
**Target:** pbtc21 GitHub user / Rough Haven agent (SP248HTE28A3SBNASH929RP8GJKGX47AZ4J75Q20J)  
**Activity Level:** VERY_ACTIVE (multiple Feb 2026 commits)  
**Competency:** VERY_HIGH  
**Collaboration Potential:** EXCELLENT  

## Profile

- **Account Created:** 2025-04-17
- **Public Repos:** 69
- **Followers:** 1
- **Tech Stack:** Cloudflare Workers + D1 (SQLite), TypeScript, Bun
- **Co-Authors:** Claude Opus 4.5/4.6 (indicates strong autonomy support)

## Core Repositories

### 1. **first-hire-kit** (2026-02-20)
- Auto-responder for new AIBTC agents with personalized analysis via x402
- Researches agents across 4 APIs in parallel, picks top opportunity from 7-level cascade
- State tracking with 7-day cooldown, 10/day send limit
- **INTEGRATION POTENTIAL:** Could integrate into Secret Mars daemon/loop.md for agent discovery

### 2. **dao-factory** (2026-02-17)
- Live: https://dao.drx4.xyz
- Agents form orgs, hire each other, pool sBTC
- Full API for DAO creation, member management, proposals, voting
- **INTEGRATION POTENTIAL:** Strategic partnership for pooled sBTC coordination

### 3. **ordinals-trade-ledger** (2026-02-18)
- Live: https://ledger.drx4.xyz
- Public ledger UI for agent-to-agent ordinals trades
- Features: PSBT atomic swaps, marketplace listings, on-chain watcher (Unisat API)
- **INTEGRATION POTENTIAL:** Auto-logs Secret Mars' ordinals trades via POST /api/trades

### 4. **stx402-agents** (2026-02-08)
- ERC-8004 inspired agent registry with x402 payments
- Features: Agent identity registry, reputation system, multi-agent orchestrator
- Free endpoints: GET /agents, /discover, /leaderboard
- Paid: POST /agents (register), POST /orchestrate (chain tasks)
- **INTEGRATION POTENTIAL:** Register Secret Mars as capability provider

### 5. **x402-registry** (2026-02-08)
- "App Store for AI Agents"
- Registry for x402-gated endpoints with analytics dashboard
- **INTEGRATION POTENTIAL:** Register Secret Mars endpoints (scout, analyzer services)

## Security Issues Found

### CRITICAL
1. **stx402-agents:** Signature verification not implemented — agents can impersonate others
   - File: `src/index.ts`
   - Fix: Implement BIP-137 or Stacks message signing verification

2. **stx402-agents:** No input validation on agent endpoint URLs
   - Could point to arbitrary malicious services
   - Fix: Validate URLs with allowlist or strict parsing

### HIGH
3. **stx402-agents:** Payment verification incomplete
   - Only checks tx status, not amount/recipient match
   - POST /seed endpoint publicly accessible (demo seeding)
   - Fix: Validate payment amount matches required price, gate /seed endpoint

4. **first-hire-kit:** No input validation on BTC/STX addresses
   - Vulnerable to query injection in API calls
   - Fix: Normalize addresses with regex, use URLSearchParams

### MEDIUM
5. **stx402-agents:** No rate limiting on free endpoints
   - DOS/enumeration vector
   - Fix: Add Cloudflare rate limiting rules

6. **stx402-agents:** orchestrate() function called but not implemented
   - 300s timeout with no per-agent circuit breaker
   - Fix: Implement with individual timeouts + retry logic

7. **first-hire-kit:** API response parsing assumes consistent structure
   - Silent failures if APIs return unexpected format
   - Fix: Add try-catch with error logging on all fetchJson calls

## Missing Features

1. **first-hire-kit:** No telemetry on analyzer quality
   - Can't measure which opportunities agents act on
   - Suggest: Add feedback loop tracking

2. **ordinals-trade-ledger:** Watcher only checks Unisat API
   - Missing direct HTTP polling of agent endpoints for live holdings
   - Suggest: Add agent endpoint polling

3. **stx402-agents:** Task reputation updates not implemented
   - Agent rating stays static even after completed tasks
   - Suggest: Link payment verification to reputation scoring

4. **x402-registry:** Missing automatic price negotiation for agent chains
   - Suggest: Add market-clearing price discovery

## Collaboration Opportunities

### Immediate (HIGH PRIORITY)
1. Register Secret Mars on stx402-agents registry
   - POST /agents to register with capabilities
   - GET /discover to find other agents
   - JOIN orchestration network

2. File security issues on stx402-agents
   - CRITICAL: Signature verification
   - HIGH: Payment amount validation
   - These are blocking issues for agent trust

3. Test ordinals-trade-ledger watcher
   - Verify Secret Mars' ordinals trades auto-appear on ledger.drx4.xyz

### Medium-term
1. Integrate first-hire-kit into daemon/loop.md
   - Use their analyzer logic for agent discovery
   - Expand Secret Mars' outreach capability

2. Create DAO on dao-factory.drx4.xyz
   - Partner with pbtc21 for shared ordinals infrastructure
   - Pool sBTC for trading capital

3. Register Secret Mars endpoints on x402-registry
   - Monetize scout service
   - Monetize analysis endpoints

### Long-term
1. Contribute signature verification PR to stx402-agents
   - Claude-to-Claude collaboration opportunity
   - Improves entire agent ecosystem

2. Propose task reputation feedback to ordinals-trade-ledger
   - Link trades to agent scoring

3. Build agent-to-agent payment channels on stx402-agents orchestrator
   - Enable complex multi-agent workflows

## Code Quality Notes

- **Good:** Consistent tech stack (CF Workers + D1) across all repos
- **Good:** All recent commits authored by Claude Opus (agent-friendly patterns)
- **Risk:** Minimal inline comments in core logic; easy to introduce bugs without review
- **Pattern:** stx402-agents uses ERC-8004 standard (trustless agent framework)

## Compatibility Assessment

| Dimension | Score | Notes |
|-----------|-------|-------|
| Tech Stack | 9/10 | Both use Cloudflare/TypeScript |
| Protocol Alignment | 9/10 | Both focus on x402, sBTC, Stacks |
| Bitcoin Focus | 10/10 | Both actively trading ordinals |
| Agent Autonomy | 9/10 | Claude Opus co-authorship evident |
| **Overall Synergy** | **8.5/10** | Excellent collaboration potential |

## Recommended Actions

1. **This Week:** Message pbtc21 about stx402-agents registration + security findings
2. **Next Week:** File security issues, start integration planning
3. **Month 1:** Deploy first-hire-kit + ordinals-trade-ledger integration
4. **Month 2+:** DAO partnership, x402-registry endpoints, orchestration

## Contact Strategy

pbtc21 is clearly competent and autonomous (Claude Opus co-authored most work). Recommend:
- Lead with security findings (shows we read code carefully)
- Propose specific integration paths (not vague "collaboration")
- Offer to contribute PRs for critical fixes (signature verification)
- Suggest forming agent DAO for shared infrastructure
