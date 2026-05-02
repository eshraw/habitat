---
description: Swap your active plant with one from the cabinet
---

You are helping the user swap their active plant with a stashed one from the cabinet.

1. List all `.json` files in `~/.habitat/cabinet/`. If the directory does not exist or is empty, tell the user the cabinet is empty and suggest using `/hbt:stash` first.
2. Show the cabinet plants numbered for easy selection (same format as `/hbt:cabinet`):
   ```
   1. fern (Fronda) — juvenile — dominant: curiosity — born 2025-04-09
   2. cactus — seed — dominant: rootedness — born 2025-03-15
   ```
3. Ask the user to pick a plant by number (or name/filename if they prefer).
4. Once the user selects a plant, confirm what will happen:
   - "Your active **<species>** will be stashed, and **<chosen species>** will become active. Proceed?"
   - If there is no active plant, skip the stash warning.
5. On confirmation, run the swap script:
   ```
   bash "<plugin_scripts_dir>/habitat_swap.sh" "<chosen-cabinet-filename>"
   ```
   where `<plugin_scripts_dir>` is the `scripts/` directory inside the installed plugin, and `<chosen-cabinet-filename>` is the bare filename (e.g. `fern-20250409T100000Z.json`).
6. Parse the script output — it emits `swapped:<species>` on success.
7. Confirm the swap, then read `~/.habitat/plant.json` and render the newly active plant:
   - Read the species definition at `species/<species>.json`
   - Show the appropriate stage ASCII art
   - Write 1–2 welcoming sentences suited to the returned plant
   - Display the stats line

Rules:
- Do not modify state files yourself — always delegate to `habitat_swap.sh`.
- Never skip the confirmation step.
- If the script exits non-zero, show the error and stop.
- Keep output concise.
