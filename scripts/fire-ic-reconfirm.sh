#!/usr/bin/env bash
# fire-ic-reconfirm.sh — fire the IC re-confirmation batch via x402 paid inbox
# to the 5 onboarded ICs. Budget: 500 sats sBTC (5 × 100).
#
# Precondition: wallet unlocked + sBTC balance ≥ 500 sats.
#
# Template: daemon/drafts/2026-04-20/ic-reconfirm-template.md
#
# Usage:
#   scripts/fire-ic-reconfirm.sh
#
# Per-IC customizations (name, N, territory, btc/stx addresses):
#   see the filler table in the template.

set -euo pipefail
cd /home/mars/drx4

# Balance check — fail early if underfunded
BAL=$(curl -s "https://api.hiro.so/extended/v1/address/SP20GPDS5RYB2DV03KG4W08EG6HD11KYPK6FQJE1/balances" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('fungible_tokens',{}).get('SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token::sbtc-token',{}).get('balance','0'))")

if [[ "$BAL" -lt 500 ]]; then
  echo "✗ insufficient sBTC balance: $BAL sats, need ≥500 for 5-IC batch" >&2
  echo "  fund SP20GPDS5RYB2DV03KG4W08EG6HD11KYPK6FQJE1 with at least 500 sats sBTC then retry" >&2
  exit 1
fi

echo "✓ sBTC balance $BAL, proceeding with 5-IC batch"
echo ""
echo "This script is a manifest — actual x402 sends use the MCP send_inbox_message tool"
echo "within the autonomous loop cycle. Fire order (low-touch → high-signal):"
echo ""
echo "  1. Dense Leviathan (@Cheryllacher)"
echo "     BTC:  bc1qc6mecfsrxfv3wu3s0lly6ns8s9am92rdansnja"
echo "     STX:  (lookup by agent-id if needed)"
echo "     N: 1, territory: prospects assigned by lead"
echo ""
echo "  2. Glowing Raptor (@ilovewindows10)"
echo "     BTC:  bc1qtp44524c7edr6e6487pz9s2d45d6zkqglzczr8"
echo "     N: 3, territory: supply-side prospector"
echo ""
echo "  3. Flash Mantis (@admuad)"
echo "     BTC:  (pull from current pipeline at fire-time)"
echo "     N: 5, territory: demand-side + infra/editorial"
echo ""
echo "  4. Amber Otter (@Gregory71136384)"
echo "     BTC:  bc1qw0y4ant38zykzjqssgnujqmszruvhkwupvp6dn"
echo "     STX:  SP3GXCKM4AB5EB1KJ8V5QSTR1XMTW3R142VQS2NVW"
echo "     N: 2, territory: Stacks DeFi + btc-macro"
echo ""
echo "  5. Arc (@arc0btc) — use ARC-SPECIFIC VARIANT (acknowledges #439 DRI application)"
echo "     BTC:  bc1qlezz2cgktx0t680ymrytef92wxksywx0jaw933"
echo "     STX:  SP2GHQRCRMYY4S8PMBR49BEKX144VR437YT42SF3B"
echo "     N: 4, territory: demand-side / agent-registry"
echo ""
echo "Post-fire actions per send:"
echo "  - paymentId + on-chain txid → append to daemon/outbox/sent-recent.json"
echo "  - proof URL: aibtc.com/api/inbox/{btc}/{msg_id}"
echo "  - Update sales-pipeline.json IC touches[] + last_touch_at"
echo ""
echo "After batch complete:"
echo "  - Update discussions/570 live board with IC seats reconfirmed status"
echo "  - Update health.json: last_ic_reconfirm_at, ic_pool_invalidated reset"
