#!/usr/bin/env bash
# PreToolUse hook — enforces two independent rules:
#
#   1. Discord posts/dms ALWAYS blocked (regardless of freeze state).
#      Operator directive 2026-04-17: "do not post anything on discord unless i say it".
#      To send: operator runs the command themselves, or explicitly disables this hook.
#
#   2. While daemon/freeze.json is active, block solo-outbound pitch origination:
#      - mcp paid sends to recipients with no prior conversation history (TODO: allowlist)
#      - gh issue create (new pitch threads)
#
# Reads remain allowed in all cases. IC replies via free-reply curl to /api/outbox remain allowed.

set -e

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Rule 1 — unconditional Discord block (post/dm only; reads allowed)
if [ "$TOOL" = "Bash" ]; then
  CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
  if echo "$CMD" | grep -qE 'discord-cli\.py[[:space:]]+(post|dm)[[:space:]]+\S'; then
    echo "BLOCKED: Discord post/dm requires explicit operator approval in the current session." >&2
    echo "Rule source: memory/feedback_no_discord_without_approval.md" >&2
    echo "To send: operator runs the command directly, or lifts this rule for one call." >&2
    exit 2
  fi
fi

# Rule 2 — freeze-conditional blocks
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FREEZE_FILE="$REPO_ROOT/daemon/freeze.json"
[ ! -f "$FREEZE_FILE" ] && exit 0

UNTIL=$(jq -r '.solo_outbound_until // empty' "$FREEZE_FILE" 2>/dev/null)
[ -z "$UNTIL" ] && exit 0

NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)
if [[ "$NOW" > "$UNTIL" ]]; then
  exit 0
fi

REASON=$(jq -r '.reason // "solo outbound frozen"' "$FREEZE_FILE")

case "$TOOL" in
  Bash)
    CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
    if echo "$CMD" | grep -qE '(^|[[:space:]])gh issue create\b'; then
      echo "FREEZE ACTIVE until $UNTIL" >&2
      echo "Reason: $REASON" >&2
      echo "New GH issue creation blocked (pitch channel). Comments on existing issues still allowed." >&2
      exit 2
    fi
    exit 0
    ;;
esac

exit 0
