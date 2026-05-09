# landing-page Phase 1.2 (D1 provision + migrations 001–006) — review-prep scout

> Built v71 2026-05-09T01:06Z. Mirrors the `daemon/scouts/661-implementation-prep.md` (v63 → v65) and `daemon/scouts/497-pre-phase-2.5-baseline.md` (v54 → v55 → v66 RFC citation) patterns. Goal: when the Phase 1.2 PR opens (likely 2026-05-09 or 10), this scout shortcuts the read-and-orient phase so the review focuses on unique value rather than re-deriving Phase 1.2 scope.

## Phase 1.2 scope per RFC #665 (post-fixup b7a9b8f)

> Goal: Provision D1 + migrations 001–006
> Rough shape: `wrangler d1 create landing-page`; one migration per table; apply in dev + prod; document chosen region.

This is **infrastructure-only** — schema + binding. The data lives in KV; nothing flips reads or writes yet. Migration risk is low because no production traffic touches D1 until Phase 2.x flips the read paths. The high-leverage review surface is therefore **schema correctness + env isolation + ops hygiene**, not runtime behavior.

## Files I expect to see in the PR diff

| File | What I expect | Why it matters |
|------|---------------|----------------|
| `wrangler.jsonc` | D1 binding(s) added, mirroring the #666 ratelimits pattern: top-level binding + `env.production` + `env.preview` blocks with **distinct `database_id`s** | Per #666 precedent: env isolation prevents preview load tests / branch deploys from touching production data. **This is the single highest-leverage read-ahead — distinct database_ids per env, not a shared id**. |
| `cloudflare-env.d.ts` | `D1Database` typing on `CloudflareEnv.DB` (or whatever binding name is chosen) | Matches the `RATE_LIMIT_*` binding-typing pattern from #666. |
| `migrations/0001_agents.sql` … `0006_balances.sql` | One migration per table per RFC | FK dependencies require an ordering: agents → claims → inbox_messages → swaps → balances (claims and inbox_messages reference agents.btc_address; swaps and balances reference agents.stx_address via foreign key). |
| Possibly `lib/d1.ts` or similar | D1 query helper / connection accessor | Optional; might be deferred to Phase 2.1 when the first read-flip lands. |
| Possibly `app/api/__tests__/d1-smoke.test.ts` | Smoke test exercising the schema (CREATE-then-SELECT roundtrip) | Confirms migrations apply cleanly; matches the "per-PR smoke window" line in the RFC migration-plan footer. |

## Schema correctness checklist (vs. RFC post-fixup b7a9b8f)

When the migration files land, verify each table against the RFC's normative shape:

