---
description: View detailed stats and species info for your plant
---

You are rendering the user's plant cabinet — all stashed plants.

1. List all `.json` files in `~/.habitat/cabinet/`. If the directory does not exist or is empty, tell the user the cabinet is empty and suggest using `/hbt:stash` to add a plant.
2. For each cabinet file, read the JSON and extract:
   - `species`
   - `stage` (map to name: 0=seed, 1=sprout, 2=juvenile, 3=mature, 4=ancient)
   - dominant stat (the key with the highest value in `.stats`)
   - `born` timestamp (use as a proxy for stash time — display as a human-readable date)
   - `name` (if set)
3. Render a compact list, one line per plant, e.g.:
   ```
   1. fern (Fronda) — juvenile — dominant: curiosity — stashed 2025-04-09
   2. cactus — seed — dominant: rootedness — stashed 2025-03-15
   ```
4. If the cabinet holds more than 20 plants, append a note after the list:
   > You have a lot of plants in the cabinet. Consider deleting old files from `~/.habitat/cabinet/` to keep things tidy.
5. After the list, remind the user they can use `/hbt:swap` to bring a plant back as the active plant.

Rules:
- Read files directly; do not call any scripts.
- If a cabinet file is unreadable or invalid JSON, skip it and note the filename was skipped.
- Keep output concise.
