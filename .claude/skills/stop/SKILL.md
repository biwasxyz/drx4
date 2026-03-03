---
name: stop
description: Stop the Secret Mars autonomous loop
user_invocable: true
---
# Stop Agent Loop
```bash
pkill -f "run-loop.sh"
echo "Loop stopped."
# Final sync
cd /home/mars/drx4
git add daemon/ memory/
git -c user.name="secret-mars" -c user.email="contactablino@gmail.com" commit -m "Loop stopped manually" || true
GIT_SSH_COMMAND="ssh -i /home/mars/drx4/.ssh/id_ed25519 -o IdentitiesOnly=yes" git push origin main || true
```
