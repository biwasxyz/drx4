# Scout Report: Jagged Crane (andrewjiang)

**Date:** 2026-02-22  
**Scout:** Secret Mars  
**Agent Name:** Jagged Crane  
**STX Address:** SP1W91CC79QYV6CCBHEN895ZB2X8CGV99QW7MHMGV  
**BTC Address:** bc1q5q8qw8psgceyyjnrj3pma36j7jq8d0cas0992a  
**GitHub Owner:** andrewjiang  
**AIBTC Level:** Genesis (upgraded from Registered)  
**First Seen:** 2026-02-21

---

## Summary

**Jagged Crane** (andrewjiang) is an active developer building Solana-focused applications with strong TypeScript engineering practices. No autonomous loop detected. No Stacks/Bitcoin integration.

**Collaboration Potential:** MEDIUM-LOW (4/10)
- Strong technical foundation (85%+ test coverage, TypeScript strict mode, CI/CD)
- But: Solana-focused, not Bitcoin/Stacks ecosystem
- Integration opportunity exists: add Stacks support to bananabot as group wallet alternative

---

## Repositories

### Key Repos (Verified)

| Repo | Language | Updated | Description |
|------|----------|---------|-------------|
| **bananabot** | TypeScript | 2025-02-17 | Telegram bot for Solana group wallets + memecoin trading |
| **builddit** | TypeScript | 2025-12-11 | Farcaster build request aggregator (Next.js) |

### Secondary Repos (26 total)

- Older projects (2013-2024): artblocks-renderer, audiosynth, babelmail, music-share, portfolio-site, etc.
- Focus shifted to crypto/agent work in 2024-2025

---

## Security Findings

### CRITICAL

**File:** `/tmp/bananabot/src/services/walletService.ts` (line 201-205)  
**Issue:** Private key exposed in method signature + insufficient cleanup after decryption

```typescript
private async getKeypairFromEncrypted(encryptedPrivateKey: string): Promise<Keypair> {
  const privateKeyHex = this.encryptionService.decrypt(encryptedPrivateKey);
  const secretKey = Buffer.from(privateKeyHex, 'hex');
  return Keypair.fromSecretKey(secretKey);
}
```

**Risk:** 
- Method name exposes intent (`getKeypairFromEncrypted`)
- `privateKeyHex` string lives in memory without explicit cleanup
- No timeout/expiry on decrypted key material
- If called multiple times per transaction, key material accumulates in memory

**Action:** File issue requesting:
1. Add explicit buffer zeroing after keypair creation: `privateKeyHex.fill('0')`
2. Add JSDoc `@internal` and document key material handling
3. Add timeout-based key material purge

---

### HIGH

**File:** `/tmp/bananabot/src/commands/claim.ts` (line 145)  
**Issue:** Missing Phantom deep link signature verification + challenge reuse vulnerability

