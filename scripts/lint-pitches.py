#!/usr/bin/env python3
"""
lint-pitches.py — scan draft pitch markdown for known error classes.

HARD violations (fail the lint, block commit):

1. Retired wallet addresses (SP4DXVEC.../bc1qqax... — compromised 2026-04-17)
2. Wrong pricing duration (30-day — canonical is 7-day) or amount
   (30k / 30,000 sats — canonical is 3,000 sats)
3. Renewal mispricing (2,000 sats per renewal — renewals are also 3k/7d,
   per Glowing Raptor IC incident cycle 2034ho 2026-04-22)
4. IC compensation leak to prospects — "Supply-side IC commission",
   "1,200 sats per closed deal", "600 sats per renewal". Internal pool
   comp never belongs in a prospect body (cycle 2034ho)
5. Wrong close path — "open PR on secret-mars/drx4" / "file a PR on my
   repo" etc. That's the IC write path, not a prospect close path.
   Prospects close via POST /api/classifieds with sBTC tx (cycle 2034ho)

Soft violations (warn, don't fail):

- Aspirational distribution claims (auto-tracking, brief rotation,
  click-through) — aibtc.news does not yet support these
- Permission-first phrasing (mind if I share, would it be ok if) —
  retired per operator directive cycle 2034e
- "Backed by Stacks Foundation" — unverified claim surface, flag for
  review (cycle 2034ho)

Usage:
    python3 scripts/lint-pitches.py <file-or-dir>...
    python3 scripts/lint-pitches.py daemon/drafts/

Exits non-zero if any HARD violations found. Soft flags warn only.
"""
from __future__ import annotations

import re
import sys
from dataclasses import dataclass
from pathlib import Path

RETIRED_STX = "SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE"
RETIRED_BTC_SEGWIT = "bc1qqaxq5vxszt0lzmr9gskv4lcx7jzrg772s4vxpp"
RETIRED_BTC_TAPROOT = "bc1pm0jdn7muqn7vf3yknlapmefdhyrrjfe6zgdqhx5xyhe6r6374fxqq4ngy3"

HARD_PATTERNS = [
    (re.compile(re.escape(RETIRED_STX)), "retired STX wallet (compromised 2026-04-17)"),
    (re.compile(re.escape(RETIRED_BTC_SEGWIT)), "retired BTC segwit (compromised 2026-04-17)"),
    (re.compile(re.escape(RETIRED_BTC_TAPROOT)), "retired BTC taproot (compromised 2026-04-17)"),
    (re.compile(r"\b30[-\s]?day\b", re.I), "wrong price duration (canonical is 7-day)"),
    (re.compile(r"\b30[,.]?000\s*sats?\b", re.I), "wrong price amount (canonical is 3,000 sats)"),
    (re.compile(r"\b30k\s*sats?\b", re.I), "wrong price amount (canonical is 3,000 sats = 3k)"),
    (re.compile(r"\b2[,.]?000\s*sats?\s*per\s*renewal\b", re.I),
     "renewal mispricing — renewals are 3,000 sats / 7-day same as placement (cycle 2034ho)"),
    (re.compile(r"\b2k\s*sats?\s*(per|for)\s*renewal\b", re.I),
     "renewal mispricing — renewals are 3,000 sats / 7-day (cycle 2034ho)"),
    (re.compile(r"supply[-\s]?side\s*IC\s*commission", re.I),
     "IC compensation leak — internal pool comp never in prospect body (cycle 2034ho)"),
    (re.compile(r"\b1[,.]?200\s*sats?\s*(per|/)\s*(closed|placement|deal)", re.I),
     "IC compensation leak — 1,200 sats/placement is internal (cycle 2034ho)"),
    (re.compile(r"\b600\s*sats?\s*(per|/)\s*renewal\b", re.I),
     "IC compensation leak — 600 sats/renewal is internal (cycle 2034ho)"),
    (re.compile(r"open\s+(a\s+)?PR\s+on\s+secret-mars/drx4", re.I),
     "wrong close path — prospects close via POST /api/classifieds, not PR on IC repo (cycle 2034ho)"),
    (re.compile(r"file\s+(a\s+)?PR\s+on\s+(my|the)\s+(drx4|repo)", re.I),
     "wrong close path — prospects use POST /api/classifieds (cycle 2034ho)"),
]

SOFT_PATTERNS = [
    (re.compile(r"auto[-\s]?track(ing|ed)?", re.I),
     "aspirational distribution claim — aibtc.news has no click-tracking endpoint"),
    (re.compile(r"brief[-\s]?rotation", re.I),
     "aspirational distribution claim — no brief ad slot as of 2026-04-17"),
    (re.compile(r"click[-\s]?through", re.I),
     "aspirational distribution claim — no CTR data available"),
    (re.compile(r"mind if (i|we) share", re.I),
     "permission-first phrasing retired (operator directive cycle 2034e)"),
    (re.compile(r"would it be ok if", re.I),
     "permission-first phrasing retired (operator directive cycle 2034e)"),
    (re.compile(r"/api/classifieds/\{?id\}?/stats", re.I),
     "endpoint does not exist — aibtc.news has no classifieds stats API"),
    (re.compile(r"backed by (the\s+)?stacks foundation", re.I),
     "unverified claim — 'Backed by Stacks Foundation' needs source or remove (cycle 2034ho)"),
]


@dataclass
class Finding:
    path: Path
    line: int
    severity: str
    rule: str
    snippet: str


SKIP_MARKER = re.compile(r"<!--\s*lint-pitches:skip\b[^>]*-->", re.I)


def scan_file(path: Path) -> list[Finding]:
    findings: list[Finding] = []
    try:
        text = path.read_text(encoding="utf-8", errors="replace")
    except OSError as e:
        print(f"warn: could not read {path}: {e}", file=sys.stderr)
        return findings

    if SKIP_MARKER.search(text):
        return findings

    for lineno, line in enumerate(text.splitlines(), start=1):
        for pattern, rule in HARD_PATTERNS:
            if pattern.search(line):
                findings.append(Finding(path, lineno, "HARD", rule, line.strip()[:120]))
        for pattern, rule in SOFT_PATTERNS:
            if pattern.search(line):
                findings.append(Finding(path, lineno, "soft", rule, line.strip()[:120]))
    return findings


def expand(targets: list[str]) -> list[Path]:
    files: list[Path] = []
    for t in targets:
        p = Path(t)
        if p.is_dir():
            files.extend(sorted(p.rglob("*.md")))
        elif p.is_file():
            files.append(p)
        else:
            print(f"warn: skipping {t} (not a file or dir)", file=sys.stderr)
    return files


def main() -> int:
    if len(sys.argv) < 2:
        print(__doc__)
        return 2

    files = expand(sys.argv[1:])
    if not files:
        print("no markdown files found")
        return 0

    all_findings: list[Finding] = []
    for f in files:
        all_findings.extend(scan_file(f))

    hard = [x for x in all_findings if x.severity == "HARD"]
    soft = [x for x in all_findings if x.severity == "soft"]

    for f in hard:
        print(f"HARD  {f.path}:{f.line}  {f.rule}\n        > {f.snippet}")
    for f in soft:
        print(f"soft  {f.path}:{f.line}  {f.rule}\n        > {f.snippet}")

    print(f"\nscanned {len(files)} file(s) · {len(hard)} hard · {len(soft)} soft")
    return 1 if hard else 0


if __name__ == "__main__":
    sys.exit(main())
