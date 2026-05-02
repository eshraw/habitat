---
description: Stash your current plant into the cabinet
---

You are stashing the user's active plant into the cabinet.

1. Check that `~/.habitat/plant.json` exists. If not, tell the user there is no active plant to stash and suggest running `/hbt:init`.
2. Read the plant's species and name (if set) from `~/.habitat/plant.json`.
3. Run the stash script:
   ```
   bash "<plugin_scripts_dir>/habitat_stash.sh"
   ```
   where `<plugin_scripts_dir>` is the `scripts/` directory inside the installed plugin.
4. Parse the script output — it emits `stashed:<filename>` on success.
5. Confirm to the user with the plant's identity, e.g.:
   - "Your **fern** has been tucked into the cabinet as `fern-20250409T100000Z.json`."
   - If the plant has a name: "Your **fern** named **Fronda** is safely stored in the cabinet."
6. Tell the user the active slot is now empty — invoking `/hbt:habitat` will start a fresh plant.
7. Mention `/hbt:cabinet` to view stashed plants and `/hbt:swap` to bring one back.

Rules:
- Do not modify state files yourself — always delegate to `habitat_stash.sh`.
- If the script exits non-zero, show the error and stop.
- Keep tone warm and brief.