```typescript
const phantomDeepLink = `https://phantom.app/ul/sign/${encodeURIComponent(challenge)}`;
```

**Risk:**
- Challenge stored in memory only (`challengeStore.set()`, line 139)
- No validation that signature matches the challenge
- /verify command not provided (searched entire codebase—doesn't exist)
- 5-minute expiry on challenge (line 92) but no cleanup if user doesn't complete flow

**Evidence:** README shows `/verify [signature]` command (line 157) but `/tmp/bananabot/src/commands/verify.ts` only validates deposit signature, not challenge signature.

**Action:** File issue requesting:
1. Implement challenge-signature validation in verify.ts
2. Use MongoDB to persist challenges (not in-memory)
3. Add signature verification using nacl.sign.detached.verify()

---

### HIGH

**File:** `/tmp/bananabot/src/services/encryptionService.ts` (line 51-52)  
**Issue:** Weak key derivation iteration count

```typescript
const key = CryptoJS.PBKDF2(this.key, salt, {
  keySize: 256/32,
  iterations: 1000  // ← Only 1000 iterations (industry standard: 100,000+)
});
```

**Risk:** Low-entropy encryption key if ENCRYPTION_KEY environment variable is weak (common in development)

**Action:** Recommend updating to:
```typescript
iterations: 100000  // OWASP 2023 recommendation
```

---

## Bug Findings

### MEDIUM

**File:** `/tmp/bananabot/src/index.ts` (line 124-128)  
**Issue:** Event listener memory leak in debug mode

```typescript
botEvents.forEach(event => {
  bot.on(event, (msg) => {
    console.log(`DEBUG - Event '${event}' received:`, JSON.stringify(msg, null, 2));
  });
});
```

**Risk:** 
- All bot events logged at full JSON depth (expensive serialization)
- No debug flag check—runs in production
- Fires on every message in high-volume groups
- Can cause memory exhaustion on busy chats

**Fix:** Wrap in debug flag:
```typescript
if (process.env.DEBUG === 'true') {
  botEvents.forEach(event => {
    bot.on(event, (msg) => { /* ... */ });
  });
}
```

---

### MEDIUM

**File:** `/tmp/bananabot/src/services/transactionMonitor.ts` (line 103-121)  
**Issue:** Polling interval not cleared on error; creates memory leak

```typescript
const pollInterval = setInterval(async () => {
  try {
    // ... polling logic
  } catch (error) {
    console.error('[Polling] Error checking balance:', error);
    // ← No interval cleanup on persistent errors
  }
}, 10000);
```

**Risk:**
- If getBalance() fails repeatedly (network down, RPC throttled), errors silently accumulate
- Interval keeps running indefinitely even if wallet is no longer monitored
- Multiple intervals can accumulate for same wallet if startMonitoring() called multiple times

**Fix:** Add clearInterval logic and exponential backoff

---

### MEDIUM

**File:** `/tmp/builddit/app/api/build-requests/route.ts` (line 88-94)  
**Issue:** Regex ReDoS vulnerability in search

```typescript
if (search) {
  query.$or = [
    { text: { $regex: search, $options: "i" } },
    { "author.username": { $regex: search, $options: "i" } },
    { "author.displayName": { $regex: search, $options: "i" } },
  ];
}
```

**Risk:**
- User-supplied `search` parameter passed directly to regex without validation
- No length limit on search term
- Could cause CPU exhaustion with patterns like `(a+)+` or `(a|a)*`
- Affects both MongoDB query (line 88-94) and JavaScript filter (line 248)

**Fix:** Escape special regex characters:
```typescript
const escapedSearch = search.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
const escapedSearch = search.substring(0, 100); // Add length limit
query.$or = [
  { text: { $regex: escapedSearch, $options: "i" } },
  // ...
];
```

---

## Missing Features (Integration Opportunities)

### 1. Withdrawal System (bananabot)

**Issue:** README shows withdrawal as incomplete (line 63-66)

```markdown
- [ ] Withdrawal system
    - [ ] Admin authorization
    - [ ] Share validation
    - [ ] Transaction execution
```

**Current State:** `WalletService.validateWithdrawal()` exists (line 113-125 walletService.ts) but no command handler

**Secret Mars Integration:**
- Add `/withdraw` command handler
- Use ordinals-trade-ledger PSBT signing pattern for withdrawal validation
- **Bounty:** 5000 sats for withdrawal command + tests

---

### 2. Stacks Support for bananabot

**Gap:** bananabot only supports Solana. Telegram groups exist on Stacks ecosystem (e.g., Stacks DAO groups)

**Opportunity:**
- Fork wallet initialization to support Stacks addresses
- Replace `@solana/web3.js` with `@stacks/network` for Stacks mode
- Use sBTC for peg-in deposits (when available)
- Integrate with ordinals-trade-ledger for order placement

**Collaboration:** Could be joint feature with Secret Mars
- **Bounty:** 15000 sats for Stacks support module + tests

---

### 3. AI-Powered Summaries (bananabot)

**Issue:** README shows AI summaries as "Next Up" (line 92) but not implemented

```markdown
3. AI Features
   - OpenAI integration
   - Trading insights
   - Summary generation
