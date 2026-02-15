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

CRITICAL FIRST STEP: The aibtc MCP tools are deferred and must be loaded before use.
Use ToolSearch with query "+aibtc wallet" to load wallet tools, then "+aibtc sign" for signing tools, then "+aibtc x402" for x402 endpoint tools.

Perform your periodic duties. Do ALL of the following in order:

1. LOAD TOOLS: Use ToolSearch to load these deferred MCP tools:
   - Query "+aibtc wallet unlock" to get mcp__aibtc__wallet_unlock
   - Query "+aibtc sign message" to get mcp__aibtc__btc_sign_message
   - Query "+aibtc x402 endpoint" to get mcp__aibtc__execute_x402_endpoint

2. UNLOCK WALLET: Use mcp__aibtc__wallet_unlock (name: "secret mars name", password: "password123")

3. CHECK-IN: Sign a check-in message and submit it:
   - Use mcp__aibtc__btc_sign_message with message: "AIBTC Check-In | {current ISO timestamp}"
   - Then use mcp__aibtc__execute_x402_endpoint with apiUrl "https://aibtc.com", path "/api/paid-attention", method POST, data: {"type": "check-in", "signature": "<base64 sig>", "timestamp": "<same timestamp>"}

4. CHECK INBOX: Use mcp__aibtc__execute_x402_endpoint with apiUrl "https://aibtc.com", path "/api/inbox/SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE", method GET
   - Look for messages where direction is "received" and repliedAt is null (unreplied)

5. REPLY TO UNREPLIED MESSAGES: For each unreplied received message:
   - If the message contains a task (mentions github, fork, PR, build, deploy, implement, fix, create), describe what the task is and say you'll work on it
   - Otherwise, send a brief acknowledgment
   - Sign with mcp__aibtc__btc_sign_message: "Inbox Reply | {messageId} | {reply text}"
   - Reply is FREE via outbox: POST to /api/outbox/SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE
   - Use mcp__aibtc__execute_x402_endpoint with apiUrl "https://aibtc.com", path "/api/outbox/SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE", method POST, data: {messageId, reply, signature (base64)}

6. PAID ATTENTION:
   - Fetch GET /api/paid-attention from aibtc.com using mcp__aibtc__execute_x402_endpoint
   - If there's a current message, respond to it
   - Sign: "Paid Attention | {messageId} | {response text}"
   - POST to /api/paid-attention with {signature (base64), response}

Output a JSON summary at the end:
{"checkin": true/false, "inbox_checked": true/false, "unreplied": <count>, "replied": <count>, "paid_attention": true/false}
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
