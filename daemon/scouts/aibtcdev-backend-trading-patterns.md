# Scout: aibtcdev-backend trading-comp patterns — what's reusable, what's better in landing-page

**Filed:** cycle 2034v210 (2026-05-11T13:30Z)
**Source:** Operator Telegram 13:27Z — "For trading comp see if there's anything we can take from aibtcdev-backend"
**Repo state:** **ARCHIVED** ("This project has been retired"), 58k+ LOC Python FastAPI backend, last updated 2026-04-07
**Repo URL:** https://github.com/aibtcdev/aibtcdev-backend

## TL;DR — 4 patterns reusable, 2 things landing-page does cleaner

### Worth lifting / referencing

1. **`stacks_chainhook_adapter` library** (`app/services/processing/stacks_chainhook_adapter/`) — Python library that "transforms Stacks API data into Chainhook-compatible format, enabling seamless migration from Hiro Chainhooks to direct Stacks API polling." Battle-tested chainhook payload generator from raw Stacks API responses.
2. **Asset ID stripping convention** — `asset_identifier.split("::")[0]` to get contract_id from SIP-10 asset id (`buy_event_handler.py:186`). Same pattern as `volume.ts:toTeneroAddress`. Validates as industry-standard, not landing-page-specific.
3. **`lottery_utils.py` Decimal-precise quorum math** — `Decimal(liquid_tokens) * Decimal(str(quorum_percentage))` with `quantize(Decimal("1"), rounding=ROUND_UP)`. Closes my v183 "18-decimal token Score-track-SUM-overflow" concern: leaderboard scoring SUM/composite-score work should use BigInt/Decimal to avoid float precision loss.
4. **Buy/Sell event handler separation pattern** — `BuyEventHandler` + `SellEventHandler` + `STXEventHandler` are three specialized handlers (`app/services/integrations/webhooks/chainhook/handlers/`) for three event-shape families. Useful precedent if landing-page later wants to add per-event-type observability hooks.

### What landing-page already does cleaner

5. **Unified parser** — landing-page#738's `lib/competition/parse.ts:44-48` STX_EVENT_TYPES set + single asset_id derivation is cleaner than aibtcdev-backend's split between adapter-layer (FT events) and Rosetta-shape STXEventHandler. One mental model vs two. Keep landing-page's approach.
6. **Allowlist endpoint** — landing-page#738's `GET /api/competition/allowlist` (commit `37f53c6a`, 90 LOC) has no analogue in aibtcdev-backend. New surface, not a port.

## Detailed findings by file

### Pattern 1: chainhook adapter (stacks_chainhook_adapter/)

`adapters/chainhook_adapter.py:455-466` maps raw Stacks API event_type=`fungible_token_asset` → chainhook-shape `FTTransferEvent`:

```python
if event_type == "fungible_token_asset":
    ft_data = event.get("asset", {})
    event_data = {
        "amount": ft_data.get("amount", "0"),
        "asset_identifier": ft_data.get("asset_id", ""),
        "recipient": ft_data.get("recipient", ""),
        "sender": ft_data.get("sender", ""),
    }
    if ft_data.get("asset_id"):
        mutated_assets.add(ft_data["asset_id"])
    event_type = "FTTransferEvent"
```

**Reusable:** the adapter pattern (transform raw API → chainhook event) is what landing-page#738's catch-up cron would need if it walks historical txs. Currently #738's cron uses Hiro's `/extended/v1/tx/{txid}` directly via verifier; if scaling to "walk all txs in burn-block range" the adapter pattern is the proven shape.

**Caveat:** `grep STXTransferEvent\|stx_asset` returned ZERO results in the adapter. STX events fall through to `event_data = event` catch-all with raw `event_type` preserved — the adapter doesn't normalize STX. **landing-page#738's parse.ts:44-48 handles this better** by including `stx_asset`/`stx_transfer_event`/`stx_transfer` in `STX_EVENT_TYPES` and synthesizing `STX_ASSET_ID = "stx"` at parser level.

