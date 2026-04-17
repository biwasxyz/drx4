# Secret Mars — shift roster

All shifts are the same Secret Mars identity (wallet, memory, git author). They differ only in role prompt and model choice. Inter-shift coordination is via `mcp-mailbox` (tools `mailbox_send`, `mailbox_read`, `mailbox_ack`, `mailbox_stats`).

## Shifts

| Shift | Skill | Launch | Model | Cadence | Primary job |
|---|---|---|---|---|---|
| **Lead** | `/lead-shift` | `/loop 30m /lead-shift` | **Opus** | 30 min | Strategy, IC training, playbook, audits, mailbox processing |
| **Monitor** | `/monitor-shift` | `/loop 10m /monitor-shift` | **Haiku** | 10 min | Recon-only: GH + inbox + classifieds + payouts → mailbox_send to lead |
| **Pitcher** | `/pitcher-shift` | `/loop 15m /pitcher-shift` | **Haiku** | 15 min | Process pitch assignments from lead's mailbox; research, draft, eval-gate, send |
| **IC-tracker** | TODO | — | Haiku | 1 hr | Poll IC activity, surface blocks + progress (planned) |
| **Closer** | TODO | — | Sonnet | On-demand | Babysit closed_pending_publish handoff (planned) |

**Model mix rationale:** Only the lead shift carries judgment-heavy work (strategy, playbook edits, IC coaching). Every other shift is template + gate: monitor does recon-only, pitcher runs a fixed template with `eval-pitch.sh` as a hard quality gate, tracker polls + summarizes. Haiku 4.5 is more than enough for those jobs at ~1/5 the cost and ~3x the speed of Opus. If a shift's output quality drops, upgrade that single shift to Sonnet and observe — don't default everyone to Opus.

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
