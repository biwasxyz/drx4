# Scout Report: cocoa007/x402-nostr-relay

## Overview
- **Repo**: https://github.com/cocoa007/x402-nostr-relay
- **Description**: Nostr relay with x402 sBTC payment gate for EVENT writes
- **Language**: JavaScript (Node.js)
- **Recent activity**: PR #4 merged 2026-03-01 (sungdark's security review)
- **Status**: Active, no open PRs or issues blocking these fixes

## Key Files
- `/src/x402.mjs` — Payment verification logic (lines 118-178)
- `/src/store.mjs` — SQLite store with replay protection table (lines 70-75, 258-266)
- `/src/wallet.mjs` — sBTC contract definition (lines 21-24)
- `/src/index.mjs` — HTTP request handler (lines 127-204)

---

## Finding H-1: Missing sBTC Asset ID Validation

### Status
**HIGH PRIORITY** — Currently unfixed. sungdark's merged PR #4 added documentation of this issue, not the fix.

### Location
**File**: `/tmp/x402-nostr-relay/src/x402.mjs`, lines 151-164

### Current Code (VULNERABLE)
```javascript
} else if (tx.tx_type === 'contract_call') {
  const events = tx.events || [];
  const transferToUs = events.find((event) =>
    (event.event_type === 'fungible_token_transfer' || event.event_type === 'fungible_token_asset') &&
    event.asset?.asset_event_type === 'transfer' &&
    event.asset?.recipient === PAY_TO
  );
  if (!transferToUs) {
    return { valid: false, error: 'No sBTC transfer to relay found in tx' };
  }
  paidAmount = parseAmount(transferToUs.asset?.amount);
  if (paidAmount == null) {
    return { valid: false, error: 'Invalid transfer amount' };
  }
```

### Problem
The `contract_call` verification path accepts **ANY SIP-010 token transfer** to `PAY_TO`, not just sBTC. An attacker could submit a contract call that transfers a worthless token to the relay address, and it would pass verification.

The code checks:
1. ✅ Event type is fungible token transfer
2. ✅ Event is a "transfer" 
3. ✅ Recipient is the relay address
4. ❌ **MISSING**: Does NOT verify `event.asset.asset_id` matches the expected sBTC contract

### Expected sBTC Contract
From `/src/wallet.mjs` line 21-24:
```javascript
const SBTC_CONTRACT = {
  address: 'SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4',
  name: 'sbtc-token',
};
```

### Stacks API Event Structure
When a token transfer occurs in a contract_call, the event object includes:
```javascript
{
  event_type: 'fungible_token_transfer',  // or 'fungible_token_asset'
  asset: {
    asset_id: 'SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token',  // Full identifier
    asset_event_type: 'transfer',
    amount: '10',
    recipient: 'SP3PME5Q8G3VJ7GAFBMNCRXJ28HFTBX74XZC70WZ7'
  }
}
```

### Required Fix
Add a check that verifies `event.asset.asset_id` equals the sBTC contract in the format:
`SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token`

Export the SBTC_CONTRACT constant from `wallet.mjs` and import it into `x402.mjs`, then validate:
```javascript
const EXPECTED_ASSET_ID = `${SBTC_CONTRACT.address}.${SBTC_CONTRACT.name}`;
if (transferToUs.asset?.asset_id !== EXPECTED_ASSET_ID) {
  return { valid: false, error: `Invalid asset: expected sBTC (${EXPECTED_ASSET_ID})` };
}
```

---

## Finding H-2: Replay Protection Doesn't Persist

### Status
**HIGH PRIORITY** — Currently unfixed. Same as H-1, sungdark's PR documented but didn't fix.

### Location
**File**: `/src/x402.mjs`, lines 29-30, 124-126, 173
**File**: `/src/store.mjs`, lines 70-75 (table definition), 258-266 (API methods)
**File**: `/src/index.mjs`, line 158 (usage)

### Current Code (VULNERABLE)

In **x402.mjs**:
```javascript
// Line 30: In-memory Set, reset on server restart
const usedTxIds = new Set();

// Lines 124-126: Checks only in-memory set
if (usedTxIds.has(normalizedTxId)) {
  return { valid: false, error: 'Transaction already used' };
}

// Line 173: Adds to in-memory set only
usedTxIds.add(normalizedTxId);
```

