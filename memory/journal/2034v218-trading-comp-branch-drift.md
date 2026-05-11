# cycle 2034v218 — trading-comp branch-drift surfaced empirically

## Context
Operator boot 2026-05-11T~15:58Z with /start args: focus 100% on trading-competition PRs across MCP + landing-page; review + test via preview URLs; file ONE issue tagging @whoabuddy + @arc0btc.

## What I did
1. Boot sweep over aibtc-mcp-server + landing-page open PRs. Identified trading-comp cluster: mcp#510 (biwasxyz, comp tools), mcp#512 (arc, Pyth VAA fix), mcp#513 (arc, vaaInFlight follow-up); landing-page#738 (biwasxyz, Phase 3.1 verifier), #743 (biwasxyz, leaderboard), #651 (biwasxyz, dashboard).
2. Cross-checked prior cycle state: I'd already shipped APPROVE × 5 on #738, APPROVE × 2 on #512, APPROVE on #513, COMMENTED on #743 + #651 over the past ~6h.
3. **Empirical preview test**: curled `/api/competition/{trades,status,allowlist,chainhook,cron}` on #743 commit-preview `ccb7146f-landing-page.hosting-962.workers.dev`. All 404. Same paths on #738 commit-preview `17bf60a8-landing-page.hosting-962.workers.dev` → 200/400 (working).
4. Root-cause trace: `gh api repos/aibtcdev/landing-page/contents/lib/competition?ref=feat/agents-mcp-trades-volume` → 404 NotFound. Same for `app/api/competition?ref=…`. Confirmed: #743's head branch was rebased onto main and dropped #738's verifier substrate.
5. Migration check: `001-008` exists on main + both branches (swaps table is there). So the gap is *code* not *schema*.
6. Production-state risk modeled: if #743 merges first, prod ships `/leaderboard` UI with empty swaps table (no data-population path because verifier routes not deployed).
7. Filed `aibtcdev/landing-page#754` (85-line consolidated issue) tagging @whoabuddy + @arc0btc with: empirical evidence, preview-environment confirmation, production-state risk, recommended merge order (#738 → main → rebase #743 → merge), cross-cluster posture for mcp#510/#512/#513 + landing-page#651.
8. Cross-linked from #743 with a tighter comment (`issuecomment-4422436980`) so biwasxyz sees it in PR context.

## Pattern observation (new in this cycle)
**"Preview shares D1 with sibling-PR preview, masking a runtime gap that production won't see"** — the `/leaderboard` page rendered fine on #743's preview only because CF previews share a D1 instance with #738's preview where I'd populated test data earlier. From the surface, the preview looks healthy. The branch-drift bug surfaces only when you probe a sibling route (`/api/competition/*`) that LIVES on the missing-from-head substrate.

Generalization: when reviewing stacked-PR previews, don't just test the surface the PR adds — also test sibling routes from the base PR. If they 404, the head branch has drifted from base.

## Risk-modeling check
- I claimed `/leaderboard` would render empty in production if #743 merges first. Verified by: migration 005_swaps.sql is on main (schema present), but `app/api/competition/{trades,chainhook,cron}` routes that populate swaps are NOT on main. Without those routes deployed, no agent submission, no chainhook ingestion, no cron sweep → swaps stays empty → `/leaderboard` SSR query returns 0 rows → empty UI.
- One thing I did NOT verify: whether there's any *other* deployed pipeline (a worker queue, a scheduled cron in wrangler.toml, a chainhook predicate already registered) that might populate swaps without #738's code. Quick read of #738's PR body says it adds `app/api/competition/cron/route.ts` + `app/api/competition/chainhook/route.ts` as new files — so the pipelines are net-new in #738. Confirmation holds.

## What I did NOT do (intentional)
- Did NOT open a fix PR. The constraint is coordination-level, not code-level — the right action is a maintainer ack + merge-order discipline.
- Did NOT change #743's base back to `feat/competition-read-routes`. That would block #743 indefinitely on #738's merge and is the opposite of what's wanted.
- Did NOT post on #738. The finding is about #743's drift from #738's substrate, not about #738 itself.

## Verified
- https://github.com/aibtcdev/landing-page/issues/754 → 200
- https://github.com/aibtcdev/landing-page/pull/743#issuecomment-4422436980 → 200
- daemon/outputs.log appended with both events

## Time
~6 min from boot to ship (briefing → empirical probe → root-cause → write → file → cross-link → verify → state).
