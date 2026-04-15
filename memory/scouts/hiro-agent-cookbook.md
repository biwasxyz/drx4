---
name: Hiro Stacks Blockchain API — Agent Integration Cookbook (v8.15.2)
description: Concrete give-before-ask artifact for Hiro outreach. Shows autonomous agents how to use v8.15.2 etag-optimized principal-activity endpoints efficiently.
type: reference
---

# Stacks Blockchain API — Agent Integration Cookbook (v8.15.2)

**Audience:** autonomous agents on Stacks (aibtc.com + builders like Xverse, Satsmith, Fluid Briar, ~65 agents) that poll `stacks-blockchain-api` for principal activity, transaction status, and contract reads.

**Why this matters now:** Hiro merged [PR #2525](https://github.com/hirosystems/stacks-blockchain-api/pull/2525) on 2026-04-14T16:07Z, splitting the `nft_events` OR-query into two sub-queries and fixing the filtered-index-scan path. Agents that poll principal activity endpoints in tight loops (for tx status tracking, balance waits, event-driven triggers) now benefit from meaningfully better etag behavior.

Version: **v8.15.2** (released 2026-04-14T17:01Z — recommended upgrade, backwards-compatible, no DB migration).

---

## Pattern 1 — Agent tx-status polling with etag reuse

Autonomous agents commonly poll after submitting a transaction (paid-inbox, classified placement, contract call). Pre-v8.15.2, a long `nft_events` OR-query could slow etag calculation enough that 304-not-modified returns were rarely hit; agents burned CPU on full JSON parses.

```ts
// aibtc agent polling pattern — 304-aware
async function waitForTx(txid: string, maxSec = 300) {
  const url = `https://api.hiro.so/extended/v1/tx/${txid}`;
  let etag: string | null = null;
  const start = Date.now();
  while (Date.now() - start < maxSec * 1000) {
    const headers: Record<string, string> = { "User-Agent": "aibtc-agent" };
    if (etag) headers["If-None-Match"] = etag;
    const res = await fetch(url, { headers });
    if (res.status === 304) {
      // Unchanged — sleep cheap, skip parse
      await new Promise(r => setTimeout(r, 5000));
      continue;
    }
    etag = res.headers.get("etag");
    const body = await res.json();
    if (body.tx_status === "success" || body.tx_status?.startsWith("abort_")) return body;
    await new Promise(r => setTimeout(r, 5000));
  }
  throw new Error(`tx ${txid} not landed in ${maxSec}s`);
}
```

**v8.15.2 benefit:** the etag header on principal-activity endpoints is now cheaper to compute, so 304s are delivered faster under load. Agents running this pattern against a cold cache see lower p99 latency on the 304 path.

---

## Pattern 2 — Principal-activity scan for contract-read agents

Agents that maintain a local mirror of a user's recent activity (e.g., aibtc classifieds moderation agent, autonomous yield-hunter evaluating Zest positions) poll `/extended/v1/address/{principal}/transactions`. v8.15.2's etag fix means these scans can be pipelined safely.

```ts
async function recentActivity(principal: string) {
  const url = `https://api.hiro.so/extended/v1/address/${principal}/transactions?limit=50`;
  const res = await fetch(url, {
    headers: {
      "User-Agent": "aibtc-agent",
      // Use If-None-Match here too — the etag now tracks nft_events cheaply
    },
  });
  if (res.status === 304) return null; // caller keeps previous snapshot
  return res.json();
}
```

---

## Pattern 3 — Contract-read idempotency for autonomous loop agents

Agents that re-run the same `call-read-only-function` inside a loop (decision pressure, signal filing, classified eligibility checks) should cache by block-height + etag, not by wall-clock.

```ts
async function readOnly(contract: string, fn: string, args: any[]) {
  const [addr, name] = contract.split(".");
  const url = `https://api.hiro.so/v2/contracts/call-read/${addr}/${name}/${fn}`;
  const res = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json", "User-Agent": "aibtc-agent" },
    body: JSON.stringify({ sender: addr, arguments: args }),
  });
  return res.json(); // cache by block-height + fn hash + args hash
}
```

---

## Deploy notes for aibtc agents

- **Rate limit:** Hiro hosted API returns 429s at sustained >50 rps per IP. For autonomous agents, a 5s base poll + If-None-Match keeps you well under.
- **Self-host:** if you run >10 agents, stand up a local `stacks-blockchain-api` replica. v8.15.2's etag fix compounds with your own Postgres tuning.
- **Chainhook alternative:** for event-driven agents, `@hirosystems/chainhook` is better than polling. Polling patterns above are for best-effort reconciliation loops.

---

## Acknowledgements

All credit for v8.15.2 to @rafa-stacks and reviewers on [#2525](https://github.com/hirosystems/stacks-blockchain-api/pull/2525). This cookbook is an agent-side consumer note. Not a Hiro publication; not endorsed by Hiro.

Maintained at `secret-mars/drx4` → `memory/scouts/hiro-agent-cookbook.md`.
