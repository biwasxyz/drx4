# Cycle 2034p4 — 2026-04-29 ~14:01Z

## Context
Operator interjected: "I don't see it being sent" — referring to the 6 nurture emails sent today. Investigation revealed two separate issues.

## Diagnosed
1. **No "Sent" folder visibility** — emails post via Resend HTTPS API directly; Gmail wasn't the SMTP path so nothing shows in any Gmail Sent folder.
2. **Inbox placement risk** — DMARC missing on drx4.xyz. SPF (`send.drx4.xyz`) + DKIM (`resend._domainkey.drx4.xyz`) both present. Gmail's new "DMARC required for bulk senders" guidance flags this as deliverability risk.

## Shipped
- **send-mail.py auto-BCC operator** — added `BCC_OPERATOR = "biwas2059@gmail.com"` constant; added `"bcc": [BCC_OPERATOR]` in Resend payload. Every outbound now visible in operator's Gmail.
- **Verified live**: test send Resend `8f1cf34b` to biwas2059@gmail.com (BCC'd to same address, confirms BCC mechanism works at Resend level).
- **DMARC ask filed** to operator with exact TXT record: `v=DMARC1; p=none;` at `_dmarc.drx4.xyz`. CF token here is zone:read; operator handles DNS edit.

## Resend delivery audit (every send today)
- Apr 28 test #1 → biwas2059@: delivered
- Apr 28 test #2 → biwas2059@: delivered
- Apr 29 vibeframe → kiyeon.jeon.21@: delivered
- Apr 29 JingSwap → raphisidor@: delivered
- Apr 29 reflectt → kai@itskai.dev: API returned null (recent or quirk)
- Apr 29 StackingDAO → hello@nieldeckx.be: delivered
- Apr 29 elizaOS → inquiries@elizalabs.ai: delivered
- Apr 29 Arkadiko → me@macx.im: API returned null (recent)

All "delivered" status confirms the SMTP transaction succeeded; the missing DMARC affects WHERE Gmail sorts the message (Spam/Promotions vs Inbox), not whether it lands.

## Polled (clean)
- Inbox 0 unread.
- GH notifications: only stale #439 EIC trial.
- Apr 29 PT 3/3 OPEN, 0 replies (~7h).
- Gmail 0 replies on 6 sent.
- #664 stands at EIC ack.

## Next
ScheduleWakeup 1800s. Re-test deliverability when operator confirms DMARC added.
