## Why

The plant currently only appears when the user explicitly runs `/habitat`, requiring active effort to check in. A persistent, passive presence next to the Claude Code input bar would make the plant feel genuinely alive — always visible, always reacting — without interrupting the user's flow.

## What Changes

- Add a new `/hbt:display` slash command that activates a compact single-line plant display in the Claude Code status line.
- The status line renders a minimal representation: species emoji or ASCII token, a key stat indicator, and hydration/health glance values.
- The display activates on-demand (user runs `/hbt:display`) and persists for the session.
- The display reads from `~/.habitat/plant.json` and refreshes on each new Claude turn.

## Capabilities

### New Capabilities
- `statusline-plant-display`: Compact plant representation rendered in the Claude Code status line, activated by `/hbt:display`, showing species token + dominant stat + glance stats, persistent for the session.

### Modified Capabilities
<!-- None — existing rendering logic in habitat-command-rendering is unchanged; this adds a parallel display surface. -->

## Impact

- New command file: `habitat-claude/commands/hbt/display.md`
- Requires Claude Code statusline API support (the `statusline` field in plugin.json or a supported hook output format)
- Reads `~/.habitat/plant.json` (already permitted)
- No changes to plant state, hooks, or species files
- No new dependencies
