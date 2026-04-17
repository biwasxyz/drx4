#!/usr/bin/env node
// Smoke test: spawn the server as a stdio subprocess and exercise each tool.
// Exits 0 on success, 1 on any assertion or protocol failure.

import { spawn } from "node:child_process";
import { resolve, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { mkdtempSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";

const __dirname = dirname(fileURLToPath(import.meta.url));
const SERVER = resolve(__dirname, "server.js");

const tmp = mkdtempSync(resolve(tmpdir(), "mcp-mailbox-test-"));
const DB = resolve(tmp, "mailbox.db");

const child = spawn("node", [SERVER], {
  env: { ...process.env, MAILBOX_DB: DB },
  stdio: ["pipe", "pipe", "inherit"],
});

let nextId = 1;
const pending = new Map();
let buf = "";

child.stdout.on("data", (chunk) => {
  buf += chunk.toString("utf8");
  let idx;
  while ((idx = buf.indexOf("\n")) >= 0) {
    const line = buf.slice(0, idx);
    buf = buf.slice(idx + 1);
    if (!line.trim()) continue;
    const msg = JSON.parse(line);
    if (msg.id !== undefined && pending.has(msg.id)) {
      pending.get(msg.id)(msg);
      pending.delete(msg.id);
    }
  }
});

function call(method, params) {
  return new Promise((ok, fail) => {
    const id = nextId++;
    pending.set(id, (msg) => (msg.error ? fail(new Error(JSON.stringify(msg.error))) : ok(msg.result)));
    child.stdin.write(JSON.stringify({ jsonrpc: "2.0", id, method, params }) + "\n");
    setTimeout(() => pending.has(id) && fail(new Error(`timeout: ${method}`)), 5000);
  });
}

function assert(cond, msg) {
  if (!cond) {
    console.error("ASSERT FAIL:", msg);
    cleanup(1);
  }
}

function cleanup(code) {
  child.kill("SIGTERM");
  try { rmSync(tmp, { recursive: true, force: true }); } catch {}
  process.exit(code);
}

async function run() {
  await call("initialize", { protocolVersion: "2024-11-05", capabilities: {}, clientInfo: { name: "smoketest", version: "0" } });

  // 1. list tools
  const list = await call("tools/list", {});
  assert(list.tools.length === 5, `expected 5 tools, got ${list.tools.length}`);
  const names = list.tools.map((t) => t.name).sort();
  assert(JSON.stringify(names) === JSON.stringify([
    "mailbox_ack", "mailbox_purge_acked", "mailbox_read", "mailbox_send", "mailbox_stats"
  ]), `tool names off: ${names}`);

  // 2. send a message
  const sent = JSON.parse((await call("tools/call", {
    name: "mailbox_send",
    arguments: { to_role: "pitcher", body: "pitch p010 Arkadiko", from_role: "lead" }
  })).content[0].text);
  assert(sent.ok === true && sent.id > 0, `send failed: ${JSON.stringify(sent)}`);

  // 3. read as pitcher
  const read = JSON.parse((await call("tools/call", {
    name: "mailbox_read",
    arguments: { role: "pitcher" }
  })).content[0].text);
  assert(read.count === 1 && read.messages[0].body === "pitch p010 Arkadiko", `read wrong: ${JSON.stringify(read)}`);

  // 4. ack
  const ack = JSON.parse((await call("tools/call", {
    name: "mailbox_ack",
    arguments: { id: sent.id, acked_by: "pitcher" }
  })).content[0].text);
  assert(ack.ok === true, `ack failed: ${JSON.stringify(ack)}`);

  // 5. read again — should be empty (acked messages hidden by default)
  const reread = JSON.parse((await call("tools/call", {
    name: "mailbox_read",
    arguments: { role: "pitcher" }
  })).content[0].text);
  assert(reread.count === 0, `reread should be empty after ack: ${JSON.stringify(reread)}`);

  // 6. read with include_acked
  const all = JSON.parse((await call("tools/call", {
    name: "mailbox_read",
    arguments: { role: "pitcher", include_acked: true }
  })).content[0].text);
  assert(all.count === 1 && all.messages[0].acked_at !== null, `include_acked wrong: ${JSON.stringify(all)}`);

  // 7. ack idempotent
  const ack2 = JSON.parse((await call("tools/call", {
    name: "mailbox_ack",
    arguments: { id: sent.id }
  })).content[0].text);
  assert(ack2.ok === true, `idempotent ack failed: ${JSON.stringify(ack2)}`);

  // 8. stats
  const stats = JSON.parse((await call("tools/call", {
    name: "mailbox_stats",
    arguments: {}
  })).content[0].text);
  assert(stats.roles.length === 1 && stats.roles[0].role === "pitcher" && stats.roles[0].total === 1 && stats.roles[0].unacked === 0,
    `stats wrong: ${JSON.stringify(stats)}`);

  // 9. unknown tool → isError
  const bad = await call("tools/call", { name: "mailbox_nope", arguments: {} });
  assert(bad.isError === true, `unknown tool should error: ${JSON.stringify(bad)}`);

  console.log("OK — 9/9 assertions pass");
  cleanup(0);
}

run().catch((err) => {
  console.error("test failed:", err.message);
  cleanup(1);
});
