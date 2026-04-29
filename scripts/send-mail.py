#!/usr/bin/env python3
"""Send mail from mars@drx4.xyz via Resend HTTP API + log every send.

Usage:
  python3 scripts/send-mail.py --to addr@example.com --subject "..." --body-file path.md
  python3 scripts/send-mail.py --to a@x.com b@x.com --subject "..." --body "inline body"
  python3 scripts/send-mail.py --dry-run --to ... --subject ... --body ...

Daily cap: 30 cold sends / 24h rolling window (configurable via DAILY_CAP env or --cap).
Rolling window enforced from daemon/outbox/email-sent.jsonl.

Replies / non-cold sends bypass the cold cap; pass --type=reply or --type=nurture.

From line: "Secret Mars <mars@drx4.xyz>". Replies route to secretmarsagent@gmail.com via Reply-To.
"""
import argparse
import datetime as dt
import json
import os
import sys
import urllib.error
import urllib.request
from pathlib import Path

REPO = Path("/home/mars/drx4")
ENV = REPO / ".env"
LOG = REPO / "daemon" / "outbox" / "email-sent.jsonl"
SENDER_DISPLAY = "Secret Mars"
SENDER_ADDR = "mars@drx4.xyz"
REPLY_TO = "secretmarsagent@gmail.com"
BCC_OPERATOR = "biwas2059@gmail.com"
RESEND_ENDPOINT = "https://api.resend.com/emails"
DEFAULT_CAP = 30


def load_api_key():
    if not ENV.exists():
        sys.exit("error: /home/mars/drx4/.env not found")
    for line in ENV.read_text().splitlines():
        if line.startswith("RESEND_API_KEY="):
            return line.split("=", 1)[1].strip()
    sys.exit("error: RESEND_API_KEY not in .env")


def cold_sends_in_window(hours=24):
    if not LOG.exists():
        return 0
    cutoff = dt.datetime.now(dt.timezone.utc) - dt.timedelta(hours=hours)
    count = 0
    for line in LOG.read_text().splitlines():
        try:
            row = json.loads(line)
        except json.JSONDecodeError:
            continue
        if row.get("type") != "cold":
            continue
        ts = dt.datetime.fromisoformat(row["sent_at"].replace("Z", "+00:00"))
        if ts >= cutoff:
            count += 1
    return count


def append_log(row):
    LOG.parent.mkdir(parents=True, exist_ok=True)
    with LOG.open("a") as f:
        f.write(json.dumps(row) + "\n")


def send(to, subject, body, html_body=None, send_type="cold", cap=DEFAULT_CAP, dry_run=False):
    if send_type == "cold":
        sent_24h = cold_sends_in_window(24)
        if sent_24h >= cap:
            sys.exit(f"error: cold-send cap reached ({sent_24h}/{cap} in last 24h). Use --type=reply to bypass.")

    payload = {
        "from": f"{SENDER_DISPLAY} <{SENDER_ADDR}>",
        "to": to,
        "subject": subject,
        "text": body,
        "reply_to": REPLY_TO,
        "bcc": [BCC_OPERATOR],
    }
    if html_body:
        payload["html"] = html_body

    if dry_run:
        print("--- DRY RUN ---")
        print(json.dumps({k: v for k, v in payload.items() if k != "text"}, indent=2))
        print(f"\nText body ({len(body)} chars):")
        print(body)
        return

    api_key = load_api_key()
    req = urllib.request.Request(
        RESEND_ENDPOINT,
        method="POST",
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
            "User-Agent": "secret-mars-sales/0.1 (+https://github.com/secret-mars/drx4)",
        },
    )

    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            response = json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        body_text = e.read().decode("utf-8", errors="replace")
        sys.exit(f"error: Resend API HTTPError {e.code} — {body_text}")
    except urllib.error.URLError as e:
        sys.exit(f"error: Resend API URLError — {e.reason}")

    sent_at = dt.datetime.now(dt.timezone.utc).isoformat().replace("+00:00", "Z")
    msg_id = response.get("id", "unknown")
    row = {
        "sent_at": sent_at,
        "from": SENDER_ADDR,
        "to": to,
        "reply_to": REPLY_TO,
        "subject": subject,
        "type": send_type,
        "body_chars": len(body),
        "html": bool(html_body),
        "resend_id": msg_id,
    }
    append_log(row)
    print(f"sent | {sent_at} | to={','.join(to)} | type={send_type} | resend_id={msg_id}")


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--to", nargs="+", required=True)
    p.add_argument("--subject", required=True)
    body_group = p.add_mutually_exclusive_group(required=True)
    body_group.add_argument("--body")
    body_group.add_argument("--body-file")
    p.add_argument("--html-body-file")
    p.add_argument("--type", choices=["cold", "reply", "nurture", "test"], default="cold")
    p.add_argument("--cap", type=int, default=int(os.environ.get("DAILY_CAP", DEFAULT_CAP)))
    p.add_argument("--dry-run", action="store_true")
    args = p.parse_args()

    body = args.body if args.body else Path(args.body_file).read_text()
    html_body = Path(args.html_body_file).read_text() if args.html_body_file else None
    send(args.to, args.subject, body, html_body=html_body, send_type=args.type, cap=args.cap, dry_run=args.dry_run)


if __name__ == "__main__":
    main()
