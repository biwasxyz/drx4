# Code Quality Audit — All Repos (Cycle 873)

**Date:** 2026-03-13
**Audited by:** Secret Mars (operator directive)
**Scope:** 6 repos across our codebase

---

## CRITICAL: DRY Violations — agent-bounties & ordinals-trade-ledger

**~500+ lines of identical code** duplicated between these two CF Workers repos:

| Shared Code | Lines | Files |
|---|---|---|
| CORS (resolveCorsOrigin, corsHeaders, json) | ~40 | Both index.ts |
| Input validation (isValidBtcAddress, isValidStxAddress, isValidTxHash) | ~25 | Both index.ts |
| Body size checking (readBodyWithSizeCheck) | ~20 | Both index.ts |
| D1 helper (dbRun) | ~6 | Both index.ts |
| BIP-137 full crypto stack (bitcoinMessageHash, bech32, base58, pubkey derivation, verifyBip137) | ~180 | Both index.ts |
| Signature replay protection (sha256Hex, recordSignatureUse, cleanupExpiredSignatures) | ~30 | Both index.ts |
| Rate limiting (checkRateLimit, cleanupExpiredRateLimits) | ~60 | Both index.ts |
| Security headers (withSecurityHeaders) | ~15 | Both index.ts |
| Agent upsert (ensureAgent) | ~15 | Both index.ts |

**Fix:** Extract shared library package (`@secret-mars/workers-common`) with:
- `lib/cors.ts` — CORS helpers
- `lib/validation.ts` — address/tx validators
- `lib/d1.ts` — D1 helpers
- `lib/bip137.ts` — BIP-137 signature verification
- `lib/bip322.ts` — BIP-322 (only in agent-bounties)
- `lib/rate-limit.ts` — IP rate limiting
- `lib/replay.ts` — Signature replay protection
- `lib/security.ts` — Security headers

---

## CRITICAL: Defensive Code — Silent Error Swallowing

### 1. [ordinals-trade-ledger/src/index.ts:980-982] Generic catch hides all errors
```ts
} catch (e: any) {
  return json({ error: 'Internal server error' }, 500, corsOrigin);
}
```
**Problem:** Catches ALL errors from the entire POST /api/trades handler and returns generic "Internal server error". Real error message is lost.
**Fix:** Return the actual error: `return json({ error: e.message }, 500, corsOrigin);`

### 2. [agent-bounties/src/index.ts:580-582] verifyAibtcAgent silently returns null
```ts
} catch {
  return null;
}
```
**Problem:** Any AIBTC API error (network, auth, 500) returns null. Caller treats null as "not registered" — **wrong data shown to user**.
**Fix:** Let the error propagate, or return a result object that distinguishes "not registered" from "API error": `{ registered: false }` vs `throw new Error(...)`.

### 3. [agent-news/src/lib/do-client.ts:29] All list functions use `?? []`
```ts
export async function listBeats(env: Env): Promise<Beat[]> {
  const result = await doFetch<Beat[]>(stub, "/beats");
  return result.data ?? [];  // ← hides DO errors
}
```
**Problem:** 9 functions in do-client.ts use `result.data ?? []`. If the DO returns `{ ok: false, error: "..." }`, callers get an empty array — **pretends success when there's an error**.
**Affected functions:** listBeats, listSignals, listBriefDates, listClassifieds, listCorrespondents, listStreaks, listInscriptions, listEarnings (8 total).
**Fix:** Check `result.ok` first, throw if false:
```ts
if (!result.ok) throw new Error(result.error ?? "DO request failed");
return result.data ?? [];
```

### 4. [agent-news/src/objects/news-do.ts:1478-1484] DO top-level catch
```ts
} catch {
  return new Response(
    JSON.stringify({ ok: false, error: "Internal error" }),
    { status: 500 }
  );
}
```
**Problem:** Hides all DO errors behind generic "Internal error".
**Fix:** Include the error message: `error: String(e)` or `error: e instanceof Error ? e.message : "Unknown error"`.

### 5. [agent-news/src/services/agent-resolver.ts:63-65] Silent catch on agent resolution
```ts
} catch {
  // Network error — don't cache, use fallback
}
```
**Problem:** Swallows network errors and falls through to fallback. If AIBTC API is down, all agent names silently disappear from the UI.
**Fix:** At minimum, log the error. Better: propagate it and let the route handler decide what to show.

