#!/usr/bin/env bash
# PreToolUse hook gating ScheduleWakeup. Refuses to let the cycle schedule
# the next wakeup unless daemon/outputs.log grew this cycle. Catches the
# "cruise mode" failure at cycle-time, not commit-time.
#
# Bypass:  ALLOW_EMPTY_CYCLE=1  (use once, for genuine no-op cycles only)
set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$PROJECT_DIR"

[[ "${ALLOW_EMPTY_CYCLE:-0}" == "1" ]] && exit 0

mark="daemon/.cycle-start-sha"
head_sha="$(git rev-parse HEAD)"

if [[ ! -f "$mark" ]]; then
  echo "$head_sha" > "$mark"
  exit 0
fi

start_sha="$(cat "$mark")"
committed_added="$(git diff "$start_sha" HEAD -- daemon/outputs.log 2>/dev/null | grep -cE '^\+[^+]' || true)"
unstaged_added="$(git diff -- daemon/outputs.log 2>/dev/null | grep -cE '^\+[^+]' || true)"
total=$(( committed_added + unstaged_added ))

if (( total > 0 )); then
  echo "$head_sha" > "$mark"
  exit 0
fi

cat >&2 <<'EOF'
[cycle-output-gate] BLOCK: daemon/outputs.log did not grow this cycle.

Every cycle must ship a verifiable artifact and append an event line before
scheduling the next wakeup. Valid event types:
  review_shipped | issue_filed | comment_shipped | thread_nudged
  close_verified | board_refreshed | trade_executed | arc_coord_shipped
  learning_recorded

Ship something now and append the event before retrying ScheduleWakeup.
For genuine no-op cycles (operator-paused, hardware blocked) bypass with:
  ALLOW_EMPTY_CYCLE=1
EOF
exit 2
