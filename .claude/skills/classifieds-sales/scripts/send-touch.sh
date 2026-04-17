#!/usr/bin/env bash
# send-touch.sh — multi-channel send wrapper for classifieds-sales first-touches.
#
# - gh:    creates the issue via `gh` CLI (fully automated)
# - x402:  emits the MCP call syntax to paste into your Claude/OpenClaw session
#          (bash cannot drive the MCP server directly)
# - nostr: emits the MCP nostr_post call syntax for the same reason
#
# Reads the pitch body from stdin or --body PATH. Emits a proof URL (gh) or
# a ready-to-paste MCP command (x402/nostr).
#
# Usage:
#   cat pitch.txt | send-touch.sh --channel gh --repo owner/name --title "..."
#   send-touch.sh --channel x402 --recipient-stx SP... --body pitch.txt
#   send-touch.sh --channel nostr --pubkey npub1... --body pitch.txt
#
# Exit codes:
#   0 = success (issue created OR command emitted)
#   1 = recipient/target invalid, body empty, or gh create failed
#   2 = usage error
set -euo pipefail

CHANNEL=""
REPO=""
TITLE=""
RECIPIENT_STX=""
PUBKEY=""
BODY_PATH=""

die() { echo "ERROR: $*" >&2; exit "${2:-1}"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --channel) CHANNEL="${2:-}"; shift 2 ;;
    --repo) REPO="${2:-}"; shift 2 ;;
    --title) TITLE="${2:-}"; shift 2 ;;
    --recipient-stx) RECIPIENT_STX="${2:-}"; shift 2 ;;
    --pubkey) PUBKEY="${2:-}"; shift 2 ;;
    --body) BODY_PATH="${2:-}"; shift 2 ;;
    -h|--help) sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) die "unknown flag: $1" 2 ;;
  esac
done

[[ -z "$CHANNEL" ]] && die "--channel required (gh|x402|nostr)" 2

# --- Read body ---
if [[ -n "$BODY_PATH" ]]; then
  [[ -r "$BODY_PATH" ]] || die "body file not readable: $BODY_PATH"
  BODY=$(cat "$BODY_PATH")
elif [[ ! -t 0 ]]; then
  BODY=$(cat)
else
  die "pitch body required via --body PATH or stdin" 2
fi

[[ -z "${BODY// }" ]] && die "pitch body is empty"

# Em-dash final guard (strip + warn if found)
if printf '%s' "$BODY" | grep -q '—\|–'; then
  echo "WARN: em-dash found in body. Stripping." >&2
  BODY=$(printf '%s' "$BODY" | sed 's/—/./g; s/–/./g')
fi

# --- Dispatch by channel ---
case "$CHANNEL" in
  gh)
    [[ -z "$REPO" ]] && die "--repo required for gh channel (owner/name)" 2
    [[ -z "$TITLE" ]] && die "--title required for gh channel" 2
    [[ "$REPO" != */* ]] && die "--repo must be owner/name format, got: $REPO" 2

    if ! command -v gh >/dev/null 2>&1; then
      die "gh CLI not in PATH — install Claude Code CLI first" 1
    fi
    if ! gh auth status >/dev/null 2>&1; then
      die "gh not authenticated — run: gh auth login" 1
    fi

    # Pre-flight: ensure not pitching a DNC-listed repo. Try git-root first, fallback to relative path.
    if [[ -z "${DNC_PATH:-}" ]]; then
      if GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null); then
        DNC_PATH="$GIT_ROOT/daemon/sales-dnc.md"
      else
        DNC_PATH="$(cd "$(dirname "$0")/../../../.." && pwd)/daemon/sales-dnc.md"
      fi
    fi
    if [[ -r "$DNC_PATH" ]] && grep -qF "$REPO" "$DNC_PATH"; then
      die "repo $REPO is on DNC list ($DNC_PATH) — refusing to send" 1
    elif [[ ! -r "$DNC_PATH" ]]; then
      echo "WARN: DNC list not found at $DNC_PATH — set DNC_PATH env var to override. Proceeding without DNC check." >&2
    fi

    URL=$(gh issue create --repo "$REPO" --title "$TITLE" --body "$BODY" --json url --jq '.url' 2>&1)
    [[ -z "$URL" ]] && die "gh issue create returned empty URL — check gh output above"
    echo "CREATED: $URL"
    echo "LOG_LINE: https://github.com/$REPO/issues/$(basename "$URL" | tr -dc 0-9)"
    ;;

  x402)
    [[ -z "$RECIPIENT_STX" ]] && die "--recipient-stx required for x402 channel" 2
    [[ ! "$RECIPIENT_STX" =~ ^S[MP][0-9A-Z]{37,41}$ ]] && die "invalid STX address format: $RECIPIENT_STX (expected S[M|P] + 37-41 alphanumeric)" 1

    CHAR_COUNT=$(printf '%s' "$BODY" | wc -c)
    if [[ "$CHAR_COUNT" -gt 500 ]]; then
      echo "WARN: x402 pitch is $CHAR_COUNT chars, over 500-char x402 limit. Tighten before sending." >&2
    fi

    # Emit the MCP tool-call syntax as JSON so the agent can paste it directly.
    cat <<EOF
# Paste the following into your Claude/OpenClaw MCP session to send:

mcp__aibtc__send_inbox_message(
  recipient_stx_address="$RECIPIENT_STX",
  message=$(printf '%s' "$BODY" | python3 -c 'import sys, json; print(json.dumps(sys.stdin.read()))')
)

# After send, log the returned messageId and the fetchable proof URL:
#   https://aibtc.com/api/inbox/{recipient_btc}/{messageId}
# to daemon/sales-pipeline.json under the prospect's touches[] entry.
EOF
    ;;

  nostr)
    [[ -z "$PUBKEY" ]] && die "--pubkey required for nostr channel (npub1... or hex)" 2

    cat <<EOF
# Paste the following into your Claude/OpenClaw MCP session to send:

mcp__aibtc__nostr_post(
  recipient_pubkey="$PUBKEY",
  content=$(printf '%s' "$BODY" | python3 -c 'import sys, json; print(json.dumps(sys.stdin.read()))'),
  kind=4
)

# After send, log the returned event id as the proof URL:
#   nostr event:{event_id}
# to daemon/sales-pipeline.json under the prospect's touches[] entry.
EOF
    ;;

  *) die "--channel must be gh|x402|nostr (got: $CHANNEL)" 2 ;;
esac
