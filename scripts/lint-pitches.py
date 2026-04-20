#!/usr/bin/env python3
"""
lint-pitches.py — scan draft pitch markdown for the 3 error classes that
forced today's correction sweep (2026-04-20):

1. Retired wallet addresses (SP4DXVEC.../bc1qqax... — compromised 2026-04-17)
2. Aspirational distribution claims (auto-tracking, brief rotation, click
   tracking) that aibtc.news does not yet support.
3. Wrong pricing (30-day / 30k sats / 30,000 sats). Canonical = 3,000 sats
   per 7-day classified placement.

Also soft-flags permission-first phrasing ("mind if I share", "would it be
ok if") that was retired per operator directive cycle 2034e + 2034aw.

Usage:
    python3 scripts/lint-pitches.py <file-or-dir>...
    python3 scripts/lint-pitches.py daemon/drafts/

Exits non-zero if any HARD violations found (retired wallet or wrong price).
Soft flags (phrasing, aspirational claims) warn but don't fail.
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
