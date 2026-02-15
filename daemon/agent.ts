/**
 * Secret Mars Autonomous Agent Daemon
 *
 * A lightweight scheduler that dispatches actions to Claude CLI,
 * which has access to aibtc MCP tools for signing, check-ins, and inbox.
 *
 * Actions every 5 minutes:
 * 1. Check-in to aibtc.com (BIP-137 signed via MCP)
 * 2. Poll inbox for new messages
 * 3. Process tasks from new messages
 * 4. Reply to messages
 * 5. Handle paid attention
 */

import {
  writeFileSync,
  readFileSync,
  existsSync,
  mkdirSync,
  appendFileSync,
  unlinkSync,
} from "fs";
import { join } from "path";

// --- Configuration ---

const BASE_DIR = join(import.meta.dir, "..");
const PID_FILE = join(import.meta.dir, "agent.pid");
const STATE_FILE = join(import.meta.dir, "state.json");
const LOG_DIR = join(BASE_DIR, "logs");
const INTERVAL = 5 * 60 * 1000; // 5 minutes

// --- State ---

interface DaemonState {
  startedAt: string;
  lastTick: string | null;
  tickCount: number;
  errors: number;
  sessionId: string | null; // Claude session ID for --resume
}

function loadState(): DaemonState {
  if (existsSync(STATE_FILE)) {
    return JSON.parse(readFileSync(STATE_FILE, "utf-8"));
  }
  return {
    startedAt: new Date().toISOString(),
    lastTick: null,
    tickCount: 0,
    errors: 0,
    sessionId: null,
  };
}

function saveState(state: DaemonState) {
  writeFileSync(STATE_FILE, JSON.stringify(state, null, 2));
}

// --- Logging ---

function log(level: "INFO" | "WARN" | "ERROR", msg: string) {
  const timestamp = new Date().toISOString();
  const line = `[${timestamp}] [${level}] ${msg}`;
  console.log(line);

  if (!existsSync(LOG_DIR)) mkdirSync(LOG_DIR, { recursive: true });

  const date = timestamp.split("T")[0];
  const logFile = join(LOG_DIR, `${date}.log`);
  appendFileSync(logFile, line + "\n");
}

// --- Claude CLI Runner ---

async function runClaude(
  prompt: string,
  sessionId: string | null,
  timeoutMs = 120_000
): Promise<{ output: string; sessionId: string | null }> {
  try {
    const args = [
      "claude",
      "--print",
      "--dangerously-skip-permissions",
      "--output-format",
      "json",
    ];

    // Resume existing session if we have one
    if (sessionId) {
      args.push("--resume", sessionId);
    }

    args.push("-p", prompt);

    const proc = Bun.spawn(args, {
      cwd: BASE_DIR,
      stdout: "pipe",
      stderr: "pipe",
      env: {
        ...process.env,
        CLAUDECODE: undefined, // Allow nested claude invocations
      },
    });

    const timer = setTimeout(() => proc.kill(), timeoutMs);
    const rawOutput = await new Response(proc.stdout).text();
    const exitCode = await proc.exited;
    clearTimeout(timer);

    if (exitCode !== 0) {
      const stderr = await new Response(proc.stderr).text();
      log("WARN", `Claude exited ${exitCode}: ${stderr.slice(0, 200)}`);
    }

    // Parse JSON output to extract session ID and result
    let output = rawOutput.trim();
    let newSessionId = sessionId;

    try {
      const json = JSON.parse(output);
      // --output-format json returns { result, session_id, ... }
      if (json.session_id) {
        newSessionId = json.session_id;
      }
      output = json.result || output;
    } catch {
      // If JSON parse fails, just use raw output
    }

    return { output, sessionId: newSessionId };
  } catch (error) {
    log("ERROR", `Claude spawn error: ${error}`);
    return { output: "", sessionId };
  }
}

// --- Tick Actions ---

