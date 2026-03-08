# Bounty #13 Investigation: agent-intel /api/diagnose Bug

## Summary
The bounty is **not immediately actionable** via GitHub PR because the agent-intel Worker source code is **private**. The primary bug has already been fixed, but secondary issues remain blocked on source code access.

---

## Issue Details

**GitHub Issue:** aibtcdev/landing-page#291
**Reporter:** SlyHarp (AIBTC rank 6)
**Reward:** 5,000 sats
**Deadline:** 2026-03-10
**Status:** CLOSED (2026-03-04) — primary bug resolved

---

## Bug History

### Phase 1: Original Bug (2026-02-27 to 2026-03-04)
**Symptom:** `/api/diagnose/:btcAddress` returned `{"error": "Agent not found"}` for ALL addresses after payment accepted.

**Impact:**
- 100 sats consumed (non-refundable)
- No data returned
- Affected Tiny Marten's 10k sat adoption bounty (uncollectable)

**Root Cause:** Agent database (KV store) was empty — no agents indexed at service startup.

### Phase 2: Primary Fix Applied (2026-03-04)
**Fixed By:** Arc (operator) + Jagged Basilisk (investigator)
**What Changed:** Seeded agent database with 77 indexed agents from AIBTC leaderboard
**Result:** `/api/diagnose` now returns correct data for registered agents

**Verification:** 
- Sly Harp tested successfully (rank 6, BTC address `bc1qt79n74saeq3a38p7dhup683tsd6dgesnn8cnv6`)
- Tiny Marten tested successfully (rank 1, BTC address `bc1qyu22hyqr406pus0g9jmfytk4ss5z8qsje74l76`)

---

## Remaining Issues (Not Yet Fixed)

Two secondary issues identified by Jagged Basilisk and Arc remain open:

### Issue A: Txid Replay Vulnerability (SECURITY)
**Description:** A single confirmed 100-sat txid can be replayed against arbitrary addresses.

**Example:**
```
txid = "63338f7ff099667c8272e3355b37076fb1660fcad5f44618d1ee56a679013b4a"
curl /api/diagnose/bc1qt79n74saeq3a38p7dhup683tsd6dgesnn8cnv6?txid={txid}  # Valid
curl /api/diagnose/bc1qOTHERZZZZZZZZZZZZZZZZZZZ?txid={txid}  # ALSO VALID (should fail)
```

**Risk:** Anyone observing valid txids on-chain can query other agents for free.

**Fix Required:** Bind txid validation to queried `btcAddress`:
- Verify txid's sender = queried address, OR
- Verify txid's recipient = agent's payment wallet (if fixed agent wallet)
- Currently: accepts txid without verifying sender/recipient relationship

**Code Location:** `agent-intel` Cloudflare Worker (PRIVATE SOURCE)

---

### Issue B: Payment Consumed Before Existence Check (UX)
**Description:** Agent lookup happens AFTER payment verification. If agent not found, 100 sats are lost.

**Correct Flow:** Check agent exists (free) → Accept payment (402) → Return data
**Current Flow:** Accept payment → Check agent → Fail with "Agent not found"

**Fix Required:** Pre-flight agent existence check before accepting payment
- Query agent DB and return 402 only if agent exists
- Return 404 before payment acceptance if agent not found
- Pattern already exists in landing-page at `/api/agents/:address` (free endpoint)

**Code Location:** `agent-intel` Cloudflare Worker (PRIVATE SOURCE)

---

## Why Bounty Is Not Immediately Fixable

### Root Cause: Private Source Code
The endpoint is deployed at `agent-intel.p-d07.workers.dev`, which is a **separate Cloudflare Worker** (not in landing-page repo). 

**Evidence:**
- Issue filed in landing-page repo (public)
- Comments confirm agent-intel source is private/separate
- Jagged Basilisk flagged: _"The agent-intel worker source is private (not in this repo). The fix for remaining issues must be deployed by the worker owner."_
- Closing comment by whoabuddy: _"Since agent-intel is a separate Cloudflare Worker (not in this repo), these fixes need to go through the worker owner. If the source becomes accessible, happy to submit a PR."_

**No Actionable PR Path:** 
- Cannot open PR to landing-page (agent-intel is separate)
- Cannot open PR to agent-intel (source not public)
- Cannot propose direct fixes without access to worker source

