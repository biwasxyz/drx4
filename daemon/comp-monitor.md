# Trading Competition — Live Monitor

> Operator directive cycle 2034v319 (2026-05-13T16:30Z): trading comp announces today (Rules of Play #815 filed at 11:05Z); monitor for bugs, track participants, surface findings each cycle.

## Latest snapshot — 2034v321 (2026-05-13T17:22Z)

**Comp official start:** **2026-05-13T19:30:00Z** (per #819's `COMP_START_TIMESTAMP = 1778700600`). T-2.1h.

**v321 deltas:**
- **lp#823 filed 17:08Z (mine, umbrella issue)** — leaderboard eligibility filter + pre-launch cleanup. Label `trading-competition-rule` requested but I lack write permission (filed without).
- **lp#824 OPEN (mine, PR-A)** — `fix(leaderboard): filter SSR aggregate to Genesis-only senders (#823 Part 1)`. INNER JOIN agents + EXISTS-on-claims, mirrors `senderEligibilityTier` byte-for-byte. `LEADERBOARD_AGGREGATE_SQL` extracted as exported const. 6-test regression fixture pinning predicate shape (v137 pattern). CI: Lint + Test SUCCESS, Build SKIPPED. No reviews yet.
- **lp#825 OPEN (mine, PR-B)** — `feat(competition): clean pre-launch swaps so 19:30Z renders empty (#823 Part 2)`. `migrations/011_competition_clean_pre_launch.sql` with single DELETE statement. Boundary at 1778700600 preserved (matches verifier `>=`). Idempotent (sqlite-tested locally). Forward-only. CI: Lint + Test IN_PROGRESS at boot.
- **arc0btc replied on lp#822** at 17:01Z — substantive agent-side review. **Convergence with my 17:01:09Z comment (essentially simultaneous):**
  - Grace window 60min default (we both agree)
  - `priced_trade_count >= 3` for return-champion floor (we both agree)
  - **Divergence:** arc says `min_volume_usd = $10` (mine was $50). arc's reasoning: "low enough not to exclude small-balance agents" — defer to arc.
  - **arc-only points:** `pnl_percent` NULL guard for zero `volume_usd`; `competition_round_price_snapshots.source` enum doc; `competition_rewards.created_at` missing; recompute should also match `priced_trade_count` not just dollars; `partially_paid` round-status edge case
  - **My-only points:** `competition_rewards.erc8004_agent_id` for #820 wallet-rotation; `result_json` typing per v137; lp#794 SchedulerDO upstream cross-link
- Operator (Telegram) confirmed PR direction at 17:09Z; both filed within 15 min (PR-A 17:15Z, PR-B 17:18Z)
- Re-scan at 17:22Z: still **22 distinct senders** on leaderboard (3 with agent_id: 5/me, 349, 355; 19 without). No movement. Genesis agents top-3 still 0 trades.

## Earlier snapshot — 2034v320b (2026-05-13T17:00Z)

**Comp official start:** **2026-05-13T19:30:00Z** (per #819's `COMP_START_TIMESTAMP = 1778700600`, merged 16:33Z). T-2h30m as of this update.

**v320b deltas (post-operator-ping):**
- **lp#821 MERGED 16:54:00Z by whoabuddy** — 4min after my APPROVE; arc APPROVE landed 16:54:02Z (2sec after merge — single-APPROVE merge cadence).
- **lp#822 OPEN — whoabuddy** — `Trading Competition: weekly snapshot finalization and reward accounting`. Defines `competition_rounds` + `competition_round_price_snapshots` + `competition_round_results` + `competition_rewards` schema. Live drifting Unrealized P&L during week, frozen-snapshot at close, immutable round results, payout-status tracking. **My substantive 5-point comment shipped 16:59Z (issuecomment-4443420731):**
  1. `grace_ends_at` minimum tied to SchedulerDO 15min cron cadence — suggested 60min default
  2. `competition_rewards.erc8004_agent_id` column to handle wallet rotation per #820 (resolve payout target via `identity_get` if needed)
  3. Anti-gaming floors for return category — `min_volume_usd ≥ $50`, `min_priced_trade_count ≥ 3` as starting point
  4. `result_json` typing per v137 codified pattern
  5. Recompute-from-source acceptance test (vitest seed swaps + frozen prices + assert byte-equality)
  - Cross-linked to #821 (merged) + #794 (mine, upstream of price-snapshot step)
  - Offered take-a-stab on (a) rounds+price_snapshots migrations OR (b) rewards.erc8004_agent_id OR (c) #794 SchedulerDO fix; awaiting whoabuddy direction
- **Operator ping on Telegram 16:59Z** — confirmed #821 merge + #822 filed + plans for scheduler updates on address balances + asset prices in landing-page. My reply (msg 263) summarized #821 review, framed #822 contributions, asked priority direction.

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

## Latest snapshot — 2034v323 (2026-05-13T17:58Z)

**T-1.5h to launch.** Two PRs awaiting whoabuddy merge action:
- **lp#825** (mine, DELETE migration) — arc APPROVE 17:26Z + whoabuddy APPROVE 17:54Z; deploy-note from whoabuddy: "run migration apply before launch smoke; verify SELECT COUNT(*) FROM swaps WHERE burn_block_time < 1778700600 returns 0"
- **lp#827** (whoabuddy, predicate tightening) — arc APPROVE 17:46Z + my APPROVE 17:42Z; my [suggestion] inline-comment landed in 6b136db verbatim; copilot's 2 findings (scheduler doc + tx_status wording) both fixed; CI green post-57666cd lint fix

**v323 correction to v320c snapshot:** the 19 ungated senders aren't "Level-1-only" — they're **Level-2-Genesis but didn't mint the NFT**. Verified via `/api/verify/SP13A04RMTAWHGNEQE…` which returns `level: 2, levelName: Genesis, erc8004AgentId: null`. Same fix outcome under #827 (filtered out), cleaner narrative.

**Genesis-with-NFT senders (will remain visible post-#827 deploy):**
- agent_id=5 (mine, SP20GPDS… current + SP4DXVEC… retired — duplicate-row case per #820)
- agent_id=349 (SP3GRS0NF1GEBNGC5JCW53PD7PFW7BC4MDMA3M8F7)
- agent_id=355 (SPHWQHPHTR30Z5XWRMJC4S36XDSWKWV4DHCJPXJ9)

**v323 ack on #827 thread:** confirmed fixup landing + corrected sender-category narrative; refreshed `daemon/comp-participants-2034v323.json` for any post-launch retro.

## Latest snapshot — 2034v324 (2026-05-13T18:11Z) — LAUNCH READY

**T-1.3h to 19:30Z launch.**

✅ **lp#825 MERGED 17:56:13Z** by whoabuddy (DELETE migration applied)
✅ **lp#827 MERGED 18:00:31Z** by whoabuddy (3-step predicate enforced)
✅ Release 1.42.0 auto-merged 17:58Z; release-please queued 1.42.1 (#828) for the #827 deltas
✅ lp#823 umbrella auto-closed by #825 merge

**Empirical validation @ 18:11Z (post-deploy, all 4 surfaces aligned):**
- `/leaderboard` page render: **0 distinct sender addresses** (was 22 pre-deploy)
- `/api/competition/status?address=SP20GPDS…` (mine, NFT) → `trade_count: 0`
- `/api/competition/status?address=SP13A04RMTAWHGNEQE…` (Crafty Frog, no NFT) → `trade_count: 0` + new predicate would reject future swaps as `sender_not_registered`
- `/llms.txt` competition Eligibility section deployed with 3-step framing matching #815 §1 verbatim

**Total my-PRs cycle this comp launch (v319 → v324, ~1.7h):**
- 4 issues: #805 (cross-link), #820 (wallet-rotation gap), #823 (umbrella, closed-by-merge), follow-up comment on #815
- 3 PRs: #824 (Genesis SSR filter, MERGED), #825 (DELETE migration, MERGED), #826 (eligibility doc, closed-as-superseded by #827)
- 4 substantive reviews: #821 (source filter, MERGED), #822 (snapshot finalization design), #827 (predicate tightening, MERGED), #824 follow-up ack
- 3 participant snapshots: v319, v320c, v323

**Next watch surface:**
- Re-scan participants at 19:00Z + 19:30Z + 20:00Z to capture pre-launch + launch + first-hour participation
- Watch lp#828 (release-please 1.42.1) merge cadence
- Watch for any #815 update by biwasxyz incorporating my suggested "as-of #827" line
- Watch for #822 weekly-snapshot direction from whoabuddy
