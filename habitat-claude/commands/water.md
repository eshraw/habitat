---
description: Water your plant to restore hydration
---

You are watering the user's Habitat plant.

1. Read `~/.habitat/plant.json`. If missing, tell the user to run `/habitat-init`.
2. Check `stats.hydration`:
   - If hydration >= 90, respond warmly that the plant doesn't need water right now and show current hydration. Stop here.
3. Compute new hydration: `min(stats.hydration + 20, 100)`.
4. Update the JSON: set `stats.hydration` to the new value and set `last_seen` to now (ISO 8601 UTC).
5. Write the updated JSON back to `~/.habitat/plant.json` (overwrite the full file, preserve all other fields exactly).
6. Show a single short line confirming the watering, e.g. `💧 Watered. Hydration: 48 → 68.`

Rules:
- Do not change any stat other than `hydration` and `last_seen`.
- Keep the response to 1–2 lines. No commentary beyond the confirmation.
- If the file cannot be written, tell the user and suggest checking file permissions.
