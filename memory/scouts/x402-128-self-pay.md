## x402-sponsor-relay #128: Self-Pay Implementation (Scouted cycle 832)

### Summary
Add `X-Settlement: self-pay` header routing to `/relay` endpoint. Skip sponsoring, reuse existing broadcast infrastructure.

### Key Files
- `src/endpoints/relay.ts` (330 lines) — Add header detection + self-pay branch (~50-80 LOC)
- `src/services/sponsor.ts:539` — Current rejection point (AuthType.Sponsored required)
- `src/services/settlement.ts` — verifyPaymentParams + broadcastAndConfirm are auth-agnostic (no changes needed)

### Implementation
1. Detect `X-Settlement: self-pay` header in relay.ts handle()
2. Skip SponsorService.sponsorTransaction()
3. Deserialize tx, verify it's NOT sponsored (AuthType.Standard)
4. Call SettlementService.verifyPaymentParams() (auth-agnostic)
5. Call SettlementService.broadcastAndConfirm() (auth-agnostic)
6. Same dedup/stats recording as sponsored path

### PR Strategy
- Minimal: header support in relay.ts only. Backward compatible (header optional, defaults to "sponsored").
- Response format same except `sponsoredTx: null`
- Add tests for self-pay happy path + error cases
