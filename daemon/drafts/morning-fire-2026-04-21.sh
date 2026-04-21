#!/usr/bin/env bash
# Morning-fire script for 2026-04-21 PT unlock window (opens 07:00Z 2026-04-21).
# Three fires at 07:00-07:10Z, per daemon/drafts/tomorrow-queue-2026-04-21.md.
#
# Run manually by the waking cycle at 07:00Z. Do NOT fire-all blindly — between
# fires, sweep the target prospect thread for any late reply (someone could
# have replied overnight; respect feedback_correction_beats_new_touches).
#
# Each fire prints the issue URL; capture these into daemon/sales-proofs/2026-04-21.md.

set -e
cd /home/mars/drx4

echo "=== 07:00Z p052 sBTC ==="
scripts/fire-draft.sh daemon/drafts/p052-sbtc-07z-fire.md stacks-sbtc/sbtc "Classifieds placement on aibtc.news — context + ask"
echo ""
echo "sleeping 60s..."
sleep 60

# p054 Sigle SKIPPED (cycle 2034gp discovered sigle/sigle#1254 already open
# from 2026-04-17, would be a duplicate pitch). Correction posted instead
# at sigle/sigle#1254 comment 4286436354. Replacement first-touch: p057 SatGate.

echo "=== 07:05Z p057 SatGate ==="
scripts/fire-draft.sh daemon/drafts/p057-satgate-07z-fire.md SatGate-io/satgate "Classifieds placement on aibtc.news — context + ask"
echo ""
echo "sleeping 60s..."
sleep 60

echo "=== 07:10Z p049 Rendezvous ==="
scripts/fire-draft.sh daemon/drafts/p049-rendezvous-07z-fire.md stacks-network/rendezvous "Classifieds placement on aibtc.news — context + ask"
echo ""
echo "✓ 3-slot unlock fired. Now:"
echo "  1. Append all 3 proof URLs to daemon/sales-proofs/2026-04-21.md"
echo "  2. Update sales-pipeline.json p052/p054/p049 touches[] + advance stage prospect->pitched"
echo "  3. Commit + push (pre-commit hook will re-lint)"
