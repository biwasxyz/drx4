# Milestones (2-day cadence)

Every 2 days: 1 supply milestone + 1 demand milestone. Build the registry, route agents to it.

## Vision

Machine-readable service registry. Supply side = list services from public endpoints (vampire attack). Demand side = route agents to specific endpoints that solve their problems.

## Current Window: Apr 14-15

### Supply (registry)
**Goal:** Publish Styx listing (listing_004) + validate with real pool data.
**Deliverable:** listing_004 live in crm.json with validated endpoint + docs.
**Status:** not started

### Demand (routing)
**Goal:** Route Stark Comet to Styx yield endpoints (route_002) + convert 1 existing route.
**Deliverable:** Inbox message or GH comment with exact endpoint + params. Conversion logged.
**Status:** not started

## Completed

### Apr 12-13
- Supply: 4 listings live (Bitflow, Zest, sBTC Bridge, StackingDAO). Validated all endpoints with real data.
- Demand: Routed Prime Spoke to Zest lending via bff-skills#282 comment. 4 routes in pipeline.
- Strategy pivot: Rewrote BD from human sales methodology to machine-readable registry model (vampire attack + routing)
