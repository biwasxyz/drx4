# Closure framing for lp#651 — pre-staged for the cycle after lp#743 merges
# v259 scout — addresses the open scope question biwasxyz raised at 02:31Z + my v241 follow-up

## Context

biwasxyz's 02:31Z comment on lp#651 asked whoabuddy: keep `/dashboard` (per-agent portfolio) as a distinct page alongside `/leaderboard`, or scope it down / close?

My v241 issuecomment-4426889296 surfaced 3 drifts:
1. Route identifier drift: PR body + 02:31Z comment refer to `/dashboard`/`/api/dashboard`; code ships `/leaderboard` + `/api/leaderboard/portfolio`
2. File-level collision with #743 on `app/leaderboard/page.tsx`
3. Schema drift (pagination + USD-total sort claims) vs shipped self-doc

Post-#743-merge, the situation simplifies:
- `/leaderboard` page is now owned by #743's MCP-trade-count + USD-volume design
- The "portfolio" surface (per-agent balance + USD totals) from #651 is now functionally superseded
- The shared file `app/leaderboard/page.tsx` is now the #743-design

## Trigger conditions
- lp#743 MERGED to main
- aibtc.com/leaderboard serves #743's design

## Draft body (run after merge)

> **Suggesting close-as-superseded on this PR.**
>
> Now that #743 has merged + deployed to aibtc.com:
> - `/leaderboard` serves the MCP-trade-count + USD-volume design from #743
> - `app/leaderboard/page.tsx` is now wired to the SchedulerDO + KV-cached Tenero prices path
> - The "portfolio" surface (per-agent balance + USD totals from `lib/balances/`) that this PR introduced has no remaining product slot — the comp leaderboard is "the leaderboard, period" per biwasxyz's [02:31Z framing](#issuecomment-4426860600)
>
> Useful pieces that **could** be salvaged in a follow-up PR if there's still a portfolio-view use case:
> - `lib/balances/{types, constants, fetch, prices, snapshot, index}.ts` modules (BTC L1 + Stacks balances + CoinGecko prices) — these are independent of the `/leaderboard` page and useful for any future per-agent portfolio surface
> - The dashboard's empty-state UX (showing "—" with allPriced=false) — same shape #743 adopted, so already preserved
>
> If/when there's a per-agent profile-page that wants to show portfolio breakdown, this PR's balance modules become a clean reference. But as a standalone `/dashboard` page they're no longer needed.
>
> cc @whoabuddy as umbrella (#652) owner.

## Decision branches at scout-run time

**A. lp#743 merged + deployed successfully:** Ship the body above on lp#651.

**B. lp#743 merged but rollback required (#772-shape v4 hotfix):** Hold — situation reverted. Don't close #651 yet.

**C. lp#743 merged + deployed but a different scope decision emerges:** Adapt body. Maybe partial-keep (e.g. balance modules extracted to follow-up PR + close #651 once that lands).

**D. lp#743 NOT merged within 48h of v259 scout staging (2026-05-14T09:35Z):** Re-evaluate — may need to nudge instead of close.

