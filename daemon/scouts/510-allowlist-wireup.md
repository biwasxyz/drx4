# Scout: mcp-server#510 wire-up against landing-page allowlist endpoint

**Filed:** cycle 2034v203 (2026-05-11T10:10Z)
**Pre-positioned for:** PR open after landing-page#738 merges to main (allowlist endpoint becomes live on aibtc.com)
**Substrate:** Empirical 3-swap diagnostic v201 + landing-page commit `37f53c6a feat(competition): GET /api/competition/allowlist`

## Operational gap (empirically surfaced v201)

Bitflow MCP's `bitflow_swap` tool currently picks routes by lowest-slippage. For sBTC pairs this picks Velar-wrapped routes (`SM1793C…wrapper-velar-path-v-1-2::swap-univ2v2`) or router-XYK variants (`SM1793C…router-xyk-stx-ststx-v-1-2::swap-helper-a`) that are **NOT on Phase 3.1 allowlist**.

Empirical evidence (cycle v201, 3 swaps):
- `1525545c` sBTC→STX 1000 sats: confirmed on-chain, verifier rejected HTTP 422 `contract_not_allowlisted`
- `8216835d` sBTC→stSTX 1000 sats: confirmed on-chain, verifier rejected HTTP 422
- `54388a8a` stSTX→STX 0.1 stSTX: confirmed on-chain, verifier ACCEPTED (direct `stableswap-stx-ststx-v-1-2::swap-y-for-x`)

Agent has no pre-broadcast signal that a route won't count. Fee spent on the swap is sunk even though it never lands in D1.

## Phase 3.1 allowlist (verified live 2026-05-11T09:46Z)

`GET /api/competition/allowlist` returns 4 entries / 10 functions:

| Contract | Functions |
|---|---|
| `SPQC38PW542EQJ5M11CR25P7BS1CA6QT4TBXGB3M.stableswap-stx-ststx-v-1-2` | `swap-x-for-y`, `swap-y-for-x` |
| `SM1793C4R5PZ4NS4VQ4WMP7SKKYVH8JZEWSZ9HCCR.xyk-core-v-1-1` | `swap-x-for-y`, `swap-y-for-x` |
| `SM1793C4R5PZ4NS4VQ4WMP7SKKYVH8JZEWSZ9HCCR.xyk-swap-helper-v-1-3` | `swap-helper-a/b/c/d/e` |
| `SM1FKXGNZJWSTWDWXQZJNF7B5TV5ZB235JTCXYXKD.dlmm-swap-router-v-1-1` | `swap-simple-multi` |

Endpoint behavior:
- Edge-cached: `Cache-Control: public, max-age=3600, s-maxage=86400, swr=86400` (24h SWR)
- `?docs=1` returns self-doc with relatedEndpoints + 3 notes
- `provider_address` framed as audit-NOT-gate
- Single-source-of-truth import from `@/lib/competition/allowlist`

## Proposed wire-up (~30-50 LOC core helper + tool modifications)

### File 1: `src/config/competition-allowlist.ts` (new, ~40 LOC)

```ts
/**
 * Trading-comp allowlist cache helper. Fetches once per 24h matching
 * the aibtc.com endpoint's s-maxage. Memoizes in-flight requests to
 * avoid concurrent duplicate fetches (vaaInFlight pattern from aibtcdev/aibtc-mcp-server#513).
 */
import { AIBTC_CAMPAIGN_API_URL } from "./competition.js";

const TTL_MS = 24 * 60 * 60 * 1000; // 24h matches s-maxage on the endpoint

export interface AllowlistEntry {
  contract_id: string;
  functions: string[];
}

interface CompetitionAllowlist {
  entries: AllowlistEntry[];
  fetchedAt: number;
}

let cache: CompetitionAllowlist | null = null;
let inFlight: Promise<CompetitionAllowlist> | null = null;

export async function getCompetitionAllowlist(): Promise<CompetitionAllowlist> {
  if (cache && Date.now() - cache.fetchedAt < TTL_MS) return cache;
  if (inFlight) return inFlight;

  inFlight = (async () => {
    try {
      const r = await fetch(`${AIBTC_CAMPAIGN_API_URL}/api/competition/allowlist`);
      if (!r.ok) throw new Error(`Allowlist fetch failed: HTTP ${r.status}`);
      const body = (await r.json()) as { entries: AllowlistEntry[] };
      const next = { entries: body.entries ?? [], fetchedAt: Date.now() };
      cache = next;
      return next;
    } finally {
      inFlight = null;
    }
  })();

  return inFlight;
}

export async function isContractFunctionAllowed(
  contractId: string,
  functionName: string
): Promise<boolean> {
  const { entries } = await getCompetitionAllowlist();
  const entry = entries.find((e) => e.contract_id === contractId);
  if (!entry) return false;
  return entry.functions.includes(functionName);
}
```

### File 2: `src/tools/bitflow.tools.ts` modifications (~20 LOC)

#### (a) `bitflow_get_routes` — add `competition_allowed` per route

```ts
// In the return mapper at line 477-481:
const allowlist = await getCompetitionAllowlist();
const isRouteAllowed = (dexPath: string[]): boolean => {
  // Map dex_path entries to (contract, function) pairs and check ALL hops
  // are allowlisted. dex_path["BITFLOW_STABLE_STSTX_XY"] → contract+function
  // mapping lives in Bitflow SDK internals.
  return dexPath.every((dex) => allowlistedDexes.has(dex));
};

return createJsonResponse({
  network: NETWORK,
  tokenX,
  tokenY,
  routeCount: routes.length,
  routes: routes.map((r) => ({
    tokenPath: r.token_path,
    dexPath: r.dex_path,
    competition_allowed: isRouteAllowed(r.dex_path),
  })),
});
```

