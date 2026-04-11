## Why

Users have no way to reset their plant to a fresh state, clean up the lingering local files left behind when uninstalling the plugin, or run the init command without typing the full `habitat-init` name. These gaps make the plugin feel incomplete and leave debris on the user's machine after removal.

## What Changes

- **New**: `/hbt:reset` command — wipes the current plant and spawns a fresh one (prompts for confirmation first)
- **New**: `/hbt:clean` command — removes all Habitat local state (`~/.habitat/`), installed hooks, and any Claude settings entries injected by Habitat; designed to be run before or after uninstalling the plugin to leave no trace
- **Rename**: `/hbt:habitat-init` → `/hbt:init` — shorter, more intuitive command name for bootstrapping Habitat; old command file is removed

## Capabilities

### New Capabilities

- `reset-command`: Slash command that confirms with the user then deletes the current `~/.habitat/plant.json` and spawns a fresh plant via the init script
- `clean-command`: Slash command that removes all Habitat-managed local state and settings (state file, hooks registered in Claude settings, any injected config) so uninstalling leaves no trace

### Modified Capabilities

- `habitat-init-command`: Rename the command from `habitat-init` to `init` — the command file, all references, and the plugin manifest entry change; no requirement changes beyond the identifier

## Impact

- `habitat-claude/commands/habitat-init.md` → renamed to `habitat-claude/commands/init.md`
- `habitat-claude/.claude-plugin/plugin.json` — command registration updated
- `habitat-claude/commands/reset.md` — new file
- `habitat-claude/commands/clean.md` — new file
- `habitat-claude/scripts/habitat_init.sh` — referenced by reset command (reused as-is)
- `install.sh` — may reference `habitat-init`; needs update
- User-facing docs and README references to `habitat-init` need updating
