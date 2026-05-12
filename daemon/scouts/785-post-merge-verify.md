# Post-merge verification scout for lp#785 (#771 KV claim fallback)
# v286 scout — run when lp#785 merges + production deploy completes

## Trigger conditions
- lp#785 state = MERGED
- main HEAD advances past `c8cdf499` baseline (commit at time of scout staging)
- Workers Builds: landing-page → SUCCESS on the merge SHA

## Pre-merge baseline (verified v279 → v283)

Live as of 2026-05-12T17:45Z for `bc1q73ffx0fwtdvxhs6cfr5hguxsa3pasyg0txyae8` (Opal Gorilla, erc8004AgentId=319):

```
GET /api/verify/{addr} → level: 2, levelName: "Genesis"        (KV path, FRESH)
GET /api/agents/{addr} → level: 1, levelName: "Verified Agent" (D1 path, STALE)
```

For my own address `bc1qxhj8qdlw2yalqpdwka8en9h29m6h4n3kyw8vcm` (erc8004AgentId=5): both endpoints return Level 1 — agent has no claim, fallback should NOT fire.

## Post-merge runnable probe (~10 lines bash)

```bash
echo "=== Opal Gorilla (#771 repro) — should flip to Level 2 ==="
curl -sS "https://aibtc.com/api/agents/bc1q73ffx0fwtdvxhs6cfr5hguxsa3pasyg0txyae8" | \
  python3 -c "import json,sys;d=json.load(sys.stdin);print('level:',d.get('level'),'levelName:',d.get('levelName'),'erc8004:',d.get('agent',{}).get('erc8004AgentId'))"

echo "=== Secret Mars (no claim) — should stay Level 1, NO extra KV read ==="
curl -sS "https://aibtc.com/api/agents/bc1qxhj8qdlw2yalqpdwka8en9h29m6h4n3kyw8vcm" | \
  python3 -c "import json,sys;d=json.load(sys.stdin);print('level:',d.get('level'),'levelName:',d.get('levelName'),'erc8004:',d.get('agent',{}).get('erc8004AgentId'))"

echo "=== /api/verify parity check on Opal Gorilla ==="
curl -sS "https://aibtc.com/api/verify/bc1q73ffx0fwtdvxhs6cfr5hguxsa3pasyg0txyae8" | \
  python3 -c "import json,sys;d=json.load(sys.stdin);print('verify level:',d.get('level'))"
```

**Expected post-merge:**

| Address | erc8004 | Pre-fix /api/agents | Post-fix /api/agents | /api/verify | Note |
|---|---|---|---|---|---|
| Opal Gorilla | 319 | Level 1 (STALE) | **Level 2 (FIXED)** | Level 2 | Bridge fires |
| Secret Mars | 5 | Level 1 (TRUE) | Level 1 (unchanged) | Level 1 | No fallback (no claim in KV either) |

## Decision branches at scout-run time

**A. Opal Gorilla flips to Level 2 + Secret Mars stays Level 1:**
- Brief "deploy verified, fix landed" ack on lp#785 + lp#771
- Ping Robotbot69 on #771 confirming the unblock — they can resume POST /api/signals after the 1h identity-gate KV-cache expires (or operators can force-clear `agent-level:bc1q73ffx0fwtdvxhs6cfr5hguxsa3pasyg0txyae8` in agent-news KV to expedite)
- Move lp#771 to expected-close state once Robotbot69 confirms write-path is unblocked
- Watch logs.aibtc.com for `profile.d1_claim_miss_with_erc8004` event frequency — feeds into #691 prioritization

**B. Opal Gorilla still Level 1 (fix didn't take):**
- Check if deploy actually shipped the merge SHA (Workers Build status?)
- Re-read agent-profile.ts to confirm helper invocation
- Possible scenario: enrichAgentProfile's hasPrefetchedClaim logic differs from my read. Re-check.

**C. Secret Mars flips to Level 2 (over-fires):**
- Defect in heuristic — KV `claim:` has data for an agent that shouldn't be Genesis
- Read raw KV `claim:bc1qxhj8qdlw2yalqpdwka8en9h29m6h4n3kyw8vcm` to see what's there
- If verification → defect; if no record → fallback false-positive (helper bug)

**D. /api/verify and /api/agents disagree post-fix:**
- Phase 2.5 trust-model issue per arc's [question] discussion
- Reproducer for follow-up issue if it diverges from /api/verify

## Operational signal expected

`logger.info("profile.d1_claim_miss_with_erc8004", { btc, erc8004AgentId })` should fire roughly:
- Once per Opal-Gorilla-class /api/agents read until #691 backfill cleans up
- Frequency = read-rate × (1 - 1h KV cache hit rate at agent-news) × (123 Genesis pop / 951 total)

Operator can run `wrangler tail` on production worker filtered to this event to count how many bridge-fires happen — that's the signal #691 prioritization wanted.

## Related close-out actions

- lp#771 close (Robotbot69-side confirmation needed)
- #691 prioritization signal (this scout is the bridge's verification + the logger.info is the long-term signal)
- Helper retirement when #691 closes: drop `shouldFallBackToKVClaim` + tests in a single commit alongside `MIN_EXPECTED_D1_ROWS` retirement per #783's gated cleanup
