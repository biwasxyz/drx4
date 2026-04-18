#!/usr/bin/env bash
# Install git hooks by pointing core.hooksPath at the tracked scripts/hooks dir.
# Run once per clone.

set -euo pipefail
cd "$(dirname "$0")/.."

chmod +x scripts/hooks/pre-commit scripts/hooks/commit-msg
git config core.hooksPath scripts/hooks

# BIP39 wordlist for the pre-commit secret scanner. Tracked in-repo, but
# refetch if missing so partial clones still get protection.
if [[ ! -s scripts/hooks/bip39-english.txt ]]; then
  echo "Fetching BIP39 wordlist..."
  curl -sL -o scripts/hooks/bip39-english.txt \
    "https://raw.githubusercontent.com/bitcoin/bips/master/bip-0039/english.txt"
fi

echo "✓ hooks installed"
echo "  core.hooksPath = scripts/hooks"
echo ""
echo "Active hooks:"
ls -1 scripts/hooks/ | sed 's/^/  /'
echo ""
echo "Bypass for crash recovery / stop cycles:"
echo "  ALLOW_STATE_ONLY=1 git commit ..."
echo ""
echo "Secret-scan section (BIP39 / xprv / PAT / PEM / Slack / Stripe / OpenAI /"
echo "Anthropic / AWS / keyword-assignment) is NEVER bypassable."
