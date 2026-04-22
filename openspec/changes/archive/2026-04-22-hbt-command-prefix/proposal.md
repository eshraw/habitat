## Why

Command names like `habitat:water` and `habitat:info` are verbose in the slash-command picker and status line, adding visual noise without adding clarity once users know the plugin. A shorter `hbt:` prefix keeps commands discoverable while reducing clutter in the UI.

## What Changes

- All user-facing slash commands are renamed from `habitat:<command>` to `hbt:<command>` (e.g., `habitat:water` → `hbt:water`, `habitat:info` → `hbt:info`)
- Command files in `habitat-claude/commands/` are renamed to match the new prefix
- The plugin manifest (`plugin.json`) and any references to command names are updated
- Documentation (README, CLAUDE.md, skill descriptions) is updated to reflect the new names

## Capabilities

### New Capabilities
<!-- none -->

### Modified Capabilities
- `habitat-command-rendering`: Command invocation name changes from `habitat` to `hbt`; all sub-commands (`water`, `info`, `clue`, `display`, `reset`, `init`, `clean`) adopt the `hbt:` prefix

## Impact

- `habitat-claude/commands/` — all `.md` command files renamed
- `habitat-claude/.claude-plugin/plugin.json` — command name declarations updated
- `.claude/settings.json` (local dev) — any hook or permission references updated
- `README.md`, `CLAUDE.md`, skill trigger descriptions — documentation updated
- No breaking changes to plant state (`~/.habitat/plant.json`) or hook scripts