// First tick: full context, load tools, read memory
const INIT_PROMPT = `You are Secret Mars, an autonomous AI agent. Your workspace is /Users/biwas/drx4.
You are running as a persistent background daemon. This session will be RESUMED for future ticks,
so everything you learn here carries forward. You have FULL file access (Read, Write, Edit tools).

## SETUP (first tick only)

1. LOAD MCP TOOLS: The aibtc tools are deferred. Use ToolSearch:
   - Query "+aibtc wallet unlock" to load wallet tools
   - Query "+aibtc sign message" to load signing tools
   - Query "+aibtc x402 endpoint" to load x402 tools

2. READ YOUR MEMORY: Use the Read tool to read:
   - /Users/biwas/drx4/CLAUDE.md (your boot config — follow all rules here)
   - /Users/biwas/drx4/memory/learnings.md (accumulated knowledge)
   - /Users/biwas/drx4/daemon/processed.json (message IDs already replied to)

3. UNLOCK WALLET: Use mcp__aibtc__wallet_unlock (name: "secret mars name", password: "password123")

Now perform your first tick (see TICK ACTIONS below).

## TICK ACTIONS (every tick)

1. CHECK-IN: Sign and submit:
   - mcp__aibtc__btc_sign_message: "AIBTC Check-In | {current ISO timestamp}"
   - mcp__aibtc__execute_x402_endpoint: apiUrl "https://aibtc.com", path "/api/paid-attention", method POST, data: {"type": "check-in", "signature": "<base64>", "timestamp": "<same>"}

2. CHECK INBOX: mcp__aibtc__execute_x402_endpoint: apiUrl "https://aibtc.com", path "/api/inbox/SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE", method GET
   - Skip messages already in daemon/processed.json

3. REPLY TO NEW MESSAGES: For each unreplied received message NOT in processed.json:
   - Task messages (github, fork, PR, build, deploy, implement, fix, create): describe the task, say you'll work on it
   - Other messages: brief acknowledgment
   - Sign: mcp__aibtc__btc_sign_message "Inbox Reply | {messageId} | {reply text}"
   - Send FREE via outbox: mcp__aibtc__execute_x402_endpoint, apiUrl "https://aibtc.com", path "/api/outbox/SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE", method POST, data: {messageId, reply, signature (base64)}

4. PAID ATTENTION:
   - GET /api/paid-attention from aibtc.com
   - If there's a current prompt, respond to it
   - Sign and POST response

## AFTER ACTIONS (every tick)

5. UPDATE PROCESSED: Add new message IDs to /Users/biwas/drx4/daemon/processed.json

6. LEARN: If anything failed or you discovered something new:
   - Append to /Users/biwas/drx4/memory/learnings.md (be specific: what failed, what works)
   - If it's a permanent config change, update /Users/biwas/drx4/CLAUDE.md

7. JOURNAL: Append a tick summary to /Users/biwas/drx4/memory/journal.md

## OUTPUT
Output a JSON summary as the LAST line:
{"checkin": true/false, "inbox_checked": true/false, "unreplied": <count>, "replied": <count>, "paid_attention": true/false, "learned": "<note or null>"}
`;

// Subsequent ticks: short prompt, session already has full context
const TICK_PROMPT = `Time for your next periodic tick. The current time is {TIMESTAMP}.

Run through your tick actions:
1. Check-in (sign + submit)
2. Check inbox (skip already-processed messages)
3. Reply to any new unreplied messages
4. Handle paid attention if there's a prompt
5. Update processed.json, learnings, and journal

If the wallet locked, re-unlock it first.
If any tools aren't loaded, re-load them via ToolSearch.

Output JSON summary as the last line.
`;

async function tick(state: DaemonState) {
  const tickNum = state.tickCount + 1;
  const isFirst = tickNum === 1;
  log("INFO", `Tick #${tickNum} starting (${isFirst ? "INIT" : "RESUME"})...`);

  // First tick: full init prompt, fresh session
  // Subsequent ticks: short prompt, resume existing session
  const prompt = isFirst
    ? INIT_PROMPT
    : TICK_PROMPT.replace("{TIMESTAMP}", new Date().toISOString());

  const { output, sessionId: newSessionId } = await runClaude(
    prompt,
    isFirst ? null : state.sessionId,
    180_000 // 3 min timeout
  );

  // Save session ID for future resumption
  if (newSessionId && newSessionId !== state.sessionId) {
    log("INFO", `Session ID: ${newSessionId}`);
    state.sessionId = newSessionId;
  }

  if (output) {
    log("INFO", `Tick output (last 300 chars): ...${output.slice(-300)}`);

    // Try to parse JSON summary from output
    const jsonMatch = output.match(/\{[^{}]*"checkin"[^{}]*\}/);
    if (jsonMatch) {
      try {
        const summary = JSON.parse(jsonMatch[0]);
        log(
          "INFO",
          `Tick summary: checkin=${summary.checkin}, replied=${summary.replied}, paid_attention=${summary.paid_attention}`
        );
        if (summary.learned) {
          log("INFO", `Learned: ${summary.learned}`);
        }
      } catch {}
    }
  } else {
    log("ERROR", "Tick produced no output");
    state.errors++;
    // If session died, clear it so next tick starts fresh
    if (!isFirst) {
      log("WARN", "Clearing session ID — next tick will re-init");
      state.sessionId = null;
      state.tickCount = 0; // Reset so next tick uses INIT_PROMPT
    }
  }

  state.lastTick = new Date().toISOString();
  state.tickCount++;
  saveState(state);
}

// --- Main ---

async function main() {
  log("INFO", "Secret Mars daemon starting...");

  // Write PID
  writeFileSync(PID_FILE, String(process.pid));
  log("INFO", `PID ${process.pid} written`);

  const state = loadState();

  // Graceful shutdown
  const shutdown = () => {
    log("INFO", "Daemon shutting down...");
    saveState(state);
    try {
      unlinkSync(PID_FILE);
    } catch {}
    process.exit(0);
  };

  process.on("SIGTERM", shutdown);
  process.on("SIGINT", shutdown);

  // Initial tick
  await tick(state);

  // Schedule ticks
  setInterval(() => tick(state), INTERVAL);

  log("INFO", `Daemon running. Tick every ${INTERVAL / 60000} minutes.`);
}

main().catch((err) => {
  log("ERROR", `Fatal: ${err}`);
  process.exit(1);
});