### 6. [landing-page] Pervasive `catch { return null }` pattern
~40+ catch blocks across 20+ route files that return null on any error. Examples:
- `app/api/agents/[address]/route.ts:90-91` — catch { return null } on value parsing
- `app/api/agents/route.ts:147` — catch { return null } on claim data
- `app/api/leaderboard/route.ts:156-157` — catch { return null } on value parsing
- `app/api/claims/viral/route.ts:25-26` — catch { return null } on URL parsing
- `app/api/identity/[address]/reputation/route.ts:27-28` — catch { return null }

**Note:** This is the aibtcdev/landing-page repo (not ours), so we'd file issues/PRs, not fix directly.

---

## HIGH: Platform Anti-Patterns

### 1. [agent-bounties & ordinals-trade-ledger] Monolith single-file architecture
Both repos have ALL code in one `src/index.ts` file (2168 and 2730 lines respectively). This includes routing, auth, HTML templates, CSS, JavaScript, validation, crypto — all in one file.
**Fix:** Split into modules: `routes/`, `lib/`, `middleware/`, `templates/`.

### 2. [agent-news/src/objects/news-do.ts:697-702] Silent catch on optional body
```ts
try {
  body = await c.req.json<Record<string, unknown>>();
} catch {
  // Body is optional — use defaults
}
```
**Problem:** Catches ALL errors, not just "no body". A malformed JSON body is silently ignored instead of returning 400.
**Fix:** Distinguish between empty body and malformed JSON.

---

## MEDIUM: DRY Violations (agent-news)

### 1. JSON body parsing pattern repeated 14 times
```ts
let body: Record<string, unknown>;
try {
  body = await c.req.json<Record<string, unknown>>();
} catch {
  return c.json({ error: "Invalid JSON body" }, 400);
}
```
This exact block appears in: news-do.ts (10 times), routes/beats.ts (2), routes/classifieds.ts (1), routes/signals.ts (2), routes/brief-inscribe.ts (2), routes/brief-compile.ts (1).
**Fix:** Extract as Hono middleware: `app.use('/api/*', jsonBodyParser())` or a helper function.

---

## Good Patterns Found

- **agent-bounties & ordinals-trade-ledger:** Proper parameterized SQL queries everywhere (`.bind()`), no string concatenation. Good.
- **agent-bounties:** BIP-322 P2WPKH verification is correctly implemented using @scure/btc-signer.
- **agent-bounties:** Signature replay protection with time-bounded cleanup.
- **agent-news:** Clean separation of DO (data) and route (API) layers.
- **agent-news:** Proper Hono middleware for rate limiting and logging.
- **agent-news:** Type-safe DOResult<T> pattern for DO responses.
- **drx4-site:** Clean, minimal CF Worker. Proper nonce-based CSP. No defensive code.
- **ordinals-trade-ledger:** Atomic INSERT...WHERE NOT EXISTS for TOCTOU race prevention.
- **ordinals-trade-ledger:** On-chain watcher with batched agent rotation and proper error logging.

---

## Summary

| Repo | Critical | High | Medium | Overall |
|------|----------|------|--------|---------|
| agent-bounties | 1 (defensive catch) | 1 (monolith) | 0 | needs-work |
| ordinals-trade-ledger | 1 (defensive catch) | 1 (monolith) | 0 | needs-work |
| **Cross-repo DRY** | **1 (~500 lines duplicated)** | — | — | **poor** |
| agent-news | 2 (DO client ?? [], top-level catch) | 1 (silent optional body) | 1 (JSON parsing DRY) | needs-work |
| landing-page (aibtcdev) | 1 (pervasive null returns) | — | — | needs-work |
| drx4-site | 0 | 0 | 0 | good |
| loop-starter-kit | — (no source code, template only) | — | — | n/a |

**Top priority actions:**
1. Extract shared library from agent-bounties + ordinals-trade-ledger (~500 lines DRY fix)
2. Fix `?? []` pattern in agent-news do-client.ts (8 functions)
3. Fix generic catch blocks in ordinals-trade-ledger and agent-bounties
4. File issue on aibtcdev/landing-page for pervasive `catch { return null }` pattern
5. Revisit our PR #50 — the try/catch we added may align with this anti-pattern
