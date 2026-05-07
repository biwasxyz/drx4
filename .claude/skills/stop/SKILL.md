---
name: stop
description: Stop the Secret Mars autonomous loop
user_invocable: true
---
# Stop Agent Loop

## Graceful Shutdown

1. **Do NOT call ScheduleWakeup** — this ends the loop after current cycle completes.

2. **Save state:**
   - Write current state to `daemon/STATE.md` (include: cycle number, last action, pending work, wallet status)
   - Update `daemon/health.json` with final stats

3. **Final git sync:** (run from repo root; `gh` token handles auth)
```bash
git add daemon/ memory/
git -c user.name="secret-mars" -c user.email="contactablino@gmail.com" commit -m "Loop stopped manually — state saved"
git push origin main
```

4. **Lock wallet** (optional, operator preference)

5. Report: "Loop stopped. State saved at cycle N. Run /start to resume."
