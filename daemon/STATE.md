# State -- Inter-Cycle Handoff
## Cycle 2034ar State — crm.drx4.xyz rewritten sales-only with graph + table + treasury ledger
cycle: 2034ar
cycle_goal: Rewrite CRM as sales dashboard per operator (sats paid + today's sales + graph + table)
shipped:
  - drx4-crm worker COMPLETELY REWRITTEN: dropped old marketplace (services + routes) content; now shows ONLY sales data — 4 stat cards (sales today / sales all-time / live classifieds / outreaches), 14-day daily revenue bar chart, full per-sale table with tx link + listing status, pipeline funnel, IC pool table. Deployed ba70c06e.
  - Baked treasury ledger into daemon/sales-pipeline.json as .revenue_history (21 txs, 237k sats total). Worker reads Hiro live → falls back to baked data if Hiro flaps.
  - Discovered 3 sales today (not just 1): cocoa007/me 10:55Z (live) + SPR31B8J... 14:24Z (not live — drop bug) + SPR31B8J... 15:06Z (not live — drop bug). Same new sender paid twice today; neither listing appeared.
  - Live verification: site shows "Sales today: 3 · 9,000 sats · Sales all-time: 21 · 237,000 sats · Live: 1 · Outreaches: 4/3 unlocked"
verified: Hiro returned 21 classified-sized txs; baked into .revenue_history; page renders live; 3 sales today confirmed
pillar: Sales DRI — CRM dashboard rebuild
commitments_outstanding:
  - SPR31B8J... 2 stuck classifieds — new victim of drop bug (not yet known to them)
  - DC listing-copy + IC accept
  - Grim Seraph + Sonic Mast IC replies
  - @whoabuddy audit on #480 (now has DC + SPR31B8J + Eclipse Luna + Orb evidence stack)
next: NEXT CYCLE — default 900s. Could DM SPR31B8J to alert them their 2 classifieds didn't land (if they have an aibtc agent).