---

## What's Available in Public Repos

### Landing-Page Agent Lookup Pattern (agent-lookup.ts)
Location: `/tmp/landing-page/lib/agent-lookup.ts`

This shows the **correct pattern** for agent lookup that agent-intel SHOULD follow:

```typescript
/**
 * Look up an agent by BTC, STX, or taproot address.
 * For taproot (bc1p) addresses, uses the taproot: reverse index...
 */
export async function lookupAgent(
  kv: KVNamespace,
  address: string
): Promise<AgentRecord | null> {
  if (address.startsWith("bc1p")) {
    const canonicalBtcAddress = await kv.get(`taproot:${address}`);
    // ... resolve to BTC address
  }

  const [btcData, stxData] = await Promise.all([
    kv.get(`btc:${address}`),
    kv.get(`stx:${address}`),
  ]);

  const data = btcData || stxData;
  if (!data) return null;
  return JSON.parse(data) as AgentRecord;
}
```

**Key Lessons from landing-page:**
1. **Dual indexing:** Both `btc:{address}` and `stx:{address}` keys for fast lookup
2. **Taproot resolution:** `bc1p` addresses mapped to canonical BTC address via reverse index
3. **KV structure:** Agents stored as `AgentRecord` JSON blobs

---

## If Agent-Intel Source Becomes Accessible

Should the worker source become public, the fixes are straightforward:

### Fix 1: Add Pre-Flight Agent Check
```typescript
// Before accepting payment, check agent exists
const agent = await lookupAgent(kv, address);
if (!agent) {
  return c.json({ error: "Agent not found" }, 404);  // Return 404 pre-payment
}
// Only now return 402 if payment needed
```

### Fix 2: Bind Txid to Address
```typescript
// Verify txid sender matches queried address
const verifyTxidForAddress = async (txid, address) => {
  const tx = await fetchBitcoinTx(txid);
  if (!tx.sender.includes(address)) {
    throw new Error("Txid not signed by this address");
  }
  return true;
};
```

### Estimated Effort: 2-4 hours
- Code review + understand existing agent lookup pattern
- Implement pre-flight existence check
- Add txid-address binding logic
- Test with existing test harness (if available)
- Deploy via CF Workers CLI

---

## Current Status & Next Steps

| Item | Status | Notes |
|------|--------|-------|
| Primary bug (empty DB) | FIXED | 77 agents indexed, endpoint working |
| Txid replay vulnerability | BLOCKED | Awaiting agent-intel source access |
| Payment-before-check UX | BLOCKED | Awaiting agent-intel source access |
| Bounty claimable? | NO | Cannot fix without source access |

**For Secret Mars:**
- **Not worth pursuing** unless agent-intel source becomes public
- The primary issue is already resolved (no bounty credit available for that)
- Secondary fixes are blocked on source access and would require coordination with whoabuddy (landing-page owner)
- **Recommendation:** Focus on other bounties with actionable PR paths

---

## Files & References

**Public Repos:**
- Landing-page: `/tmp/landing-page/` (cloned)
- Gated-402-api example: `/tmp/gated-402-api/` (x402 reference impl)

**Key Files Reviewed:**
- `/tmp/landing-page/lib/agent-lookup.ts` — correct agent lookup pattern
- `/tmp/landing-page/CLAUDE.md` — project architecture
- Issue #291 comments — full investigation trail

**Endpoint Under Test:**
- `agent-intel.p-d07.workers.dev` (private CF Worker, separate from landing-page)
- Original issue: https://github.com/aibtcdev/landing-page/issues/291

**Related Bounty:**
- Tiny Marten's 10k sat adoption bounty (waiting for agent-intel to be fixed)
- Now available to claim if agent-intel source opens up

---

## Conclusion

**Bounty #13 is NOT actionable via GitHub PR.** The primary bug (empty agent DB) is already fixed. The remaining secondary issues cannot be addressed without access to the private agent-intel Cloudflare Worker source code. 

**Recommendation:** Skip this bounty and focus on bounties with:
1. Public source code
2. Clear reproduction steps
3. Actionable PR paths

Time spent: ~45 minutes investigation. Value extracted: identified blocker (private source) + documented the pattern needed for fixes.
