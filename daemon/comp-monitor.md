# Trading Competition — Live Monitor

> Operator directive cycle 2034v319 (2026-05-13T16:30Z): trading comp announces today (Rules of Play #815 filed at 11:05Z); monitor for bugs, track participants, surface findings each cycle.

## Latest snapshot — 2034v320 (2026-05-13T16:53Z)

**Comp official start:** **2026-05-13T19:30:00Z** (per #819's `COMP_START_TIMESTAMP = 1778700600`, merged 16:33Z). T-2h37m as of this update.

**v320 deltas:**
- **#819 MERGED 16:33Z** — `COMP_START_TIMESTAMP` shifted from `2026-05-13T00:00:00Z` → `2026-05-13T19:30:00Z`. Trades before that timestamp rejected as `before_comp_start`. Also: leaderboard tagline rewritten to cite #815 §5; instant Tooltip component replaces native `title=` (fires on `onMouseEnter`); `formatUsdPrecise` extended for ultra-small values like `$0.0000000121`.
- **#821 OPEN — whoabuddy** — `fix(leaderboard): count scheduler-ingested competition trades`. 1-line WHERE-clause widening: `s.source = 'agent'` → `s.source IN ('agent','cron','chainhook')`. **My APPROVE shipped 16:50Z** with 5 "what works well" + 2 [observation]s ((1) WHERE clause is redundant w.r.t. migration 005 CHECK constraint; (2) cross-link to #820) + 1 [suggestion] (regression test fixture for source-filter behavior — fits v137 codified pattern) + 1 [nit] (PR test-plan path doesn't actually exercise the changed query). Empirically my own data: 4× `source=agent` + 1× `source=cron`, so pre-fix would undercount by ~20% on my notional/P&L.
- copilot-pull-request-reviewer commented at 16:49Z (1m21s before mine) — review window cluster.
- Re-scanned top-9 Genesis at 16:53Z: still **0 new active traders**. Mine remains the lone visible activity. Last trade `1778667909` = 2026-05-13T02:25:09Z (this morning).
- All my trades still show `scored_value: null` — Genesis gate continuing to gate scoring per #814.

## Earlier snapshot — 2034v319 (2026-05-13T16:35Z)

### Launch surface
- **Rules of Play:** [aibtcdev/landing-page#815](https://github.com/aibtcdev/landing-page/issues/815) — biwasxyz, OPEN, label `trading-competition-rule`. Filed 11:05Z. Treat as canonical reference.
- **Allowlist:** `GET https://aibtc.com/api/competition/allowlist` — 10+ Bitflow contracts (stableswaps, XYK, DLMM router, cross-DEX routers, wrappers). ALEX/Zest/non-Bitflow not in scope v1.
- **Status check:** `GET /api/competition/status?address=…` — returns `{ registered, agent_id, trade_count, verified_trade_count, first/last_trade_at }` only. **No `campaign` block** (P&L/rank are client-side per #815 §6 + Open Work 5).
- **Trades read:** `GET /api/competition/trades?address=…&limit=…` — public per-address swap history. NO aggregate-across-agents endpoint (returns 400 without address).
- **Leaderboard endpoint:** `/api/competition/leaderboard` returns 404. Page renders client-side from per-agent `/api/competition/trades` calls.

### Comp-infra PRs landed today (5/13)
| PR | Title | Merged |
|---|---|---|
| #738 | Phase 3.1 verifier + read routes + allowlist + scheduler | 00:24Z |
| #803 | leaderboard P&L (USD) column with mark-to-current pricing | 07:03Z |
| #808 | docs: clarify allowlist, ranking, P&L methodology | 08:43Z |
| #810 | leaderboard: label P&L column as **Unrealized P&L** | 10:28Z |
| #812 | canonical sBTC asset name + allowlist `wrapper-velar-v-1-2` | 10:47Z |
| #814 | **require Genesis (Level 2) for trade scoring** | 14:25Z |

### Open issues / bugs
| # | Title | State | My role |
|---|---|---|---|
| #794 | SchedulerDO Tenero refresh task not populating KV | OPEN | mine |
| #805 | scoring not populating + campaign block missing | OPEN | mine; cross-linked to #815 §6 + #811 in [comment 4443224753](https://github.com/aibtcdev/landing-page/issues/805#issuecomment-4443224753) |
| #809 | leaderboard P&L label + SchedulerDO + sBTC asset-id mismatch | OPEN | biwasxyz |
| #811 | leaderboard server-side compute (blocked by #809 + sBTC fixes) | OPEN | biwasxyz |
| #815 | Rules of Play canonical reference | OPEN | biwasxyz; the announcement |
| **#820** | **wallet-rotation Genesis gap + duplicate /api/leaderboard rows for same erc8004AgentId** | **OPEN** | **mine — filed v319** |

### Participating agents
> Snapshot of all `level >= 2` (Genesis-eligible) agents from `/api/leaderboard`, n=123. **0** have executed trades through their current wallets. Among non-Genesis (level 1) sample n=80, **1** has — Quasar Garuda at SP20GPDS… which is my own current wallet (the duplicate-row half of #820).

| Wallet | Display | Level | Trades | Notes |
|---|---|---|---|---|
| `SP20GPDS5RYB2DV03KG4W08EG6HD11KYPK6FQJE1` (mine, current) | Quasar Garuda | 1 (Verified) | 5/5 | Live P&L +$0.13 / +7.30%; trades NOT scoring under #814 (Genesis gap) |
| `SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE` (mine, retired) | Secret Mars | 2 (Genesis) | 1/1 | Pre-rotation trade preserved per #814 \"no retroactive purge\" |
| All other 122 Genesis agents | — | 2 | 0/0 | No comp activity post-launch |

**Topline for operator:** ~5h after rules went live, **no other Genesis agent has executed a comp trade**. My agent is the lone observed trader, and gated out under #814 due to wallet-rotation Genesis gap (filed as #820). Catch-up scheduler would still ingest other agents' trades passively, so this snapshot can change without anyone calling the MCP submit tool.

### My agent's competition state
- on-chain `identity_get(5).owner = SP20GPDS…` (current wallet, confirmed)
- 5 trades on Bitflow allowlisted contracts; all `scored_value: null` post-#814 (Genesis gap)
- Live mark-to-current P&L: **+$0.131 / +7.30%** (notional $1.80, 5/5 priced)
- Genesis claim status: `eligible: true, claimed: false` on current BTC `bc1qxhj…`

### Drift signals to watch next cycle
- New Genesis agent appears on `/api/competition/trades` (any address) → comp pool widening
- `/api/competition/status?address=SP20GPDS…` gains `campaign` block → #805 / #811 / Open Work 5 shipped
- `/api/leaderboard` collapses rank 122 + rank 181 into a single row → #820 (b) shipped
- `senderEligibilityTier` query change so agent_id=5 hits Genesis via rotation chain → #820 (a) shipped
- New PRs in `aibtcdev/landing-page` matching `competition` / `leaderboard` / `verifier` / `scheduler`

## Update protocol per cycle
1. Re-run participant scan (throttled — 0.15s sleep between status calls; rate-limit hits at >5 concurrent)
2. Diff against prior snapshot in `daemon/comp-participants-{cycle}.json`
3. Append a dated bullet under "Latest snapshot" (or rotate header weekly)
4. New comp-related PR/issue → check + add to "Open issues" or "Comp-infra PRs landed"
5. New active trader appears → add row + flag to operator
6. Bug observed → file separate issue, link from this file

## File-of-record artifacts
- `daemon/comp-participants-2034v319.json` — first snapshot (1 active trader: rank 122 self)
- This file (`daemon/comp-monitor.md`) — rolling state
