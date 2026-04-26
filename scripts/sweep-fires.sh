#!/usr/bin/env bash
# sweep-fires.sh — full-schema state probe of recent fires.
#
# Codifies cycle 2034ie + cycle 2034jq learnings:
#   - Issue deletion = HTTP 410 from gh api (NOT 200 from curl)
#   - Silent-close with state_reason=not_planned = strongest decline signal
#   - Phase 1 sweeps must read .state + .state_reason + .closed_by + .closed_at,
#     not just .comments + .updated_at
#
# Usage: sweep-fires.sh [DAYS_BACK]   # default 7
#
# Reads strict-format proof lines from daemon/sales-proofs/YYYY-MM-DD.md
# (format: `- ISO_TS | NAME | github_issue | outbound | URL | summary`)
# and probes each URL via `gh api`. Prints one JSON-ish line per fire.
# Exit code 0 always; treat output as a feed.

set -uo pipefail

cd "$(dirname "$0")/.."
DAYS_BACK="${1:-7}"
PROOF_DIR="daemon/sales-proofs"

# Collect dates within range
mapfile -t dates < <(
  for n in $(seq 0 "$DAYS_BACK"); do
    date -u -d "$n days ago" +%Y-%m-%d
  done
)

# Extract URLs from strict-format lines
declare -a URLS
for d in "${dates[@]}"; do
  f="$PROOF_DIR/$d.md"
  [[ -f "$f" ]] || continue
  while IFS= read -r line; do
    # Match strict-format lines starting with `- ` and 5 pipe separators
    [[ "$line" =~ ^-[[:space:]] ]] || continue
    [[ "$(grep -o '|' <<< "$line" | wc -l)" -ge 5 ]] || continue
    url=$(awk -F' \\| ' '{print $5}' <<< "$line")
    [[ "$url" =~ ^https://github\.com/[^/]+/[^/]+/(issues|pull)/[0-9]+$ ]] || continue
    URLS+=("$url")
  done < "$f"
done

# Dedup URLs while preserving order
declare -A seen
declare -a UNIQ
for u in "${URLS[@]}"; do
  [[ -z "${seen[$u]:-}" ]] || continue
  seen["$u"]=1
  UNIQ+=("$u")
done

if [[ ${#UNIQ[@]} -eq 0 ]]; then
  echo "no fires found in last $DAYS_BACK days under $PROOF_DIR/"
  exit 0
fi

echo "=== sweep-fires: ${#UNIQ[@]} unique fire URLs from last $DAYS_BACK days ==="

for url in "${UNIQ[@]}"; do
  # Convert https://github.com/OWNER/REPO/issues/N → repos/OWNER/REPO/issues/N
  api_path="${url#https://github.com/}"
  api_path="${api_path/\/pull\///pulls/}"
  resp=$(gh api "repos/$api_path" --jq '{state, state_reason, comments, closed_by: (.closed_by.login // null), closed_at, updated_at}' 2>&1)
  rc=$?
  if [[ $rc -ne 0 ]]; then
    if grep -q "HTTP 410\|Not Found" <<< "$resp"; then
      echo "$url DELETED (HTTP 410 or 404 — recipient scrubbed)"
    else
      echo "$url ERROR: $resp"
    fi
    continue
  fi
  # Surface notable state changes
  state=$(jq -r '.state' <<< "$resp")
  reason=$(jq -r '.state_reason // "—"' <<< "$resp")
  cb=$(jq -r '.closed_by // "—"' <<< "$resp")
  c=$(jq -r '.comments' <<< "$resp")
  flag=""
  if [[ "$state" == "closed" ]]; then
    flag=" ⚠ CLOSED"
    [[ "$reason" != "—" ]] && flag="$flag (reason=$reason)"
    [[ "$cb" != "—" ]] && flag="$flag by=$cb"
  elif [[ "$c" -gt 0 ]]; then
    flag=" ✉ $c comments"
  fi
  echo "$url state=$state$flag"
done
