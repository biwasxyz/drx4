# Code Reference: x402-nostr-relay Security Issues

## Issue H-1: Missing sBTC Asset ID Validation

### Vulnerable Code Block
**File**: `/src/x402.mjs`, lines 151-164

```javascript
151:    } else if (tx.tx_type === 'contract_call') {
152:      const events = tx.events || [];
153:      const transferToUs = events.find((event) =>
154:        (event.event_type === 'fungible_token_transfer' || event.event_type === 'fungible_token_asset') &&
155:        event.asset?.asset_event_type === 'transfer' &&
156:        event.asset?.recipient === PAY_TO
157:      );
158:      if (!transferToUs) {
159:        return { valid: false, error: 'No sBTC transfer to relay found in tx' };
160:      }
161:      paidAmount = parseAmount(transferToUs.asset?.amount);
162:      if (paidAmount == null) {
163:        return { valid: false, error: 'Invalid transfer amount' };
164:      }
```

### What's Missing
No validation of `transferToUs.asset.asset_id`. The code should verify it matches:
```
SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token
```

### sBTC Contract Definition
**File**: `/src/wallet.mjs`, lines 21-24

```javascript
20: // sBTC contract on mainnet
21: const SBTC_CONTRACT = {
22:   address: 'SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4',
23:   name: 'sbtc-token',
24: };
```

This constant should be exported and used in x402.mjs for validation.

---

## Issue H-2: Disconnected Replay Protection

### In-Memory Set (NOT PERSISTENT)
**File**: `/src/x402.mjs`, line 30

```javascript
29: /** Set of verified tx IDs to prevent replay */
30: const usedTxIds = new Set();
```

Reset on every server restart.

### Replay Check (IN-MEMORY ONLY)
**File**: `/src/x402.mjs`, lines 124-126

```javascript
123:  if (usedTxIds.has(normalizedTxId)) {
124:    return { valid: false, error: 'Transaction already used' };
125:  }
```

Never consults the database.

### Replay Record (IN-MEMORY ONLY)
**File**: `/src/x402.mjs`, line 173

```javascript
173:    usedTxIds.add(normalizedTxId);
```

Only adds to the ephemeral Set.

### Persistent Table (EXISTS BUT UNUSED FOR READING)
**File**: `/src/store.mjs`, lines 70-75

```javascript
70:      CREATE TABLE IF NOT EXISTS used_tx_ids (
71:        tx_id TEXT PRIMARY KEY,
72:        used_at INTEGER NOT NULL DEFAULT (unixepoch())
73:      );
```

Table created but never queried by verifyPayment().

### Persistent API Methods (DEFINED BUT NOT CALLED DURING VERIFICATION)
**File**: `/src/store.mjs`, lines 258-266

```javascript
258:  isUsedTx(txId) {
259:    if (!this.db) return false;
260:    return !!this.db.prepare('SELECT tx_id FROM used_tx_ids WHERE tx_id = ?').get(txId);
261:  }
262:
263:  markTxUsed(txId) {
264:    if (!this.db) return;
265:    this.db.prepare('INSERT OR IGNORE INTO used_tx_ids (tx_id) VALUES (?)').run(txId);
266:  }
```

These methods exist but are only called AFTER verification completes, not during.

### Usage in Main Handler
**File**: `/src/index.mjs`, lines 148-158

```javascript
148:    // Verify payment
149:    const totalPrice = getPrice(event);
150:    const verification = await verifyPayment(txId, totalPrice);
151:
152:    if (!verification.valid) {
153:      json(res, 402, { error: 'Payment verification failed', detail: verification.error });
154:      return;
155:    }
156:
157:    // Persist tx as used (SQLite)
158:    store.markTxUsed?.(txId);
```

The call to `store.markTxUsed()` at line 158 happens AFTER `verifyPayment()` returns. But `verifyPayment()` never checked the persistent store before approving the payment.

### Function Signature (NEEDS MODIFICATION)
**File**: `/src/x402.mjs`, line 118

```javascript
118: export async function verifyPayment(txId, requiredSats) {
```

Should become:
```javascript
export async function verifyPayment(txId, requiredSats, store) {
```

---

## Attack Scenario for H-2

1. Client sends txId `0x123abc...` with event
2. `verifyPayment('0x123abc...', 10)` called:
   - Line 124: Check in-memory set (not found, set is empty)
   - Line 173: Add to in-memory set
   - Return `{ valid: true }`
3. Server writes to DB: `store.markTxUsed('0x123abc...')`
4. **SERVER RESTARTS**
5. Client resends same txId `0x123abc...`
6. `verifyPayment('0x123abc...', 10)` called again:
   - Line 124: Check in-memory set (EMPTY AFTER RESTART)
   - Line 173: Add to in-memory set again
   - Return `{ valid: true }`
7. **SAME TRANSACTION IS ACCEPTED TWICE** - Double spend

The database has the record, but `verifyPayment()` never reads from it.

---

## Summary: What Needs to Change

### For H-1 (Asset ID Validation)
1. Export `SBTC_CONTRACT` from `wallet.mjs`
2. Import it in `x402.mjs`
3. Add this check after line 160 in `x402.mjs`:
   ```javascript
   const SBTC_ASSET_ID = `${SBTC_CONTRACT.address}.${SBTC_CONTRACT.name}`;
   if (transferToUs.asset?.asset_id !== SBTC_ASSET_ID) {
     return { valid: false, error: `Invalid asset: expected sBTC` };
   }
   ```

### For H-2 (Persistent Replay Protection)
1. Change `verifyPayment()` signature to accept `store` parameter
2. Line 124: Change from `usedTxIds.has()` to `store.isUsedTx()`
3. Line 173: Change from `usedTxIds.add()` to `store.markTxUsed()`
4. Line 30: Remove the `const usedTxIds = new Set();` declaration
5. In `index.mjs` line 150: Pass `store` as third argument
6. In `index.mjs` line 158: Remove the `store.markTxUsed(txId);` call (now in x402.mjs)

Both fixes are surgical and non-breaking.
