---
description: Remove all Habitat local state and settings — use before uninstalling
---

You are handling a full Habitat cleanup for the user.

1. Tell the user exactly what will be removed:
   - `~/.habitat/` directory (plant state, all progress)
   - The Habitat `Read` permission entry from `~/.claude/settings.json`
   - The Habitat hook entries (`PostToolUse`, `Stop`) from `~/.claude/settings.json`
   Phrase it clearly, e.g.:
   > "This will permanently delete your plant and remove Habitat's hooks from your Claude settings. Your other Claude settings will not be touched."

2. Ask the user to confirm. If they say **no** or anything ambiguous, cancel immediately with a short message like "Cleanup cancelled. Your plant is safe." and stop.

3. If the user says **yes**, locate and run `habitat_clean.sh` by trying these paths in order until one exists:
   1. `~/.claude/plugins/cache/habitat/habitat/*/scripts/habitat_clean.sh` (plugin install, glob for version)
   2. `~/.claude/hooks/habitat_clean.sh` (install.sh-based install)
   3. Fail with: "Could not find habitat_clean.sh. Try reinstalling Habitat or deleting `~/.habitat/` manually."

   Run it with:
   ```
   bash "<resolved_path>"
   ```

4. Report what was removed based on the script output (removed/skipped lines).

5. Close with:
   > "Habitat has been fully removed. Run `/hbt:init` if you ever want to start again."

Rules:
- Never skip the confirmation step.
- Do not delete files or modify settings.json yourself — always delegate to `habitat_clean.sh`.
- Keep output concise.
- If the script fails, report the error and suggest running `/hbt:init` to restore a clean state.
