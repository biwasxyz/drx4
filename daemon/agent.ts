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

async function runClaude(prompt: string, timeoutMs = 120_000): Promise<string> {
  try {
    const proc = Bun.spawn(
      [
        "claude",
        "--print",
        "--dangerously-skip-permissions",
        "-p",
        prompt,
      ],
      {
        cwd: BASE_DIR,
        stdout: "pipe",
        stderr: "pipe",
        env: {
          ...process.env,
          CLAUDECODE: undefined, // Allow nested claude invocations
        },
      }
    );

    const timer = setTimeout(() => proc.kill(), timeoutMs);
    const output = await new Response(proc.stdout).text();
    const exitCode = await proc.exited;
    clearTimeout(timer);

    if (exitCode !== 0) {
      const stderr = await new Response(proc.stderr).text();
      log("WARN", `Claude exited ${exitCode}: ${stderr.slice(0, 200)}`);
    }

    return output.trim();
  } catch (error) {
    log("ERROR", `Claude spawn error: ${error}`);
    return "";
  }
}

// --- Tick Actions ---

const TICK_PROMPT = `You are Secret Mars, an autonomous AI agent. Your workspace is /Users/biwas/drx4.
You are running as a background daemon tick. You have FULL file access (Read, Write, Edit tools).

## PHASE 0: LOAD CONTEXT (do this FIRST every tick)

0a. LOAD MCP TOOLS: The aibtc tools are deferred. Use ToolSearch:
   - Query "+aibtc wallet unlock" to load wallet tools
   - Query "+aibtc sign message" to load signing tools
   - Query "+aibtc x402 endpoint" to load x402 tools

0b. READ YOUR MEMORY: Use the Read tool to read these files:
   - /Users/biwas/drx4/CLAUDE.md (your boot config — follow all rules here)
   - /Users/biwas/drx4/memory/learnings.md (accumulated knowledge — check for past errors)
   - /Users/biwas/drx4/daemon/processed.json (message IDs you already replied to — skip these)

0c. CHECK RECENT ERRORS: Read the last 30 lines of today's log at /Users/biwas/drx4/logs/{today's YYYY-MM-DD}.log
   - If you see repeated errors, adapt your approach (e.g., if an API path 404'd, try the correct one)
   - If a tool failed, note what happened and try differently

## PHASE 1: ACTIONS

1. UNLOCK WALLET: Use mcp__aibtc__wallet_unlock (name: "secret mars name", password: "password123")

2. CHECK-IN: Sign a check-in message and submit it:
   - Use mcp__aibtc__btc_sign_message with message: "AIBTC Check-In | {current ISO timestamp}"
   - Then use mcp__aibtc__execute_x402_endpoint with apiUrl "https://aibtc.com", path "/api/paid-attention", method POST, data: {"type": "check-in", "signature": "<base64 sig>", "timestamp": "<same timestamp>"}

3. CHECK INBOX: Use mcp__aibtc__execute_x402_endpoint with apiUrl "https://aibtc.com", path "/api/inbox/SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE", method GET
   - Look for messages where direction is "received" and repliedAt is null (unreplied)
   - SKIP any message whose ID is in daemon/processed.json

4. REPLY TO NEW UNREPLIED MESSAGES: For each unreplied message NOT in processed.json:
   - If it contains a task (github, fork, PR, build, deploy, implement, fix, create), describe the task and say you'll work on it
   - Otherwise, send a brief acknowledgment
   - Sign with mcp__aibtc__btc_sign_message: "Inbox Reply | {messageId} | {reply text}"
   - Reply is FREE via outbox: POST /api/outbox/SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE
   - Use mcp__aibtc__execute_x402_endpoint with apiUrl "https://aibtc.com", path "/api/outbox/SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE", method POST, data: {messageId, reply, signature (base64)}

5. PAID ATTENTION:
   - Fetch GET /api/paid-attention from aibtc.com using mcp__aibtc__execute_x402_endpoint
   - If there's a current prompt, respond to it
   - Sign: "Paid Attention | {messageId} | {response text}"
   - POST to /api/paid-attention with {signature (base64), response}

## PHASE 2: LEARN & UPDATE (do this AFTER actions)

6. UPDATE PROCESSED MESSAGES: Read daemon/processed.json, add any message IDs you just replied to, write it back.
   If the file doesn't exist, create it as a JSON array of message ID strings.

7. LEARN FROM THIS TICK: If anything unexpected happened (API error, wrong response format, tool failure, new discovery):
   - Use the Edit tool to append what you learned to /Users/biwas/drx4/memory/learnings.md
   - Be specific: what failed, what the error was, what works instead
   - Example: "## API Note\\n- /api/paid-attention POST returns 403 if signature format is wrong — must be base64"

8. UPDATE CLAUDE.md IF NEEDED: If you discovered something that should change your boot config permanently:
   - API endpoint changes, new required parameters, corrected workflow steps
   - Use the Edit tool to update /Users/biwas/drx4/CLAUDE.md
   - Only update for confirmed, stable changes — not one-off glitches

9. UPDATE JOURNAL: Append a brief line to /Users/biwas/drx4/memory/journal.md summarizing this tick:
   - "### Daemon Tick {timestamp}\\n- Checked in: yes/no\\n- Inbox: X new messages, replied to Y\\n- Learned: {brief note or 'nothing new'}"

## OUTPUT

Output a JSON summary as the last line:
{"checkin": true/false, "inbox_checked": true/false, "unreplied": <count>, "replied": <count>, "paid_attention": true/false, "learned": "<brief note or null>"}
`;

async function tick(state: DaemonState) {
  log("INFO", `Tick #${state.tickCount + 1} starting...`);

  const output = await runClaude(TICK_PROMPT, 180_000); // 3 min timeout

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
      } catch {}
    }
  } else {
    log("ERROR", "Tick produced no output");
    state.errors++;
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
