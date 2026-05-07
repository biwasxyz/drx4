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

exec claude \
  --dangerously-skip-permissions \
  --channels plugin:telegram@claude-plugins-official \
  "$@"
