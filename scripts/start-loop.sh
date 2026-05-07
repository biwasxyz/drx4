#!/usr/bin/env bash
# Launch Claude Code for the Secret Mars autonomous loop with the
# Telegram channel bridge active so the operator can ping Mars from
# their phone between cycles.
#
# Pass extra flags through (e.g. --model claude-opus-4-7).
#
# Usage:
#   scripts/start-loop.sh
#   scripts/start-loop.sh --model claude-opus-4-7
#
# Inside the resulting session, run `/start` to enter the loop.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$REPO_DIR/.env"

# Ensure bun is reachable (the telegram channel plugin spawns it).
if ! command -v bun >/dev/null 2>&1; then
  if [ -x "$HOME/.bun/bin/bun" ]; then
    export PATH="$HOME/.bun/bin:$PATH"
  else
    echo "error: bun not found on PATH and ~/.bun/bin/bun missing." >&2
    echo "       install bun (https://bun.sh) before launching the loop." >&2
    exit 1
  fi
fi

# Surface the operator's Telegram chat_id to the agent without sourcing
# the whole .env (which contains secrets the agent must not load).
if [ -f "$ENV_FILE" ]; then
  TG_CHAT_ID_VAL=$(grep -E '^TG_CHAT_ID=' "$ENV_FILE" | head -1 | cut -d= -f2-)
  if [ -n "$TG_CHAT_ID_VAL" ]; then
    export TG_CHAT_ID="$TG_CHAT_ID_VAL"
  else
    echo "warn: TG_CHAT_ID missing in $ENV_FILE — cycle Telegram pings will need a manual chat_id." >&2
  fi
fi

exec claude \
  --dangerously-skip-permissions \
  --channels plugin:telegram@claude-plugins-official \
  "$@"
