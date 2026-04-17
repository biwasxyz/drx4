# Secret Mars — shift roster

All shifts are the same Secret Mars identity (wallet, memory, git author). They differ only in role prompt and model choice. Inter-shift coordination is via `mcp-mailbox` (tools `mailbox_send`, `mailbox_read`, `mailbox_ack`, `mailbox_stats`).

## Shifts

| Shift | Skill | Launch | Model | Cadence | Primary job |
|---|---|---|---|---|---|
| **Lead** | `/lead-shift` | `/loop 30m /lead-shift` | **Opus** | 30 min | **Mailbox-first.** Reads monitor's findings, decides, acts directly (replies/comments/board/audits/playbook) or routes to pitcher. No self-polling. |
| **Monitor** | `/monitor-shift` | `/loop 10m /monitor-shift` | **Haiku** | 10 min | **All polling.** Inbox, GH notifs + mentions, classifieds, payouts, paid-send replies, IC threads #475/#477, IC inbox convos, watchlist deltas. Mailbox-sends findings to lead. |
| **Pitcher** | `/pitcher-shift` | `/loop 15m /pitcher-shift` | **Haiku** | 15 min | Primary: `PITCH` assignments from lead's mailbox. Fallback when empty: runs 7-touch cadence follow-ups from pipeline so it doesn't starve. |
| **IC-tracker** | TODO | — | Haiku | 1 hr | Deeper IC activity polling (planned) |
| **Closer** | TODO | — | Sonnet | On-demand | Babysit closed_pending_publish handoff (planned) |

**Model mix rationale:** Only lead carries judgment-heavy work. Monitor does recon only, pitcher runs a fixed template with `eval-pitch.sh` as hard gate. Haiku 4.5 is enough for both at ~1/5 cost and ~3x speed of Opus. If a shift's output quality drops, upgrade that single shift to Sonnet and observe; don't default everyone to Opus.

**Rebalance history (2026-04-17):** first run showed lead doing ~95% of work because it was duplicating monitor's polling. Moved all polling surfaces into monitor (paid-send replies, IC threads, IC inbox convos, watchlist deltas). Lead is now mailbox-first; pitcher got cadence-follow-up fallback so it works between cold-pitch assignments. Expected new split: lead ~40%, monitor ~30%, pitcher ~30%.

Legacy single-shift loop at `.claude/loop.md` still works if no other shifts running — falls back to doing all phases in one session.

## Launch recipe (tmux)

```bash
# Pane 1: lead (replaces your current session)
cd /home/mars/drx4 && claude --model opus
# then inside: /loop 30m /lead-shift

# Pane 2: monitor
cd /home/mars/drx4 && claude --model haiku
# then inside: /loop 10m /monitor-shift

# Pane 3: pitcher (only start once you have pitch assignments queued)
cd /home/mars/drx4 && claude --model haiku
# then inside: /loop 15m /pitcher-shift
```

Each pane is a separate Claude Code process, each spawns its own `mcp-mailbox` stdio subprocess pointing at the same SQLite DB at `daemon/mailbox.db`. SQLite WAL mode handles concurrent writes.

## Ownership (single-writer per file)

The three shifts share `daemon/` state but each owns specific files:

| File | Owner |
|---|---|
| `STATE.md`, `health.json`, `NORTH_STAR.md`, `sales-pipeline-active.json`, `watchlist.json`, `ic-activity.log`, all of `memory/` | **lead** |
| `monitor-state.json` | **monitor** |
| `pitcher-outputs.jsonl` | **pitcher** |
| `outputs.log` | append-only, any shift can append |
| `mailbox.db` | mcp-mailbox MCP (don't edit directly; use tools) |

**Never write outside your column.** If another shift's file needs changing, `mailbox_send` to its owner.

## Starting small

Start with 2 shifts: **lead + monitor**. Run both for a day, verify mailbox messages flow cleanly, check commit log for single-writer discipline. Only add pitcher once the lead↔monitor coordination is boring.

## Debugging

- **"Shift's mailbox tool not showing up"** — confirm session-start `.mcp.json` loaded; run `/mcp` in Claude Code to list servers.
- **"Two shifts clobbered the same file"** — check ownership table above. The lower-privilege shift should `mailbox_send` to the owner instead of editing.
- **"Mailbox DB locked"** — WAL mode should prevent this. If it happens, check `MAILBOX_DB` env points to the same file across shifts + that filesystem supports WAL (ext4/xfs yes, NFS no).
- **"Messages piling up unacked"** — one shift has died or is stuck. `mailbox_stats` shows the backlog by role; restart the stuck shift.
