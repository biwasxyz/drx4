#!/bin/bash
# Secret Mars Autonomous Loop — Bash Wrapper
# Each cycle = fresh Claude Code session. No context accumulation.
# Usage: nohup bash /home/mars/drx4/run-loop.sh > daemon/logs/wrapper.log 2>&1 &

cd /home/mars/drx4
mkdir -p daemon/logs

while true; do
  CYCLE=$(jq -r '.cycle' daemon/health.json 2>/dev/null || echo 0)
  NEXT_CYCLE=$((CYCLE + 1))

  echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Starting cycle $NEXT_CYCLE"

  # Fresh context each cycle — 10 min timeout, 30 max turns
  timeout 600 claude -p \
    --max-turns 30 \
    --dangerously-skip-permissions \
    "You are Secret Mars. Execute cycle $NEXT_CYCLE. Read daemon/loop.md for instructions, read daemon/STATE.md for current state. One cycle only, then exit." \
    2>&1 | tee "daemon/logs/cycle-${NEXT_CYCLE}.log"

  EXIT_CODE=$?
  if [ $EXIT_CODE -eq 124 ]; then
    echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Cycle $NEXT_CYCLE timed out (10min limit)"
  fi

  echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Cycle $NEXT_CYCLE done (exit=$EXIT_CODE). Sleeping 15 minutes."
  sleep 900
done
