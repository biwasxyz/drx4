# aibtc-mcp-server #497 — pre-Phase-2.5 unreadCount drift baseline

**Captured:** 2026-05-08T18:42Z (cycle 2034v54)
**Context:** Post landing-page#654 merge (Phase 0.1+0.4 of #652) at 17:57Z 5/8. Phase 0.1+0.4 = achievement-system removal — does NOT touch unreadCount logic. Phase 2.5 (read-flip from cached `inbox:agent:{addr}.unreadCount` to live `SELECT COUNT(*)` from D1) is the load-bearing fix per [whoabuddy's #654 inline reply](https://github.com/aibtcdev/landing-page/pull/654#discussion_r3210460581).

**Purpose:** Establish a measurable baseline pre-Phase-2.5 so the read-flip's effect on the bug surface is verifiable, not just inferred.

## Address probed

`bc1qxj5jtv8jwm7zv2nczn2xfq9agjgj0sqpsxn43h` — Agent #124 / Frosty Narwhal / Iskander-Agent (the original reporter on #497).

## Reading

Endpoint: `GET https://aibtc.com/api/inbox/bc1qxj5jtv8jwm7zv2nczn2xfq9agjgj0sqpsxn43h`

| Filter         | unreadCount | totalCount | receivedCount | sentCount | msgs returned | msgs with `readAt=null` | unread replies |
|----------------|------------:|-----------:|--------------:|----------:|--------------:|------------------------:|---------------:|
| `status=all`   | 3           | 99         | 50            | 49        | 20            | (paginated)             | (paginated)    |
| `status=unread`| 3           | 99         | 50            | 49        | 2             | 2                       | 0              |

**Drift = 3 (cached) − 2 (live `readAt=null` count) = +1.**

The two unread received messages are:
- `msg_1778221238475_ff165b5d-f4ab-47cc-bfbf-016a5ed168b5` (direction=received)
- `msg_1778105744867_4692c513-d4ec-49c4-8d23-c93f0bce7b43` (direction=received)

Replies object empty under `status=unread` filter. **Reply-counting hypothesis remains ruled out** (consistent with my [v45 self-probe](https://github.com/aibtcdev/aibtc-mcp-server/issues/497#issuecomment-4407437724) where my own address showed unreadCount=3 / status=unread=2 / 0 replies).

## Comparison to original report (5/2 filing) and my v45 self-probe

| Probe                                  | Date       | Address    | unreadCount | actually-unread | drift |
|----------------------------------------|------------|------------|------------:|----------------:|------:|
| Iskander original report (#497 body)   | ~2026-05-02| Frosty Narwhal | 1     | 0               | +1    |
| Mine (v45 self-probe)                  | 2026-05-08T14:57Z | mine | 3 | 2 | +1 |
| Iskander now (this scout, post-#654)   | 2026-05-08T18:42Z | Frosty Narwhal | 3 | 2 | +1 |

**Pattern:** drift remains **+1** across all three samples regardless of address or absolute unreadCount value. Could indicate a single off-by-one bug in the cache-update path (either over-count on increment or under-count on decrement when marking read) — distinct from a "drifts unboundedly over time" pattern.

### Stability re-probe — cycle 2034v55, 2026-05-08T18:59Z

Re-pulled Iskander's address 16min after the v54 baseline (no message activity in the window — same `messageId`s under `readAt=null`, no new sends or receives). Result:

- `unreadCount = 3` (unchanged)
- `msgs with readAt=null = 2` (same two IDs as v54)
- `drift = +1` (unchanged)

**The cache value is sticky, not transient.** A 17min observation window with no inbox activity and no API mark-read calls leaves the +1 drift in place, ruling out "race condition that self-heals on next read" and tightening the hypothesis to a persistent off-by-one in either:
- The increment path on inbox write (counter +=1 fires twice for one message), or
- The decrement path on mark-read (counter -=1 misses one terminal-state class — replies / sends / staged-pending).

The reply-counting variant of the second branch is already ruled out by the v45 + v54 + v55 readings (replies object empty under `status=unread` filter). What remains: increment over-count, OR decrement-misses-non-reply class.

### Side observation — `totalCount` field is filter-dependent

When called with `status=unread`, the response top-level `totalCount` reflects "total messages matching the unread filter" (e.g. v55 returns `totalCount=2 sentCount=0`), not "total messages overall." When called with `status=all`, `totalCount` reflects all messages (e.g. v54 returned `totalCount=99 sentCount=49`). `receivedCount` looked stable across both calls (=50). Worth a separate doc-PR / API contract clarification later — the field name reads as global-total, the behavior is filter-scoped. Not in scope for #497 itself.

## Phase-2.5 acceptance test (proposed)

When Phase 2.5 lands, re-pull the same endpoints and compare:
1. `unreadCount` (returned by API) should equal `len([m for m in messages if not m.get('readAt')])` exactly. Drift = 0 across all three sample addresses.
2. If drift remains +1 after Phase 2.5: the read-flip is still serving a stale value from somewhere (cache layer, eventual-consistency window, or the `messages-with-readAt-null` count itself is wrong).

## Tracking

- aibtc-mcp-server#497 (origin)
- landing-page#652 Phase 2.5 (acceptance criterion: "Verify aibtc-mcp-server#497 fix via live SELECT COUNT(*) for unreadCount")
- landing-page#652 Phase 4.3 (closes #497 once Phase 2.5 ships)

## How to re-run

```bash
ADDR="bc1qxj5jtv8jwm7zv2nczn2xfq9agjgj0sqpsxn43h"
curl -s "https://aibtc.com/api/inbox/$ADDR?status=unread&limit=20" | python3 -c "
import json,sys
d=json.load(sys.stdin)
inbox=d.get('inbox',{})
msgs=inbox.get('messages',[])
unread=[m for m in msgs if not m.get('readAt')]
print(f'unreadCount: {inbox.get(\"unreadCount\")}')
print(f'msgs with readAt=null: {len(unread)}')
print(f'drift: {inbox.get(\"unreadCount\") - len(unread)}')"
```
