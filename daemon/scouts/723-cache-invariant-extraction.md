# landing-page#723 cache-invariant extraction — scout draft (pre-positioned cycle 2034v168, 2026-05-10T22:23Z)

**Scope:** Extract the 3 cache-key invariants currently duplicated in 3 places into a single canonical doc + 1-line pointer comments + structural enforcement test. Per whoabuddy's #725 stated preference: "file #723 PR first so the 4-route × 3-place duplication never materializes."

**Author status:** Offered v167 (#725 issuecomment-4416477893). Defers to whoabuddy's call on who ships; scout content is reusable as review reference if a different author takes it.

## Current state (instance 1 + 2; instance 3+4+5+6 about to materialize)

3 places hold the same invariant prose today (post-#722 merge):
1. `app/api/inbox/[address]/route.ts` — ~40-line inline block in GET handler
2. `lib/inbox/d1-reads.ts` — file header (~30 lines)
3. (PR body of #722 — historical, won't proliferate)

Steps 3.2, 3.3, 3.4 each add 1-2 more inline blocks per route × invariant if no extraction happens first → up to 4-route × 3-place = 12 instances.

## Proposed scope (matches whoabuddy's #723 issue body)

### File 1: `lib/inbox/CACHE_INVARIANTS.md` (new — canonical source)

Single doc holding the full Invariant 1+2+3 prose. Structure:

```markdown
# Inbox/Outbox Cache-Key Invariants

> Canonical source for the 3 cache-key invariants applied to `/api/inbox/*`
> and `/api/outbox/*` routes during the Phase 2.5 cutover series. Referenced
> by 1-line pointer comments in each route file + d1-reads.ts.
>
> History: surfaced via #697 umbrella body; first codified in-code on #722
> (Step 3.1); extracted to single source via #723 (this doc) to prevent
> 4-route × 3-place duplication drift.

## Invariant 1 — Auth'd vs public branch separation

Routes that have BOTH a public branch (no auth required) AND an auth'd
branch (caller proves ownership of `[address]` via BIP-322 / SIP-018)
MUST use one of:

  (a) **Cache-key exclusion**: auth'd branch is excluded from any
      shared cache layer (e.g., `Cache-Control: private, no-store`
      headers + skip CF cache layer entirely).
  (b) **Verified-address-hash suffix**: auth'd branch's cache key
      includes a hash of the verified caller address so a public
      caller cannot receive an auth'd cached response.

The current state of routes flipped to D1 (#722) is **public-only**;
both invariants are satisfied by construction. When an auth'd branch
is added in a future PR, this invariant MUST be checked.

## Invariant 2 — Auth'd branch must set `Cache-Control: private, no-store`

If a route has an auth'd branch, that branch MUST set
`Cache-Control: private, no-store` to prevent any intermediate cache
(browser, CDN, reverse proxy) from storing the response. This complements
Invariant 1's cache-key separation: even if the cache key is unique,
storing the response in a shared cache is unsafe if the response contains
per-user data.

Routes currently public-only do not set this header; that is correct.

## Invariant 3 — Pre-gate cache safety

Never serve a cache HIT before the BIP-322 / SIP-018 auth gate runs.
This prevents the `agent-news#802` unauthenticated-HIT bug class: a
public caller's first request populates a cache entry for an address;
a subsequent (still public) caller for the same address receives a
cached response that bypassed the auth gate, leaking content that
should only be visible to the verified caller.

Mitigation: any cache lookup MUST be gated by `if (authVerified) {
  return cachedResponse;
}` — the auth gate runs first, then the cache lookup, then the response.

## Cross-references

- agent-news#802 — historical incident this invariant family prevents
- aibtcdev/landing-page#697 — umbrella where invariants were ratified
- aibtcdev/landing-page#722 — first codified-in-code (route + d1-reads.ts)
- aibtcdev/landing-page#723 — extraction to this single source

## Structural enforcement

`lib/inbox/__tests__/cache-invariants-enforcement.test.ts` reads each
route file in `app/api/inbox/[address]/...` and asserts that any
auth/session-related import (e.g., `verifyBitcoinSignature`,
`BIP_322`, `SIP_018`, `getServerSession`) co-occurs with a
`Cache-Control: private` string in the same file. Brittle but cheap;
catches the agent-news#802 bug class shape via lint-rather-than-runtime.
```

### File 2: 1-line pointer in `app/api/inbox/[address]/route.ts`

Replace the ~40-line inline block in the GET handler with:

```ts
  // ── Phase 2.5 Step 3.1: D1 read flip ──────────────────────────────────────
  // The GET /api/inbox/[address] list path now reads from D1 instead of KV.
  // KV writes (POST handler) are NOT removed in this PR — that is Step 4.
  //
  // Cache-key invariants: see lib/inbox/CACHE_INVARIANTS.md
  //   (auth'd-branch separation / private-no-store / pre-gate cache safety)
```

### File 3: 1-line pointer in `lib/inbox/d1-reads.ts` file header

Replace the ~30-line invariant block at the top with:

```ts
/**
 * D1 read helpers for GET /api/inbox/[address] and sibling routes.
 *
 * Cache-key invariants: see lib/inbox/CACHE_INVARIANTS.md
 *   (auth'd-branch separation / private-no-store / pre-gate cache safety)
 *
 * History: ... (rest of the existing file-purpose docstring)
 */
```

### File 4: `lib/inbox/__tests__/cache-invariants-enforcement.test.ts` (new)

```ts
/**
 * Structural enforcement of cache-key invariants from CACHE_INVARIANTS.md.
 *
 * Catches the agent-news#802 bug class shape via lint-rather-than-runtime:
 * if a route file adds an auth-related import (verifyBitcoinSignature,
 * BIP_322, SIP_018, getServerSession), it MUST also include a
 * "Cache-Control: private" string somewhere in the same file.
 *
 * Brittle: depends on import naming conventions + string-matching, not
 * AST analysis. Cheap to maintain: ~30 LOC, ~50ms test runtime.
 */

import { describe, it, expect } from "vitest";
import { readFileSync } from "fs";
import { join } from "path";

const AUTH_IMPORT_PATTERNS = [
  /import\s+.*verifyBitcoinSignature/,
  /import\s+.*BIP[_-]322/,
  /import\s+.*SIP[_-]018/,
  /import\s+.*getServerSession/,
  /import\s+.*requireAuth/,
];

const CACHE_CONTROL_PRIVATE_PATTERNS = [
  /Cache-Control['"\s:]+private/,
  /['"]Cache-Control['"]\s*:\s*['"]private/,
];

function hasAuthImport(content: string): boolean {
  return AUTH_IMPORT_PATTERNS.some(p => p.test(content));
}

function hasCacheControlPrivate(content: string): boolean {
  return CACHE_CONTROL_PRIVATE_PATTERNS.some(p => p.test(content));
}

const INBOX_ROUTE_FILES = [
  "app/api/inbox/[address]/route.ts",
  "app/api/inbox/[address]/[messageId]/route.ts",
  "app/api/outbox/[address]/route.ts",
];

describe("CACHE_INVARIANTS structural enforcement", () => {
  for (const relPath of INBOX_ROUTE_FILES) {
    it(`${relPath}: auth-import + Cache-Control: private must co-occur`, () => {
      const fullPath = join(process.cwd(), relPath);
      let content: string;
      try {
        content = readFileSync(fullPath, "utf-8");
      } catch {
        // File doesn't exist yet (e.g., Step 3.x not landed) — skip
        return;
      }
      const hasAuth = hasAuthImport(content);
      const hasPrivate = hasCacheControlPrivate(content);
      if (hasAuth) {
        expect(hasPrivate, `${relPath} imports auth helpers but does not set Cache-Control: private (Invariant 2 violation; see lib/inbox/CACHE_INVARIANTS.md)`).toBe(true);
      }
    });
  }
});
```

## PR description (draft)

```markdown
## Summary

Extracts the 3 cache-key invariants from #697 umbrella body into a
single canonical source (`lib/inbox/CACHE_INVARIANTS.md`) + 1-line
pointer comments in 2 existing places + structural enforcement test.

Surfaced via @steel-yeti's Cycle 26 advisory + @secret-mars's elevation
on #722; filed as #723 by @whoabuddy. Authored by [me / whoever].

## Changes

- **NEW** `lib/inbox/CACHE_INVARIANTS.md` — canonical 3-invariant prose
  with agent-news#802 cross-reference + history note
- **EDIT** `app/api/inbox/[address]/route.ts` — replace ~40-line inline
  block (GET handler region) with 4-line pointer comment
- **EDIT** `lib/inbox/d1-reads.ts` — replace ~30-line invariant block
  in file header with 4-line pointer comment
- **NEW** `lib/inbox/__tests__/cache-invariants-enforcement.test.ts` —
  ~30 LOC structural test asserting auth-import + Cache-Control: private
  co-occur in route files (catches agent-news#802 bug class via lint)

Net diff: ~+100 LOC / -70 LOC after the swap.

## Why this matters before Step 3.2

Step 3.2 (#725) is queued. Without #723 first, Step 3.2's `app/api/inbox/
[address]/[messageId]/route.ts` adds instance 3 of the 3-invariant
inline block. Then Step 3.3 adds instance 4. Then Step 3.4 adds 1-2
more in lib helpers. The duplication compounds to ~12 places of the
same prose across 4 route files + lib helpers — comment-drift risk
materializes within hours.

Landing #723 first means Steps 3.2/3.3/3.4 ship with 1-line pointers
from the start. Steel-yeti's Cycle 26 advisory framed this as "comment-
as-future-spec that decay"; the structural test gives the invariants
active enforcement that pure comments can't.

## Test plan

- [ ] `npm test` passes; `cache-invariants-enforcement.test.ts` runs
  cleanly against current route files (no Invariant 2 violations)
- [ ] `npx tsc --noEmit` shows no errors
- [ ] Manual: import a fake auth helper into one of the route files
  WITHOUT adding Cache-Control: private → test fails as expected
  → revert
- [ ] Manual: verify the 1-line pointer comments still reference the
  doc by file path (catch typos in path)

## References

- Umbrella: #697
- Step 3.1 first codified-in-code: #722
- Step 3.2 spec (waiting on this): #725
- Surfaced by: @steel-yeti's Cycle 26 advisory + @secret-mars's
  elevation v162

Closes #723.
```

## Estimated work

- ~30-45 min focused work for the full PR
- Most effort is in CACHE_INVARIANTS.md prose (the 3 sections + history)
- Structural test ~10 LOC + skips for non-existent files
- 1-line pointer edits are mechanical

## Trigger conditions for shipping vs deferring

- **Ship**: whoabuddy explicitly ACKs my v167 authoring offer ("yes please") OR Step 3.2 PR is about to open with full inline block (instance 4 materializing)
- **Defer**: arc or whoabuddy says they'll author, OR Step 3.2 PR ships first with full inline block (then #723 catches up to deduplicate after)
- **Convert to review-prep**: if a different author opens the PR, my scout content becomes review reference for their version
