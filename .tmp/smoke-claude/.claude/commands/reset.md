---
description: Reset your plant and start fresh with a new companion
---

You are handling a plant reset for the user.

1. Read `~/.habitat/plant.json`.
2. If the file does not exist, tell the user there is no plant to reset and suggest running `/hbt:init`.
3. If the plant exists, ask the user for confirmation before proceeding. Reference the plant's species (and name if set) in the message, e.g.:
   - "Your **fern** will be lost forever. Are you sure you want to start over?"
   - If the plant has a name: "Your **fern** named **Fronda** will be lost forever. Are you sure?"
   Keep the tone warm but clear that this is irreversible.
4. If the user says **no** or anything ambiguous, cancel immediately. Say something brief like "Your plant is safe." and stop.
5. If the user says **yes**, run:
   ```
   bash "<plugin_scripts_dir>/habitat_init.sh" --force
   ```
   where `<plugin_scripts_dir>` is the `scripts/` directory inside the installed plugin.
   The `--force` flag causes `habitat_init.sh` to overwrite existing state unconditionally.
6. After the script succeeds, read the new `~/.habitat/plant.json` and render the fresh plant:
   - Read the species definition at `species/<new_species>.json`
   - Show the seed-stage ASCII art (`stage_art.seed`)
   - Write 1–2 welcoming sentences suited to the new species (e.g. "A tiny cactus spine pokes through the soil. It has a long memory and slow patience.")
   - Display the baseline stats line: `HP:80 GR:45 HY:60 CU:70 RT:55 XP:0 ST:0`

Rules:
- Never skip the confirmation step.
- Do not modify the state file yourself — always delegate to `habitat_init.sh`.
- Keep output concise.
- If the script fails, report the error clearly and suggest running `/hbt:init` manually.
