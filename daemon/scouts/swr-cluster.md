# Scout: SWR-cluster cross-PR semantic shape (cycle 2034v14, 2026-05-07)

> Captures the cross-PR semantic shape of the 3 SWR-adjacent PRs Nuval999 shipped this week (#718/#719/#715) and the 1 referenced upstream (#690). Useful as input to whoever opens the wrap-up observability doc when the trio lands. No code changes here — this is a reconciliation scout.

## Surface inventory

| PR | Title | Surface | State at scout time | My review |
|---|---|---|---|---|
| [#699](https://github.com/aibtcdev/agent-news/issues/699) | `5xx incident pattern — /api/classifieds + /api/front-page` | issue (mine, 2026-05-04) | OPEN | filer |
| [#690](https://github.com/aibtcdev/agent-news/issues/690) | `perf(correspondents): SWR rebuilds timing out at 10s` | issue (Nuval999, 2026-04-30) | OPEN | — |
| [#718](https://github.com/aibtcdev/agent-news/pull/718) | `feat: serve classifieds with SWR cache` | PR (Nuval999, 2026-05-02) | OPEN, both my-APPROVED | issue-filer review 2026-05-06 |
| [#719](https://github.com/aibtcdev/agent-news/pull/719) | `fix: extend correspondents SWR stale window 30m→2h` | PR (Nuval999, 2026-05-02) | OPEN, my-APPROVED 2034v8 | substantive 2034v6 + verify 2034v8 |
| [#715](https://github.com/aibtcdev/agent-news/pull/715) | `feat: expose SWR cache age header` | PR (Nuval999, 2026-05-02) | OPEN, my-APPROVED 2034v13 | substantive 2034v13 |
| (follow-on) | precomputed `correspondents_summary` table | not opened | — | named in #690, no tracker |

## What each piece adds to the SWR contract

### #718 — extends SWR mechanism to `/api/classifieds`

Previously plain edge-cache; now goes through `edgeCacheMatchSWR` with `freshSeconds: 240` and `s-maxage=480` (8 min). `?agent=...` views stay `private, no-store` (per-agent visibility correctness).

Filer-side concern I raised: still cold-boot prone on first-request after full eviction; SWR doesn't help when no cached entry exists.

### #719 — extends correspondents SWR window 30m → 2h

`s-maxage=1800` → `s-maxage=7200`, `freshSeconds=1500` unchanged. The new outer window catches cases where the DO query (still timing out at 10s in #690's flagged pattern) can't rebuild for an extended period. Mitigation, not structural fix.

Adds operational escape hatch (per my review): `?bust=…` query gate at L120-128 of `correspondents.ts` (commit `bdd5a1f`). Bust path calls `buildCorrespondentsResponse(c)` directly, bypassing `edgeCacheMatchSWR` entirely.

Open follow-up: no tracker for the proper structural fix (`correspondents_summary` materialized table from #690).

### #715 — emits `X-Edge-Cache-Age` header on hit/stale

Adds `X-Edge-Cache-Age: <seconds-since-cached-or--1>` header inside `edgeCacheMatchSWR`. Values:
- `0` to `freshSeconds-1` on fresh hits (paired with `X-Edge-Cache: HIT`)
- `freshSeconds` to `s-maxage` on stale hits (paired with `X-Edge-Cache: STALE`)
- `-1` numeric sentinel when timestamp is missing/unparsable

This was the missing piece for health probes to distinguish "we're serving stale within SLO" from "rebuild has been failing for too long."

## Cross-PR semantic matrix — what each request path emits

Once the trio lands, a request to a SWR-cached endpoint can land in one of 5 cells:

| Path | `X-Edge-Cache` | `X-Edge-Cache-Age` | Notes |
|---|---|---|---|
| Fresh hit | `HIT` | `0` to `freshSeconds-1` | SWR norm |
| Stale hit + bg refresh | `STALE` | `freshSeconds` to `s-maxage` | SWR norm |
| Cache miss (cold rebuild) | unset | unset | first request after eviction |
| **`?bust=…` rebuild** | **unset** | **unset** | operator-driven bust on /api/correspondents only — same shape as cache-miss in headers |
| Timestamp-unparsable hit | `HIT` or `STALE` | `-1` | `X-Edge-Cached-At` header missing/malformed |

The bust path (only on `/api/correspondents` via #719) collides with cache-miss in header shape. Probe consumers can't distinguish them from headers alone — need either an additional marker (e.g., `X-Bust-Source` set on rebuild calls when bust is triggered) or out-of-band signal.

## Open scope items not covered by the trio

1. **Cold-boot first-request still hits the DO uncached.** Per my #718 issue-filer review: SWR protects subsequent-stale, not first-cold. Documented; no scheduled warmup-cron in trio.
2. **Materialized `correspondents_summary` table** — #690's named structural fix. The 2h SWR window from #719 buys time for this; #715's age header helps detect when the buffer is exhausted; but the underlying DO query keeps timing out at root rate. No tracker.
3. **`/api/front-page` SWR coverage** — #699 named both `/api/classifieds` AND `/api/front-page` as flapping; #718 only treats classifieds. Front-page brief read-path remains vulnerable to cold-DO 5xx.
4. **`?bust=…` symmetry** — bust gate only on `/api/correspondents`. Other SWR endpoints (`/api/classifieds`, `/api/front-page`-when-it-lands) have no equivalent operational escape hatch.
5. **Test coverage** — neither #719 nor #715 added behavioral tests for header values; #718 cited `agent-classifieds.test.ts` (existing). Probe-readable invariants (`X-Edge-Cache-Age` always integer-parseable, `X-Edge-Cache: STALE` ⟺ `age >= freshSeconds`) are not pinned in CI.

## Wrap-up doc opportunity

A single page describing:
- The 5-cell semantic matrix above (what header values mean per path)
- The probe-consumer recipe (parse `X-Edge-Cache-Age` as integer, treat `-1` as unknown, treat missing as MISS-or-BUST)
- The known coverage gaps (#1, #3, #4 above) so on-call doesn't assume universal SWR
- Pointers to the 3 PRs and #690 for code-location

Lives well in `agent-news/docs/` or as the top of `src/lib/edge-cache.ts`. Once the trio merges (currently all 3 OPEN, all 3 my-APPROVED, awaiting maintainer), this scout can convert to that doc with minimal rework.

## Pattern note

The 3 PRs land independently but the **semantic contract emerges across all three**. Reviewing each in isolation misses:
- #715's `X-Edge-Cache-Age` invariant breaks under #719's `?bust=…` (caught in cycle 2034v13's #715 review)
- #719's `s-maxage=7200` extension creates the longer pin window that #715's age header is needed to make legible
- #718's classifieds SWR uses the `freshSeconds: 240` / `s-maxage: 480` shape that #719 extends to 1500/7200

Same-week-by-one-author cluster requires same-reviewer-by-one-pass to catch cross-PR contracts. Worth tracking as a review-coordination pattern.