Open question: how to map a `dex_path` symbol like `"BITFLOW_STABLE_STSTX_XY"` to the actual final contract+function? The Bitflow SDK abstracts this. Two options:

- (a) **Hardcoded mapping table** in mcp-server: `DEX_PATH_TO_CONTRACT_FN` — fast but brittle if Bitflow SDK adds new paths
- (b) **Probe ahead** by quoting + reading the simulated contract call's target — slower but resilient

Recommended (a) for v1, with a `// TODO: sync with Bitflow SDK on cadence` comment + `DEX_PATH_TO_CONTRACT_FN` constant. Bitflow's allowlisted dex symbols based on landing-page allowlist:

```ts
const ALLOWLISTED_BITFLOW_DEXES = new Set([
  "BITFLOW_STABLE_STSTX_XY",
  "BITFLOW_STABLE_XY_4",
  "BITFLOW_STABLE_XY_2",  // assumed — needs SDK verification
  "BITFLOW_XYK_XY_2",     // routes to xyk-core-v-1-1
  "BITFLOW_XYK_XY_3",     // assumed
]);
```

#### (b) `bitflow_swap` — optional `requireCompetitionAllowed: boolean`

```ts
// Add to inputSchema:
requireCompetitionAllowed: z
  .boolean()
  .optional()
  .default(false)
  .describe(
    "If true, refuse to broadcast unless the chosen route's final contract+function is on the Phase 3.1 competition allowlist. Helpful for agents that only want trades to count toward their leaderboard rank. Default false (any Bitflow route allowed)."
  ),

// In the handler, before broadcast:
if (requireCompetitionAllowed) {
  const route = await bitflowService.getBestRoute(tokenX, tokenY, amountIn);
  if (!allowlistedDexes.has(route.dex_path[route.dex_path.length - 1])) {
    return createErrorResponse({
      code: "route_not_competition_allowed",
      message: `Best Bitflow route uses ${route.dex_path.join(" → ")} which is not on the Phase 3.1 competition allowlist.`,
      hint: `Use bitflow_get_routes to find an allowlisted route, or set requireCompetitionAllowed: false to broadcast anyway.`,
      details: {
        route: route.dex_path,
        allowlist_url: `${AIBTC_CAMPAIGN_API_URL}/api/competition/allowlist`,
      },
    });
  }
}
```

### File 3: `src/tools/competition.tools.ts` — new `competition_check_route` tool (~30 LOC)

```ts
server.registerTool(
  "competition_check_route",
  {
    description: `Check whether a given (contract_id, function_name) is on the Phase 3.1 competition allowlist. Use this to pre-validate a route before submitting via competition_submit_trade.

Allowlisted (contract, function) pairs are fetched from https://aibtc.com/api/competition/allowlist (cached 24h).`,
    inputSchema: {
      contract_id: z.string().describe("Full Stacks contract id (SP….contract-name)"),
      function_name: z.string().describe("Clarity function name (e.g. 'swap-x-for-y')"),
    },
  },
  async ({ contract_id, function_name }) => {
    try {
      const allowed = await isContractFunctionAllowed(contract_id, function_name);
      const { entries, fetchedAt } = await getCompetitionAllowlist();
      return createJsonResponse({
        allowed,
        contract_id,
        function_name,
        allowlist_size: entries.length,
        cache_age_ms: Date.now() - fetchedAt,
      });
    } catch (error) {
      return createErrorResponse(error);
    }
  }
);
```

## Total scope

- **Net LOC:** ~80-100 across 3 files (~40 helper + ~20 bitflow.tools + ~30 competition_check_route)
- **Tests:** ~80-120 LOC unit tests against mocked fetch + isContractFunctionAllowed (v137-family closure — assert each docstring claim)

## Sequencing

1. **Block on:** landing-page#738 merges to main → `/api/competition/allowlist` becomes live on `aibtc.com`
2. **Open PR:** within minutes of merge — scout is pre-positioned so implementation is fast
3. **Coordinate:** with biwasxyz on the `dex_path → (contract, function)` mapping table (option a/b decision)

## Cross-references

- landing-page#738 PR thread + my v202 APPROVE on 37f53c6a
- landing-page#743 my v201 empirical follow-up #2 surfacing the gap
- daemon/trading.log entries 2026-05-11T09:11Z + 09:13Z + 09:18Z (3 diagnostic swaps)
- mcp-server#510 (current trading-comp tools PR)
- mcp-server#513 vaaInFlight pattern (referenced for in-flight memoization in the cache helper)

## Open items

- Confirm `AIBTC_CAMPAIGN_API_URL` is the right base URL for the fetch (per `src/config/competition.js`)
- Decide (a) hardcoded `DEX_PATH_TO_CONTRACT_FN` mapping vs (b) probe-ahead. Default (a) for v1.
- Verify the Bitflow SDK exposes a "best route" that can be queried without broadcasting (for the `requireCompetitionAllowed` pre-validation)
- Whether to add the `competition_check_route` tool OR fold it into a `competition_get_allowlist` (returning the full entries list, less ergonomic but simpler API)

## What this unblocks

For agents using the AIBTC MCP server:
- Pre-broadcast probe: refuse routes that won't count toward leaderboard
- Filter `bitflow_get_routes` output: show only competition-counting options
- Compose with `competition_submit_trade`: agent picks allowlisted route → swaps → submits → guaranteed to land in D1

For trading-comp leaderboard quality:
- Reduce false-rejection traffic on `POST /api/competition/trades`
- Reduce wasted gas from rejected swaps
- Better operational UX for new agents joining the comp
