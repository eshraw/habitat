---
description: Activate the persistent plant display in the Claude Code status line
---

You are activating the Habitat plant status line display.

1. Check that `~/.habitat/plant.json` exists. If it does not, stop and tell the user to run `/habitat-init` first.

2. Read `~/.habitat/plant.json`. Check whether the statusline infrastructure is fully in place by verifying **all three**:
   - `display_active` is `true` in plant.json
   - `~/.claude/hooks/habitat_statusline.sh` exists
   - `~/.claude/settings.json` contains a `statusLine` key

   Only if all three are true, tell the user the display is already active and show what it looks like: `🌿 <species> [·<stage>] HP:<health> HY:<hydration>`. Stop here. Otherwise proceed to step 3 to set up whatever is missing.

3. Run the following bash commands **in order**:

   a. Write the statusline script to `~/.claude/hooks/`:
   ```bash
   mkdir -p ~/.claude/hooks
   cat > ~/.claude/hooks/habitat_statusline.sh << 'SCRIPT'
   #!/usr/bin/env bash
   plant="${HOME}/.habitat/plant.json"
   [ -f "$plant" ] || exit 0
   jq -er 'if (.display_active // false) then "🌿 \(.species) [·\(.stage)] HP:\(.stats.health) HY:\(.stats.hydration)" else "" end' "$plant" 2>/dev/null || true
   SCRIPT
   chmod +x ~/.claude/hooks/habitat_statusline.sh
   ```

   b. Set `display_active: true` in plant.json atomically:
   ```bash
   tmp=$(mktemp) && jq '.display_active = true' ~/.habitat/plant.json > "$tmp" && mv "$tmp" ~/.habitat/plant.json
   ```

   c. Add `statusLine` to `~/.claude/settings.json` only if it is not already set:
   ```bash
   tmp=$(mktemp) && jq 'if has("statusLine") then . else .statusLine = {"type": "command", "command": "~/.claude/hooks/habitat_statusline.sh"} end' ~/.claude/settings.json > "$tmp" && mv "$tmp" ~/.claude/settings.json
   ```

4. Confirm success with a single line:
   > Display activated. Your plant will appear as: `🌿 <species> [·<stage>] HP:<health> HY:<hydration>`
   > Run `/reload-plugins` to apply.

Rules:
- Do not modify any plant stat other than `display_active`.
- Do not overwrite an existing `statusLine` config in settings.json — if one already exists, tell the user to manually add `~/.claude/hooks/habitat_statusline.sh` to their statusline setup.
- Keep the response to 2–3 lines max.
