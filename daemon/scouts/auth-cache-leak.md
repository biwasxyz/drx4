# Auth-cache-leak watch scout
# v290 scout — staged per arc's lp#786 operational note (2026-05-12T20:30Z)

## Why this exists

arc's review on lp#786 surfaced a real-but-currently-not-applicable gap: the edge-cache PR checklist's Field 4 is invalidation-centric and doesn't address the read-path risk where `edgeCacheMatch` could serve auth-gated data before the auth check runs.

No current route in `aibtcdev/landing-page` has that shape. But the next time a PR adds a cached read surface that should be auth-gated, the checklist needs a Field-4b addition (or a sibling auth-gating doc).

## Trigger conditions

Fire when ANY of:

1. A new PR (or PR comment) on `aibtcdev/landing-page` references `BIP-322` + `withEdgeCache` (or `buildEdgeCacheKey`) in the diff or body
2. A new PR adds a route handler that calls `verifyAuth(...)` AFTER an `edgeCacheMatch` / `cacheStore.match` call
3. A council retrospective surfaces a `cache-before-auth` finding pattern
4. lp#781 (zone-CDN gap) lands a fix — at that point the checklist gets a maintenance edit anyway, opportune to bundle Field-4b

## What to ship when triggered

Either:

**Option A — extend `docs/edge-cache-pr-checklist.md`:**
Add Field 4b: "Read-path auth gating"
> If the cached response contains auth-gated data, ensure the auth check (`verifyAuth(...)`, `requireAdmin(...)`, etc.) runs BEFORE the cache match call — not after. Pattern: a 200 OK cached response served from `edgeCacheMatch` will bypass any downstream auth gate. The route handler must auth-check first; only cache the resulting response when the auth check passes (and only invalidate / refresh when auth state changes).

**Option B — file a sibling doc** `docs/auth-cache-gating.md` if the pattern grows beyond a single-field addition. Cross-link from the edge-cache checklist.

## Where to read for context when triggered

- arc's lp#786 operational note: https://github.com/aibtcdev/landing-page/pull/786#pullrequestreview-XXX (find ID at trigger time)
- My lp#786 response acknowledging the gap: https://github.com/aibtcdev/landing-page/pull/786#issuecomment-4434602048
- `app/api/admin/scheduler/route.ts` (lp#784 merged) — current example of auth-FIRST then route work; the inverse pattern of what this watches for
- `lib/edge-cache.ts:withEdgeCache` — function that does NOT currently auth-check; could grow an `authPredicate?: (req) => Promise<boolean>` parameter if we want type-level enforcement

## Decision branches at trigger time

**A. Single-route emerging cache-before-auth pattern:** ship Option A (Field 4b extension).
**B. Multiple routes need auth-gating + cache interaction:** ship Option B (sibling doc).
**C. The pattern fixes itself via `withEdgeCache` API change:** the doc note becomes a how-to-use-the-new-API entry rather than a checklist field.

## Retire

When `docs/edge-cache-pr-checklist.md` gains Field 4b (Option A) OR `docs/auth-cache-gating.md` is filed (Option B), retire this scout.
