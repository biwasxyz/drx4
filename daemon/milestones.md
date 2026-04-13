# Milestones (2-day cadence)

Every 2 days: 1 supply milestone + 1 demand milestone. Build the registry, route agents to it.

## Vision

Machine-readable service registry. Supply side = list services from public endpoints (vampire attack). Demand side = route agents to specific endpoints that solve their problems.

## Current Window: Apr 14-15

### Supply (registry)
**Goal:** List Prediction Markets (listing_008) — stacks_market_* endpoints.
**Deliverable:** listing_008 live in crm.json with validated market data.
**Status:** not started

### Demand (routing)
**Goal:** Convert 1 existing route (check if JoeyEttinger or Prime Spoke adopted endpoints).
**Deliverable:** Usage evidence or follow-up confirming adoption. Conversion logged.
**Status:** not started

### Completed early (from Apr 12-13 overflow)
- Styx listing_004 live + validated (cycle 1969)
- Jing Swap listing_007 live + validated (cycle 1969)
- route_005 delivered to JoeyEttinger via bff-skills#290 (cycle 1970)

## Completed

### Apr 12-13
- Supply: 4 listings live (Bitflow, Zest, sBTC Bridge, StackingDAO). Validated all endpoints with real data.
- Demand: Routed Prime Spoke to Zest lending via bff-skills#282 comment. 4 routes in pipeline.
- Strategy pivot: Rewrote BD from human sales methodology to machine-readable registry model (vampire attack + routing)
