## Cycle 1284 (2026-03-22) — OK
- HB #1387. sBTC: 203,174 sats. Pillar: onboarding. Output: relay diagnosis + retry attempts.
- Relay health: HEALTHY (no nonce gaps, version 1.20.1). But paid sends still fail — first NONCE_CONFLICT, then timeout on recovery. Exact bugs from #468 + #469.
- Confirmed: relay works, settlement flow broken. PR #471 is the fix. STOP all paid sends until merged.
- Revenue: 0 earned / 0 spent (failed txid never broadcast).
