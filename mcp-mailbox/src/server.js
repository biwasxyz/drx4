#!/usr/bin/env node
// mcp-mailbox — local stdio MCP server giving concurrent Claude Code sessions
// a shared SQLite-backed mailbox. Co-located tmux shifts (or any MCP client
// running on the same machine/filesystem) can post + read messages by role.
//
// DB path defaults to $MAILBOX_DB or ~/.mcp-mailbox/mailbox.db. Each tool call
// opens-writes-closes for crash-safety; SQLite's WAL mode lets many writers
// coexist without corruption. ACK is an explicit step, so a reader crash
// between read() and ack() won't drop the message — the next read returns it.

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { CallToolRequestSchema, ListToolsRequestSchema } from "@modelcontextprotocol/sdk/types.js";
import Database from "better-sqlite3";
import { homedir } from "node:os";
import { mkdirSync } from "node:fs";
import { dirname, resolve } from "node:path";

const DB_PATH = process.env.MAILBOX_DB || resolve(homedir(), ".mcp-mailbox", "mailbox.db");
mkdirSync(dirname(DB_PATH), { recursive: true });

const db = new Database(DB_PATH);
db.pragma("journal_mode = WAL");
db.pragma("synchronous = NORMAL");
db.exec(`
  CREATE TABLE IF NOT EXISTS messages (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    from_role  TEXT,
    to_role    TEXT NOT NULL,
    body       TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    acked_at   TEXT,
    acked_by   TEXT
  );
  CREATE INDEX IF NOT EXISTS idx_to_role_unacked
    ON messages(to_role, acked_at);
`);

const stmts = {
  insert: db.prepare(
    "INSERT INTO messages (from_role, to_role, body) VALUES (?, ?, ?) RETURNING id, created_at"
  ),
  readUnacked: db.prepare(
    "SELECT id, from_role, body, created_at FROM messages WHERE to_role = ? AND acked_at IS NULL ORDER BY id ASC LIMIT ?"
  ),
  readAll: db.prepare(
    "SELECT id, from_role, body, created_at, acked_at, acked_by FROM messages WHERE to_role = ? ORDER BY id DESC LIMIT ?"
  ),
  readSince: db.prepare(
    "SELECT id, from_role, body, created_at, acked_at FROM messages WHERE to_role = ? AND created_at > ? ORDER BY id ASC LIMIT ?"
  ),
  ack: db.prepare(
    "UPDATE messages SET acked_at = datetime('now'), acked_by = ? WHERE id = ? AND acked_at IS NULL RETURNING id, acked_at"
  ),
  stats: db.prepare(`
    SELECT to_role AS role,
           SUM(CASE WHEN acked_at IS NULL THEN 1 ELSE 0 END) AS unacked,
           COUNT(*) AS total
    FROM messages
    GROUP BY to_role
    ORDER BY unacked DESC, total DESC
  `),
  purgeAcked: db.prepare(
    "DELETE FROM messages WHERE acked_at IS NOT NULL AND acked_at < datetime('now', ?)"
  ),
};

const TOOLS = [
  {
    name: "mailbox_send",
    description:
      "Post a message to another role's mailbox. Receiver reads it with mailbox_read and must call mailbox_ack when processed. Use for inter-shift coordination (monitor→lead, lead→pitcher, etc). Body is free text, no size limit beyond what's sane.",
    inputSchema: {
      type: "object",
      required: ["to_role", "body"],
      properties: {
        to_role: { type: "string", description: "Role receiving the message (e.g. 'lead', 'pitcher', 'monitor', 'tracker')." },
        body: { type: "string", description: "Message content. Markdown is fine." },
        from_role: { type: "string", description: "Optional sender role for traceability." },
      },
    },
  },
  {
    name: "mailbox_read",
    description:
      "Read messages addressed to this role. By default returns only unacked messages in arrival order (oldest first). Use include_acked=true or since=<ISO timestamp> to broaden.",
    inputSchema: {
      type: "object",
      required: ["role"],
      properties: {
        role: { type: "string", description: "Role to read mail for." },
        include_acked: { type: "boolean", default: false, description: "If true, returns acked + unacked, newest first." },
        since: { type: "string", description: "If provided (ISO8601), returns messages created after this timestamp regardless of ack status." },
        limit: { type: "integer", default: 20, minimum: 1, maximum: 200 },
      },
    },
  },
  {
    name: "mailbox_ack",
    description:
      "Mark a message as processed. Idempotent — re-acking a message is a no-op. Call this after you've acted on the message; unacked messages keep coming back on mailbox_read.",
    inputSchema: {
      type: "object",
      required: ["id"],
      properties: {
        id: { type: "integer", description: "Message id returned by mailbox_read." },
        acked_by: { type: "string", description: "Optional role/identifier doing the ack, for audit." },
      },
    },
  },
  {
    name: "mailbox_stats",
    description:
      "Return per-role mailbox counts (unacked + total). Useful at cycle boot to see which roles have pending work without reading the messages themselves.",
    inputSchema: { type: "object", properties: {} },
  },
  {
    name: "mailbox_purge_acked",
    description:
      "Delete acked messages older than a retention window. Default 7 days. Housekeeping only — unacked messages are never touched.",
    inputSchema: {
      type: "object",
      properties: {
        older_than: { type: "string", default: "-7 days", description: "SQLite modifier, e.g. '-7 days', '-1 hour'." },
      },
    },
  },
];

const handlers = {
  mailbox_send({ to_role, body, from_role }) {
    const row = stmts.insert.get(from_role ?? null, to_role, body);
    return { ok: true, id: row.id, created_at: row.created_at, to_role, from_role: from_role ?? null };
  },
  mailbox_read({ role, include_acked = false, since, limit = 20 }) {
    const lim = Math.min(200, Math.max(1, limit));
    let rows;
    if (since) rows = stmts.readSince.all(role, since, lim);
    else if (include_acked) rows = stmts.readAll.all(role, lim);
    else rows = stmts.readUnacked.all(role, lim);
    return { role, count: rows.length, messages: rows };
  },
  mailbox_ack({ id, acked_by }) {
    const row = stmts.ack.get(acked_by ?? null, id);
    if (!row) return { ok: true, id, note: "already acked or id not found (idempotent)" };
    return { ok: true, id: row.id, acked_at: row.acked_at };
  },
  mailbox_stats() {
    return { roles: stmts.stats.all() };
  },
  mailbox_purge_acked({ older_than = "-7 days" } = {}) {
    const res = stmts.purgeAcked.run(older_than);
    return { ok: true, deleted: res.changes, older_than };
  },
};

const server = new Server(
  { name: "mcp-mailbox", version: "0.1.0" },
  { capabilities: { tools: {} } }
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({ tools: TOOLS }));

server.setRequestHandler(CallToolRequestSchema, async (req) => {
  const { name, arguments: args } = req.params;
  const handler = handlers[name];
  if (!handler) {
    return { content: [{ type: "text", text: JSON.stringify({ error: `unknown tool: ${name}` }) }], isError: true };
  }
  try {
    const result = handler(args ?? {});
    return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
  } catch (err) {
    return { content: [{ type: "text", text: JSON.stringify({ error: err.message, tool: name }) }], isError: true };
  }
});

const transport = new StdioServerTransport();
await server.connect(transport);
