#!/usr/bin/env bash
# Dry-run validator for fire-queue-2026-04-30.sh — checks pre-conditions
# without actually firing. Run before 07:00Z to confirm tomorrow's deploy is ready.
set -euo pipefail

REPO_DIR="/home/mars/drx4"
DRAFTS="$REPO_DIR/daemon/drafts/2026-04-30"
cd "$REPO_DIR"

PASS=0
FAIL=0

check() {
  local name="$1" status="$2" detail="$3"
  if [ "$status" = "ok" ]; then
    printf "  ✓ %-50s %s\n" "$name" "$detail"
    PASS=$((PASS+1))
  else
    printf "  ✗ %-50s %s\n" "$name" "$detail"
    FAIL=$((FAIL+1))
  fi
}

echo "=== Fire script pre-flight: 2026-04-30 PT ==="
echo "Time: $(date -u +%FT%TZ)"
echo ""

echo "1. Drafts present + non-empty"
for f in "p094-presidio.md" "p095-x402-agent-tools.md" "p096-pipenetwork.md"; do
  path="$DRAFTS/$f"
  if [ -f "$path" ] && [ -s "$path" ]; then
    chars=$(wc -c < "$path")
    check "$f" ok "$chars chars"
  else
    check "$f" fail "MISSING or empty"
  fi
done
echo ""

echo "2. Title/Body parses cleanly"
for f in "p094-presidio.md" "p095-x402-agent-tools.md" "p096-pipenetwork.md"; do
  path="$DRAFTS/$f"
  title=$(grep '^\*\*Title:' "$path" 2>/dev/null | sed 's/\*\*Title:\*\* //')
  body=$(awk '/^\*\*Body:\*\*/{flag=1;sub(/^\*\*Body:\*\* /,"",$0); print; next} flag{print}' "$path")
  if [ -n "$title" ] && [ -n "$body" ]; then
    body_chars=$(echo "$body" | wc -c)
    check "$f parser" ok "title: '${title:0:35}...' body: $body_chars chars"
  else
    check "$f parser" fail "title-or-body extraction failed"
  fi
done
echo ""

echo "3. Lint clean"
lint_out=$(python3 scripts/lint-pitches.py "$DRAFTS"/p09*.md 2>&1)
if echo "$lint_out" | grep -q "0 hard · 0 soft"; then
  check "lint-pitches.py" ok "$lint_out"
else
  check "lint-pitches.py" fail "$lint_out"
fi
echo ""

echo "4. Pipeline state"
pipeline_len=$(jq '.prospects | length' "$REPO_DIR/daemon/sales-pipeline.json")
pipeline_keys=$(jq 'keys | length' "$REPO_DIR/daemon/sales-pipeline.json")
qualified_targets=$(jq '[.prospects[] | select(.id == "p094" or .id == "p095" or .id == "p096") | select(.stage == "qualified")] | length' "$REPO_DIR/daemon/sales-pipeline.json")
check "pipeline length" ok "$pipeline_len prospects, $pipeline_keys top-level keys"
if [ "$qualified_targets" = "3" ]; then
  check "p094/p095/p096 in qualified" ok "all 3 ready for fire-and-advance"
else
  check "p094/p095/p096 in qualified" fail "expected 3, got $qualified_targets"
fi
echo ""

echo "5. Target repos accessible (last commit < 30d)"
for repo in "presidio-v/presidio-hardened-x402" "Br0ski777/x402-agent-tools" "PipeNetwork/lib-storage"; do
  pushed=$(gh repo view "$repo" --json pushedAt --jq '.pushedAt[0:10]' 2>/dev/null || echo "ERROR")
  if [ "$pushed" != "ERROR" ]; then
    check "$repo" ok "last push $pushed"
  else
    check "$repo" fail "repo not accessible (404 / archived?)"
  fi
done
echo ""

echo "6. Auth + tooling"
if [ -n "${GH_TOKEN:-}" ] || [ -n "${GITHUB_PAT_SECRET_MARS:-}" ] || grep -q '^GITHUB_PAT_SECRET_MARS=' "$REPO_DIR/.env" 2>/dev/null; then
  check "GH_TOKEN/PAT" ok "available via env or .env"
else
  check "GH_TOKEN/PAT" fail "missing — fire script will fail gh issue create"
fi
if [ -x "$REPO_DIR/scripts/fire-queue-2026-04-30.sh" ]; then
  check "fire script executable" ok "+x bit set"
else
  check "fire script executable" fail "needs chmod +x"
fi
if bash -n "$REPO_DIR/scripts/fire-queue-2026-04-30.sh" 2>/dev/null; then
  check "fire script syntax" ok "bash -n passes"
else
  check "fire script syntax" fail "bash -n found errors"
fi
echo ""

echo "==="
echo "RESULT: $PASS passed, $FAIL failed"
if [ "$FAIL" -eq 0 ]; then
  echo "Tomorrow's PT fire is READY. Run: bash scripts/fire-queue-2026-04-30.sh"
  exit 0
else
  echo "DO NOT FIRE until failures resolved."
  exit 1
fi
