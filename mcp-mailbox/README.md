# mcp-mailbox

Local stdio MCP server that gives co-located Claude Code (or any MCP client) sessions a shared SQLite-backed mailbox. If you run multiple agent "shifts" in tmux panes on the same VPS, this lets them message each other by role.

## Why

Claude Code has no native IPC between running sessions. You can either:

- Use file queues in a shared repo (works, DIY)
- Run a local MCP server exposing mailbox tools (typed, auditable, this)
- Wait for Anthropic to ship something (unknown)

This is the middle path — a small, single-user-trust, no-auth daemon that treats the local filesystem as the coordination layer.

## Install (local dev)

```bash
cd mcp-mailbox
npm install
```

Register with Claude Code by adding to your project `.mcp.json`:

```json
{
  "mcpServers": {
    "mailbox": {
      "command": "node",
      "args": ["/absolute/path/to/mcp-mailbox/src/server.js"]
    }
  }
}
```

Or, once published to npm (planned):

```json
{
  "mcpServers": {
    "mailbox": {
      "command": "npx",
      "args": ["-y", "mcp-mailbox"]
    }
  }
}
```

DB location defaults to `~/.mcp-mailbox/mailbox.db`. Override with `MAILBOX_DB=/some/path/mailbox.db` in the server's `env` block.

## Tools

| Tool | Purpose |
|---|---|
| `mailbox_send` | Post message to a role's mailbox. |
| `mailbox_read` | Read unacked (default) or all messages for a role. |
| `mailbox_ack` | Mark a message processed. Idempotent. |
| `mailbox_stats` | Per-role counts of unacked + total. |
| `mailbox_purge_acked` | Housekeeping: delete acked messages older than N days. |

## Design

- **SQLite in WAL mode.** Multiple processes (shifts) can write simultaneously without corruption. Each MCP call opens the shared DB via its own stdio server process.
- **Explicit ack.** A reader crash between `mailbox_read` and `mailbox_ack` does NOT lose the message. Unacked messages keep surfacing on subsequent reads.
- **Roles are strings.** No registration, no enforcement. Convention over schema: `lead`, `pitcher`, `monitor`, `tracker`, `closer`, or whatever your system decides.
- **No auth.** Single-user, filesystem-scoped. If that's not your threat model, wrap with access control at the FS layer.

## Usage pattern (tmux shifts)

```
# Pane 1: lead shift
claude --model opus /loop 30m .claude/loops/lead.md

# Pane 2: monitor shift (10-min Haiku sweep)
claude --model haiku /loop 10m .claude/loops/monitor.md

# Pane 3: pitcher shift (triggered by queue)
claude --model sonnet /loop 15m .claude/loops/pitcher.md
```

Each loop prompt starts with:

```
1. Call mailbox_read(role: "<my-role>") to fetch inbound tasks from peer shifts.
2. For each message, execute and then mailbox_ack(id).
3. At end of cycle, if I have follow-ups for other roles, mailbox_send(to_role, body).
```

No files clobber because each shift owns its queue via role name; no races because SQLite serialises writes.

## Status

v0.1.0 — works locally, not yet on npm. Planned publish as `mcp-mailbox` once real multi-shift setup exercises it in tmux.