In **store.mjs** (defined but not used):
```javascript
// Lines 70-75: Table exists
CREATE TABLE IF NOT EXISTS used_tx_ids (
  tx_id TEXT PRIMARY KEY,
  used_at INTEGER NOT NULL DEFAULT (unixepoch())
);

// Lines 258-266: Methods exist but not called from verifyPayment()
isUsedTx(txId) {
  if (!this.db) return false;
  return !!this.db.prepare('SELECT tx_id FROM used_tx_ids WHERE tx_id = ?').get(txId);
}

markTxUsed(txId) {
  if (!this.db) return;
  this.db.prepare('INSERT OR IGNORE INTO used_tx_ids (tx_id) VALUES (?)').run(txId);
}
```

In **index.mjs** (only writes, never reads):
```javascript
// Line 158: Calls store.markTxUsed() only AFTER payment is verified
// But verifyPayment() never consulted the persistent store
store.markTxUsed?.(txId);
```

### Problem
1. **No persistent read**: `verifyPayment()` in `x402.mjs` only checks the in-memory `usedTxIds` Set
2. **Server restart clears memory**: When the server restarts, `usedTxIds` is empty
3. **Orphaned SQLite table**: The `used_tx_ids` table is written to by `index.mjs` after verification, but never read
4. **Replay window**: Between verification and writing to DB, and across restarts, old txIds can be reused

### Attack Scenario
1. Attacker submits event with valid sBTC payment `txId_ABC`
2. Server verifies it, accepts event, calls `store.markTxUsed('txId_ABC')`
3. Server restarts for any reason
4. Attacker submits same `txId_ABC` again
5. `verifyPayment()` checks only in-memory `usedTxIds` (empty) → **passes validation**
6. Event is accepted again → **replay successful**

### Required Fix
1. **Move all replay checks to store.mjs methods**: Modify `verifyPayment()` to call `store.isUsedTx()` before accepting
2. **Read from persistent store first**: Check SQLite before checking in-memory set
3. **Move the .add() call**: Don't add to in-memory set in `x402.mjs`, let store.mjs handle it
4. **Pass store instance**: `verifyPayment()` needs access to the EventStore instance

#### Modified Flow
```javascript
// In verifyPayment() — must accept store parameter
export async function verifyPayment(txId, requiredSats, store) {
  const normalizedTxId = normalizeTxId(txId);
  if (!normalizedTxId) {
    return { valid: false, error: 'Missing transaction ID' };
  }

  // Check persistent store first (handles both SQLite and in-memory fallback)
  if (store && store.isUsedTx(normalizedTxId)) {
    return { valid: false, error: 'Transaction already used' };
  }

  // ... rest of verification (fetch from Stacks API, validate amount, etc.)

  // On success, persist to store
  if (store) {
    store.markTxUsed(normalizedTxId);
  }
  
  return { valid: true };
}
```

And in **index.mjs** line 150:
```javascript
// Before:
const verification = await verifyPayment(txId, totalPrice);

// After:
const verification = await verifyPayment(txId, totalPrice, store);
```

This way:
- EventStore handles the dual-path logic (SQLite + in-memory fallback)
- Each request checks the persistent record first
- Restarts don't lose the replay protection history
- The orphaned in-memory Set is no longer used

---

## Summary Table

| Issue | Severity | File | Lines | Type | Fix Approach |
|-------|----------|------|-------|------|--------------|
| H-1: No sBTC asset validation | HIGH | x402.mjs | 151-164 | **Security Bug** | Add `asset_id` check in contract_call branch |
| H-2: In-memory replay protection | HIGH | x402.mjs + store.mjs | 29-30, 124-173, 258-266 | **Persistence Bug** | Route all checks through store.mjs, pass store to verifyPayment() |

Both issues were identified in sungdark's security review (PR #4, merged 2026-03-01), documented in `/SECURITY_REVIEW.md`, but not yet fixed.

---

## PR Strategy

### PR #1: H-1 Asset ID Validation
- **Title**: `fix: validate sBTC asset ID in contract_call payments`
- **Changes**:
  1. Export `SBTC_CONTRACT` from `wallet.mjs`
  2. Import in `x402.mjs`
  3. Add asset_id check in contract_call branch (line 157, after line 159 check)
  4. Add constant: `const EXPECTED_SBTC = 'SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token';`
  5. Add validation before amount parsing

### PR #2: H-2 Persistent Replay Protection
- **Title**: `fix: persist replay protection across server restarts`
- **Changes**:
  1. Add `store` parameter to `verifyPayment()` signature
  2. Move replay check from in-memory Set to `store.isUsedTx()`
  3. Call `store.markTxUsed()` inside `verifyPayment()` on success
  4. Remove the in-memory `usedTxIds` Set from x402.mjs (lines 29-30)
  5. Update `index.mjs` line 150 to pass `store` parameter
  6. Remove `store.markTxUsed()` call from index.mjs line 158 (now in x402.mjs)

Both PRs are non-breaking and align with the relay's SQLite persistence strategy.