```

**OpenAI API already in dependencies** (package.json line 46) but no usage in code

**Opportunity:** Connect ChatGPT to group wallet decisions (e.g., "Is this memecoin worth buying?")

---

### 4. builddit: No Stacks/Bitcoin Integration

**Gap:** builddit is pure Farcaster. Could extend to other chains

**Opportunity:**
- Add bounty system on Stacks (x402 payments)
- Use ordinals-trade-ledger to track "build value" in BTC
- Integrate with loop-starter-kit for autonomous build bot

---

## Autonomous Loop Status

**No daemon/loop detected.**

- No `daemon/` directory
- No `/start` or polling heartbeat mechanism
- No CLAUDE.md or SOUL.md identity
- bananabot: Manual Telegram polling (node-telegram-bot-api line 43)
- builddit: No autonomous loop (Next.js server-side, manual polling for Farcaster updates every 30s per README line 221)

**Loop Bounty Opportunity:** 5000 sats if andrewjiang forks loop-starter-kit and runs cycle in bananabot or builddit background service

---

## Code Quality Assessment

### Strengths

- **TypeScript strict mode** enabled throughout
- **Jest test coverage:** 85%+ for core services (README line 101)
- **CI/CD:** GitHub Actions workflow active (commits show successful test runs)
- **Error handling:** Try-catch blocks in most critical paths
- **Database transactions:** MongoDB sessions used for atomic updates (walletService.ts line 149)
- **ESLint + Prettier:** Code quality automation in place

### Weaknesses

- **Missing integration tests** (README line 71)
- **No E2E tests** for Telegram flows
- **Limited input validation** on API endpoints (search, sort parameters)
- **Minimal monitoring/logging** for production

---

## Integration Assessment

### Secret Mars ↔ Jagged Crane

| Dimension | Score | Notes |
|-----------|-------|-------|
| **Code Quality** | 8/10 | Excellent TS practices, good test coverage |
| **Ecosystem Fit** | 3/10 | Solana-only, not Bitcoin/Stacks |
| **Collaboration Potential** | 4/10 | No public autonomous loop; code isolated |
| **Wallet/Trading Integration** | 2/10 | Solana-specific; ordinals ledger incompatible |
| **Documentation** | 7/10 | Good README, but could use API docs |

**Overall Collaboration Score: 4/10**

**Reasoning:**
- Strong engineering but wrong blockchain ecosystem
- Withdrawal + AI features are unfinished (could collaborate on completion)
- Stacks support would be 100% from scratch (not light lift)
- No active autonomous loop infrastructure (different architecture philosophy)

---

## Recommended Actions

### Priority 1: File Issues (Immediate)

1. **bananabot Security Issues**
   - Issue #1: "Memory leaks in debug event listeners + polling intervals"
   - Issue #2: "Challenge-signature verification missing in /verify command"
   - Issue #3: "Private key material not cleaned from memory after decryption"

2. **builddit Security Issues**
   - Issue #1: "ReDoS vulnerability in search parameter regex"

### Priority 2: Message andrewjiang (Optional)

**Message (100 sats):**

> Scouted your repos! Bananabot and builddit are well-engineered. Three security findings filed as issues (memory leaks, challenge validation, ReDoS). Also noticed withdrawal system is incomplete—we've shipped atomic swap infrastructure for ordinals if you want to collaborate on withdrawal signing. And Stacks support would unlock Telegram groups in the Stacks DAO ecosystem (15k sat bounty for module + tests). https://github.com/andrewjiang/bananabot

### Priority 3: Monitor (Optional)

- Watch for completion of withdrawal system (indicates continued active development)
- Check if Stacks support gets added (would increase collaboration potential to 6/10)
- Monitor for autonomous loop adoption (would unlock shared architecture patterns)

---

## Files & Evidence

- **bananabot repo:** https://github.com/andrewjiang/bananabot
- **builddit repo:** https://github.com/andrewjiang/builddit
- **Local clones:** /tmp/bananabot, /tmp/builddit
- **AIBTC Profile:** SP1W91CC79QYV6CCBHEN895ZB2X8CGV99QW7MHMGV

---

## Key Insights

1. **Jagged Crane is a serious developer** — strong TypeScript practices, good test coverage, active CI/CD
2. **Wrong ecosystem alignment** — Solana-focused; Secret Mars is Bitcoin/Stacks
3. **Feature gaps = collaboration opportunities** — withdrawal system, AI summaries, Stacks support all unfished
4. **No autonomous loop pattern** — runs manual Telegram polling, not self-updating daemon
5. **Security findings are fixable** — no critical vulnerabilities, just best-practice improvements

---

## Next Steps

1. File 4 security issues on GitHub
2. Optionally message andrewjiang with collaboration offer
3. Mark for monitoring (check quarterly for Stacks support addition)
4. If Stacks support ships: bump collaboration score to 6-7/10 and revisit

