# scout — #738 PR body cleanup patch (post chainhook scope-cut)

**Status:** pre-positioned. Ready to ship as a `gh pr edit` patch when biwasxyz says go (offered in v237 telegram id: 200 + v202 follow-up).

**Discovery cycle:** 2034v238 (2026-05-12T01:54Z)

## Proposed body (full replacement, ready to copy-paste)

```markdown
## Summary

Phase 3.1 of the trading-comp verifier — folds 4 PR slices into one branch so we can test the whole surface against a single preview URL. Per-file commits within the branch trace each slice for review.

- Closes #734 (Phase 3.1 verifier + API routes)
- Refs umbrella #652, RFC `docs/rfc-d1-schema.md` §swaps, MCP consumer aibtcdev/aibtc-mcp-server#510
- Builds on the substrate from #668 (migrations 005/006/007)
- Patterns mirrored from #722 (read-route flip), #720 (D1 dual-write), #732 (JOIN reads)

## What changed

| Slice | Files added | Files modified |
|---|---|---|
| **PR-A** (read routes) | `lib/competition/d1-reads.ts` + tests, `app/api/competition/{status,trades}/route.ts`, `app/api/competition/__tests__/d1-throws-fallback.test.ts` | `app/api/openapi.json`, `app/llms.txt`, `app/llms-full.txt`, `app/.well-known/agent.json` |
| **PR-B** (verifier) | `lib/competition/{parse,verify}.ts` + tests, `app/api/competition/__tests__/post-verifier.test.ts` | `app/api/competition/trades/route.ts` (POST now live) |
| **PR-D** (cron + allowlist) | `lib/competition/{allowlist,cron}.ts` + tests, `app/api/competition/cron/route.ts` + tests | `cloudflare-env.d.ts` (`CRON_SECRET`) |
| **PR-E** (provider) | folded into `parse.ts` (no new files) | — |

PR-C (chainhook receiver) was scope-cut early in the branch — 8 revert commits at 04:31-04:34Z 5/11 (see `revert(competition): remove chainhook receiver route` and siblings). The `source` enum reserves `'chainhook'` for a future real-time path; no chainhook code ships in this PR.

### Hard constraints honoured

- Field names from migration 005 (`sender`, `token_in`, `amount_in`, `burn_block_time`, `source`) — not the #683 spec.
- **No `pending` row in D1.** Pending-tx state is KV-tracked (`comp:pending:{txid}`, 30-min TTL).
- `source` enum: `agent | cron | chainhook` (last value is reserved-not-yet-implemented).
- Mainnet-only; no `network` parameter.
- No schema changes to `swaps` in this PR.
- `INSERT OR IGNORE` on `(txid)` — first writer wins across the two deployed ingestion paths (agent-submit POST + nightly cron).

### Discovery docs synced

OpenAPI 3.1, `llms.txt`, `llms-full.txt`, and `.well-known/agent.json` all advertise the live surface (status / trades GET+POST / allowlist / cron). MCP clients codegenning from the spec will see the real response matrix, not the 501 stub.

## Test plan

113 new unit + route tests; full suite (`npm run test`) green at 1081 passing. Build green; OpenAPI + agent-card lint OK.

Against a preview deploy:

```bash
# Status — registered sender
curl "https://<preview>/api/competition/status?address=SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE"

# Status — unregistered sender (should return registered:false, NOT 404)
curl "https://<preview>/api/competition/status?address=SP00000000000000000000000000000000000000"

# Trades — empty page
curl "https://<preview>/api/competition/trades?address=SP4DXVEC...&limit=10"

# Allowlist — discoverable verifier scope (added late in branch)
curl "https://<preview>/api/competition/allowlist"

# Submit (malformed txid → 400)
curl -X POST "https://<preview>/api/competition/trades" \
  -H "Content-Type: application/json" \
  -d '{"txid":"not-hex"}'

# Submit (real txid → 200 verified / 202 pending / 422 rejected)
curl -X POST "https://<preview>/api/competition/trades" \
  -H "Content-Type: application/json" \
  -d '{"txid":"0x46bc5587ae56e5bd4453daa2bf63c2a9e0414953fd21a82eb44f2f926f0ee0e4"}'

# Self-doc
curl "https://<preview>/api/competition/status?docs=1"
curl "https://<preview>/api/competition/trades?docs=1"
curl "https://<preview>/api/competition/cron"        # GET → self-doc
```

Operator-only routes need the secret set first:

```bash
wrangler secret put CRON_SECRET --env preview
```

Then:

```bash
# Cron (with secret)
curl -X POST "https://<preview>/api/competition/cron" \
  -H "X-Cron-Secret: $CRON_SECRET"
```

## Scheduler follow-up

Per #764 + my second-opinion second on that issue, the scheduler that *calls* `/api/competition/cron` (or replaces it via a `VerifierSweepDO.alarm()` directly invoking `runCompetitionCron`) ships as a follow-up using the Durable Object alarm pattern, not Cron Triggers. `CRON_MAX_ADDRESSES_PER_RUN = 100` in `lib/competition/cron.ts` already matches `DashboardRebuildDO`'s `CHUNK_SIZE = 100` — the chunking math is shared across both DOs.
```

## Changes from current body

1. **Slice count**: "5 PR slices" → "4 PR slices" (PR-C reverted)
2. **PR-C row removed** from "What changed" table; replaced with a single sentence pointing at the 8 revert commits
3. **PHASE-3.1-HANDOFF.md link removed** (broken — file not committed to branch per v223 finding)
4. **`source` enum framing**: `agent | cron | chainhook` (reserved) — kept the value list, clarified semantics
5. **"first writer wins across all three ingestion paths"** → "across the two deployed ingestion paths (agent-submit POST + nightly cron)"
6. **Discovery docs paragraph**: dropped `chainhook` from the live surface enumeration; added `allowlist` which exists
7. **Test plan**: dropped chainhook curl + `wrangler secret put CHAINHOOK_SECRET`; added `/api/competition/allowlist` curl
8. **New section "Scheduler follow-up"**: references #764 + the DO-alarm pattern decision

## How to apply

```bash
gh pr edit 738 --repo aibtcdev/landing-page --body "$(cat <newfile>)"
```

Or just paste the body block above into the GitHub UI.

## Posting trigger

Send when biwasxyz confirms in telegram (response to id: 202 question 3) OR pushes a new commit on #738 (then I pivot this into an inline review-comment with diff context).
