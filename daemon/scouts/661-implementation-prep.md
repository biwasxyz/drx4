# landing-page#661 Phase 0.6 — implementation prep

**Status:** Claimed v62. Blocked on #662 (Phase 0.3) merge for the `RATE_LIMIT_MUTATING` binding wrangler config.
**Captured:** 2026-05-08T21:55Z (cycle 2034v63), pre-implementation.

## Acceptance criteria (from #661)

1. PATCH handler IP-rate-limited via `ratelimits` binding before `verifyBitcoinSignature`.
2. Spoofed `address` path-param (or any client-controlled value) cannot bypass IP bucket — IP key is the only key.
3. Test: garbage-signature spam from one IP gets clipped at the bucket limit; legit recipient marking through 30+ messages within the window doesn't hit the limit.
4. `npm run lint` + `npm test` + `npm run build` (or CI) green.
5. Post-merge ~1h smoke window — confirm new 429 path doesn't fire on normal recipient traffic.

## Pattern from #662 (binding call shape)

Cutover pattern across `outbox/[address]/route.ts` and `inbox/[address]/route.ts`:

```ts
let xLimited = false;
try {
  const result = await env.RATE_LIMIT_MUTATING.limit({
    key: `<scope>:${value}`,
  });
  xLimited = !result.success;
} catch (err) {
  // Two paths from #662:
  //   - Inbox revenue surface (sender, txid-recovery): fail OPEN so valid payments aren't blocked
  //   - Outbox abuse-probe surface (validation, unregistered): fail CLOSED in production
  const isProduction = process.env.NODE_ENV === "production";
  logger.warn("<label> rate limit binding error", {
    error: String(err),
    failClosed: isProduction,
  });
  if (isProduction) xLimited = true;
}
if (xLimited) {
  return new Response(
    JSON.stringify({ error: "Too many requests." }),
    { status: 429, headers: { "Retry-After": "60", "Content-Type": "application/json" } }
  );
}
```

## Mark-read fail-closed decision

PATCH /api/inbox/[address]/[messageId] is NOT a revenue surface (no x402 payment). It's an abuse-protection path against signature-verification DoS. Using **fail-closed-in-production** (matching the outbox abuse paths in #662) is correct:

- If the binding errors out → blocking attacker is the priority over legit users seeing transient mark-read errors.
- The legit-user impact is minor (retry on next mark-read attempt; no revenue lost; no message data lost).
- The attacker impact is meaningful (CPU-exhaustion DoS on `verifyBitcoinSignature`).

## Key extraction

Need IP from `request`. Pattern likely uses Cloudflare's `cf-connecting-ip` header or Next's `request.headers.get("x-forwarded-for")`. Will confirm via `app/api/outbox/[address]/route.ts` once #662 lands on `main`. Tracking as a TODO; the actual `extractIp(request)` helper or inline extraction will be visible in the merged source.

## Limit key

Per #661 issue body suggestion: `inbox-mark-read:` (route name as scope prefix). With `:${ip}` appended.

```ts
key: `inbox-mark-read:${ip}`,
```

## Limit decision (per my v62 claim comment)

Default to existing `RATE_LIMIT_MUTATING` (20/60s) over a dedicated 30/60s binding. Rationale captured in v62 claim. Will switch on whoabuddy preference if flagged before PR opens.

## Test plan sketch

**Test file location:** `app/api/inbox/[address]/[messageId]/__tests__/rate-limit.test.ts` (mirror outbox test layout from #662).

**Tests:**
1. **IP bucket limit hit → 429 returned, verifyBitcoinSignature NOT called.** Mock binding to return `{ success: false }`; assert 429 status; assert mock signature-verify wasn't invoked (the whole point — the rate-limit must run BEFORE verify).
2. **IP bucket limit not hit → flow proceeds to verify.** Mock `{ success: true }`; assert signature-verify mock IS invoked.
3. **Spoofed address path-param doesn't bypass IP bucket.** Two requests with different addresses but same IP → both consume the same `inbox-mark-read:${ip}` bucket.
4. **Binding error in production → fail-closed (429).** Set NODE_ENV=production, throw from binding; assert 429.
5. **Binding error in dev/staging → fail-open (proceeds to verify).** Set NODE_ENV=development; throw from binding; assert verify-mock IS invoked.
6. **(Optional) Recipient marking through backlog stays under cap.** 20 successive valid PATCHes from same IP all return success (within window).

Mock shape: `simulateMarkReadRateLimit` helper (mirror #662's `simulateOutboxRateLimitChecks`) — testing the binding-call ordering directly. NOT calling the real `PATCH` handler with full crypto verification mocks; keep tests narrow to the rate-limit gate.

## Code shape preview

```ts
// app/api/inbox/[address]/[messageId]/route.ts PATCH handler
// (top of function, BEFORE the existing body)

const ip = extractIp(request); // helper TBD or inline

let ipLimited = false;
try {
  const result = await env.RATE_LIMIT_MUTATING.limit({
    key: `inbox-mark-read:${ip}`,
  });
  ipLimited = !result.success;
} catch (err) {
  // Mark-read is abuse-protection (not revenue) — fail-closed in production.
  const isProduction = process.env.NODE_ENV === "production";
  logger.warn("Mark-read rate limit binding error", {
    error: String(err),
    failClosed: isProduction,
  });
  if (isProduction) ipLimited = true;
}
if (ipLimited) {
  return new Response(
    JSON.stringify({ error: "Too many requests." }),
    { status: 429, headers: { "Retry-After": "60", "Content-Type": "application/json" } }
  );
}

// existing PATCH body continues from here:
// const { address, messageId } = await params;
// ...verifyBitcoinSignature only runs after IP gate passes
```

Estimate: ~25 LOC source + ~80-100 LOC test.

## Sequencing reminder

Do NOT open #661 until #662 is merged + on `main`. The `RATE_LIMIT_MUTATING` binding type in `cloudflare-env.d.ts` and the wrangler config land in #662. Opening #661 against pre-#662 main would fail TypeScript build.
