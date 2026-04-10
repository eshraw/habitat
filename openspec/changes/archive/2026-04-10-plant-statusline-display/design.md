## Context

Claude Code supports a `statusline` field in plugin configuration (`plugin.json`) that renders a persistent one-line string next to the input bar throughout a session. Habitat already has a plant state file at `~/.habitat/plant.json` and a read permission declared in the user's `settings.json`. The current plant display only appears when the user runs `/habitat` — a pull model. This change introduces an opt-in push model: once activated with `/hbt:display`, the plant is visible passively every turn.

The statusline is driven by a prompt template that Claude evaluates at each turn. The template reads plant state and produces a compact string. Claude Code's plugin system supports declaring a `statusline` prompt file in `plugin.json`.

## Goals / Non-Goals

**Goals:**
- Render a compact plant presence in the Claude Code status line after `/hbt:display` is run
- Show enough information to be meaningful at a glance (species identity, dominant stat, two key stat values)
- Work entirely from existing infrastructure (plant.json, species files, plugin.json)

**Non-Goals:**
- Real-time stat updates mid-turn (status line refreshes per-turn, not continuously)
- Animated or multi-line display
- Automatic activation without user consent — always opt-in via `/hbt:display`
- Modifying plant state from the status line

## Decisions

**Decision: Use Claude Code's native `statusline` plugin field, not a custom hook output**
The `statusline` field in `plugin.json` accepts a path to a prompt template. Claude evaluates it each turn and the result is rendered by the harness. This is the correct integration point — hooks are for state mutation, not display.
Alternatives considered: A `PostToolUse` hook that writes to a temp file — rejected because it's a side-channel hack and relies on undocumented behavior.

**Decision: `/hbt:display` writes a session flag, not a permanent setting**
The command writes a `display_active: true` flag to `~/.habitat/plant.json`. The statusline template checks this flag before rendering — if false/absent, it renders nothing. This keeps activation session-scoped and opt-in without touching `settings.json`.
Alternatives considered: Always-on statusline — rejected because some users will find it distracting; opt-in respects preference.

**Decision: Compact format — species token + stage glyph + two stats**
Format: `[🌿 fern ·2] HP:70 HY:60`
This fits in ~30 characters, is readable at a glance, and uses only data already in `plant.json`. No species file read needed in the statusline template (keeps it fast).
Alternatives considered: Full stat bar — too wide for a status line; emoji-only — not informative enough.

## Risks / Trade-offs

- **[Risk] statusline plugin field may not exist in current Claude Code version** → Mitigation: verify against docs before implementation; if unsupported, the command can output the compact line as a regular response instead and document the limitation.
- **[Risk] display_active flag persists across sessions** → Mitigation: `on_stop.sh` can clear it on session end, or the flag can be ignored — re-running `/hbt:display` is the activation ritual and that's fine.
- **[Risk] statusline template fires every turn and reads a file** → Mitigation: the read is local disk only, sub-millisecond; no external calls permitted per CLAUDE.md hook rules. Acceptable.

## Open Questions

~~Does the current Claude Code version expose a `statusline` plugin field?~~

**Resolved:** `statusLine` (camelCase) lives in `settings.json`, not `plugin.json`. Format:
```json
{ "statusLine": { "type": "command", "command": "path/to/script.sh" } }
```
The script receives session metadata on stdin and prints plain text to stdout. No prompt template support. The `/hbt:display` command must write the shell script to `~/.claude/hooks/habitat_statusline.sh` and inject `statusLine` into `~/.claude/settings.json`. Existing `statusLine` config is left untouched (display is opt-in per user).
