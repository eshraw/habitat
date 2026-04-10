---
description: Water your plant to restore hydration
---

You are watering the user's Habitat plant.

1. Read `~/.habitat/plant.json`. If missing, tell the user to run `/habitat-init`.
2. Check `stats.hydration`:
   - If hydration >= 90, respond warmly that the plant doesn't need water right now and show current hydration. Stop here.
3. Read `stats.hydration` from the file for display purposes only.
4. Run this bash command to atomically update the file:
   ```bash
   tmp=$(mktemp) && jq '.stats.hydration = ([.stats.hydration + 20, 100] | min) | .last_seen = (now | todate)' ~/.habitat/plant.json > "$tmp" && mv "$tmp" ~/.habitat/plant.json
   ```
5. Show a single short line confirming the watering, e.g. `💧 Watered. Hydration: 48 → 68.`

Rules:
- Do not use the Read/Write file tools to update plant.json — use the bash command above to avoid race conditions with hooks.
- Do not change any stat other than `hydration` and `last_seen`.
- Keep the response to 1–2 lines. No commentary beyond the confirmation.
- If the bash command fails, tell the user and suggest checking file permissions.