### `agents` (0001)
- [ ] `btc_address` PRIMARY KEY (the canonical agent ID)
- [ ] `stx_address NOT NULL UNIQUE` (per fixup partial-agent scope decision: full AgentRecords only)
- [ ] `stx_public_key NOT NULL`
- [ ] `referral_code NOT NULL UNIQUE` (per fixup: backfill must generate-and-store missing codes deterministically)
- [ ] **NO `idx_agents_stx`** — UNIQUE constraint creates the implicit index (per fixup, copilot's catch). If the migration adds it explicitly, that's a regression on the fixup.
- [ ] Created/updated_at timestamps for audit

### `claims` (0002)
- [ ] FK `agent_address → agents.btc_address` (D1 enforces FK by default per fixup codex-P2 correction)
- [ ] One-time-use semantic preserved (PRIMARY KEY on the claim code or UNIQUE)

### `inbox_messages` (0003)
- [ ] **`from_stx_address` + `from_btc_address` (split, per arc's fixup catch) + CHECK constraint enforcing exactly-one-populated** — if this lands as a single `from_address` column, that's the latent bug surface arc flagged getting reintroduced
- [ ] **`bip137_signature` (single column, per arc's fixup catch)** — not `sender_signature` + `signature`
- [ ] `to_btc_address NOT NULL`
- [ ] `is_reply BOOLEAN/INTEGER`
- [ ] `read_at NULLABLE` (NULL = unread)
- [ ] `payment_txid NULLABLE UNIQUE` (per fixup: permanent idempotency, was 90d KV TTL)
- [ ] `idx_inbox_unread (to_btc_address, is_reply, read_at)` partial WHERE `read_at IS NULL` — load-bearing for `SELECT COUNT(*)` that closes #497
- [ ] FK `to_btc_address → agents.btc_address` (assuming sender doesn't need to be a registered agent)

### `swaps` (0004)
- [ ] FK `sender → agents.stx_address`
- [ ] Trading-comp verifier columns

### `balances` (0005)
- [ ] `(agent_address, token_id, captured_at)` composite key shape
- [ ] `idx_balances_agent_token_time (agent_address, token_id, captured_at DESC)` — the dashboard query covering index
- [ ] **NO `idx_balances_captured_usd_desc`** (per fixup arc catch — doesn't serve the dashboard query shape)
- [ ] FK `agent_address → agents.stx_address`

### `registered_wallets` view (0006 or appended to 0001)
- [ ] **Pure projection** — no `WHERE stx_address IS NOT NULL` predicate (per fixup copilot+my-Q1 catch — NOT NULL constraint already covers it)

## Env isolation — the strongest single read-ahead suggestion

Per #666 ratelimits pattern, `wrangler.jsonc` should have:

```jsonc
"d1_databases": [
  {
    "binding": "DB",
    "database_name": "landing-page-local",   // top-level: local-dev default
    "database_id": "<dev-uuid>"
  }
],
"env": {
  "production": {
    "d1_databases": [
      { "binding": "DB", "database_name": "landing-page", "database_id": "<prod-uuid>" }
    ]
  },
  "preview": {
    "d1_databases": [
      { "binding": "DB", "database_name": "landing-page-preview", "database_id": "<preview-uuid>" }
    ]
  }
}
```

If the PR ships with **shared `database_id`** across env.production and env.preview, that regresses the env isolation gain from #666. Branch preview migrations would mutate production schema — exactly the footgun #666 closed for ratelimits namespace_ids.

## DEPLOY_ENV / fail-closed pattern (Phase 1.2 doesn't strictly need this yet)

My v67 read-ahead suggested codifying `failClosedOnBindingError(env): boolean` as a helper to extend the DEPLOY_ENV gating to D1 connection errors. **Phase 1.2 doesn't add D1 read paths yet** — that's Phase 2.1. So the helper extraction is more naturally a Phase 2.1 review suggestion. Note here so I don't pre-emptively raise it on Phase 1.2.

## Region documentation (per RFC Decision 4)

> Action item for Phase 1.2: before provisioning the production D1 instance, identify the highest-traffic region (per-Workers-Analytics from `dash.cloudflare.com`) and provision D1 in the same region. Document the chosen region in `wrangler.jsonc` next to the D1 binding so future deploys don't accidentally relocate.

If the PR doesn't include a region comment in `wrangler.jsonc` next to the D1 binding, that's a non-blocking flag — a one-line `// Provisioned in <REGION> (highest-traffic per dash.cloudflare.com 2026-05-XX)` matters for ops continuity.

## Migration apply mechanics

D1 migrations are typically applied via `wrangler d1 migrations apply landing-page --remote`. Things to spot-check:

- **Forward-only**: D1 has no built-in down-migration. RFC explicitly accepts this trade-off ("Schema lock-in"). If the PR includes `down.sql` files, that's harmless but unused.
- **Apply order**: file numeric prefix should drive ordering (0001 → 0006). FK dependencies require agents first.
- **Idempotency**: `wrangler d1 migrations` table tracks what's applied. Re-running should be safe.
- **CI gate**: per-PR smoke is "apply migrations to a fresh dev DB and run a SELECT against each table." If absent, propose adding it as a follow-up (non-blocking for Phase 1.2; load-bearing for Phase 1.3 backfill).

## Phase 1.2 review focus (single-paragraph framing for the review)

> Phase 1.2 is infrastructure-only — schema + D1 binding, no read or write flips, no production traffic touches D1 yet. The high-leverage review surface is **schema correctness vs. RFC post-fixup b7a9b8f** (especially the `from_address` split, `bip137_signature` collapse, dropped redundant indexes that fixup specifically corrected — easy to accidentally regress when transcribing RFC to migration files), **env isolation matching #666 ratelimits pattern** (distinct `database_id` per env), and **region documentation per RFC Decision 4** (one-line `wrangler.jsonc` comment). Phase 2.1 will be where the runtime semantics review surface opens up.

## Pile-on-avoidance notes

When the PR opens, expect Copilot + Codex to flag:
- Migration ordering (any FK dependency violation will surface immediately on apply attempt)
- Index choice (Copilot is good at flagging redundant indexes — likely re-flag dropped ones if accidentally re-added)
- D1 binding shape (Codex usually catches missing typing or env-block omissions)

Arc will likely flag (consistent with #665 review pattern):
- Schema-vs-RFC drift (especially the post-fixup refinements arc himself drove)
- Env isolation gaps (post-#666 he's tuned to this)
- D1-specific quirks (D1 SQLite differs from PostgreSQL on some defaults — FK enforcement default was already a fixup correction, so arc is likely tuned to D1-vs-SQL-server diff)

My unique value-add is likely:
1. **Cross-reference the schema-vs-fixup checklist** above as load-bearing review evidence (the fixup-vs-PR drift is the highest-leverage thing I can verify since I've personally tracked the fixup commit in detail across cycles v66/v68)
2. **#497 closure path empirical link** — confirm `idx_inbox_unread` covering the `SELECT COUNT(*) WHERE … read_at IS NULL` query is present + correctly shaped, since that's the load-bearing fix for the #497 drift bug per my v54/v55 scout
3. **Phase 1.4 acceptance test cite** — re-flag that the empirical drift acceptance test recipe is ready to drop in (per RFC migration-plan table acknowledging my scout)
4. **#666 env-isolation precedent** — explicitly cite that the ratelimits env-block pattern from #666 is the right model here, not a hypothetical (whoabuddy himself wrote #666, so this lands clearly)

## Open questions (will resolve when PR opens)

- Does the PR include a smoke test exercising migrations apply? (load-bearing for Phase 1.3 confidence)
- Does the PR include a D1 query helper module (`lib/d1.ts`)? (optional, may be Phase 2.1 territory)
- Does the migration file path follow the wrangler convention (`migrations/`) or a custom path?
- Is `wrangler d1 migrations apply` run via CI or manually as ops? (matters for rollback story)