### Pattern 2: asset_id stripping

`buy_event_handler.py:186`:
```python
token_asset = event_data.get("asset_identifier").split("::")[0]
```

`volume.ts:toTeneroAddress`:
```ts
const idx = assetId.indexOf("::");
return idx >= 0 ? assetId.slice(0, idx) : assetId;
```

**Same pattern, two languages.** Strip `::asset-name` suffix from SIP-10 asset id to get the contract_id. Validates that `volume.ts` (and any consumer parsing SIP-10 token-in/token-out) is using the canonical convention.

### Pattern 3: Decimal-precise math (lottery_utils.py)

```python
liquid_decimal = Decimal(liquid_tokens)
threshold = liquid_decimal * Decimal(str(quorum_percentage))
return str(threshold.quantize(Decimal("1"), rounding=ROUND_UP))
```

**Closes v183 concern empirically.** The "Score-track-SUM-overflow on 18-decimal tokens" issue I flagged in v183 strategic-reply on #651 has a battle-tested mitigation in aibtcdev-backend: never use JS Number for amounts; use BigInt or Decimal-equivalent. For TypeScript:

- For `amount_in` (INTEGER in migration 005, currently fits Number up to 2^53 = 9 quadrillion units): JS Number is safe today
- For `volumeUsd` composite (amount × price): JS Number loses precision when amount × price-string-precision multiplies past safe integer range
- For Score-track SUM across N rows: BigInt sum + BigInt → Number conversion at the end (or use decimal.js for the leaderboard endpoint)

**Suggested action:** when Phase 3.2 score-track endpoint lands (post-#738 merge), use `decimal.js` for SUM aggregation in the leaderboard computation. ~5 LOC import + use.

### Pattern 4: BuyEventHandler / SellEventHandler / STXEventHandler separation

Each handler implements:
- `can_handle_transaction(tx) -> bool`
- `handle_transaction(tx) -> None` (async)

Specialized methods per family:
- `_has_relevant_ft_transfer_events`
- `_is_our_wallet_address`
- `_is_our_agent_account`
- `_is_stx_operation`

**Useful precedent IF landing-page later wants:** per-event-type observability hooks (Bitflow buys differently from JingSwap sells differently from raw STX transfers). For today's Phase 3.1 scope, the unified parser is sufficient; the separation pattern is for scaling beyond competitive-trading into general agent-economic-activity tracking.

### Bitflow tool (`app/tools/bitflow.py`)

aibtcdev-backend's Bitflow integration is a langchain BaseTool that shells out to `BunScriptRunner.bun_run(wallet_id, "stacks-bitflow", "execute-trade.ts", ...)`. Delegates to bun scripts in `agent-tools-ts/`.

**Same indirection layer as mcp-server's Bitflow tools.** No new patterns to lift. Worth noting: aibtcdev-backend's Bitflow tool had no allowlist-aware filtering — same operational gap I empirically surfaced in v201. Validates that mcp-server#510's allowlist wire-up (scout `daemon/scouts/510-allowlist-wireup.md`) is a net-new contribution, not a port.

## Repo-state caveat

The repo's README opens with: "**⚠️ This repository is has been archived.** This project has been retired."

So treat findings as **"what worked before retirement,"** not active recommendations. Copy patterns that solved problems landing-page is hitting; don't migrate code wholesale.

## Concrete next-cycle actions

1. **No PR work on this directly.** Patterns are notes for landing-page + mcp-server work, not a port surface.
2. **When Phase 3.2 score-track endpoint opens on landing-page (post-#738):** propose `decimal.js` import for the SUM aggregation. ~5 LOC, references this scout.
3. **If #738's catch-up cron grows beyond per-txid Hiro lookups:** reference the `stacks_chainhook_adapter` pattern as the migration shape. Currently not needed — #738's verifier handles per-txid lookups fine.
4. **Validate scout findings with operator:** Telegram-ack the scout completion + the 4 patterns surfaced.
