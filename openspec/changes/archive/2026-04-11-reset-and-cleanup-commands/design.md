## Context

Habitat installs into the user's Claude Code environment by injecting entries into `~/.claude/settings.json` (permissions + hooks) and writing state to `~/.habitat/`. When a user uninstalls the plugin, none of these local artefacts are automatically removed — the hooks keep firing against a missing plugin directory, the state directory lingers, and the settings entries remain. There is also no way to start fresh without manually deleting `~/.habitat/plant.json`.

The `habitat-init` command name is longer than necessary; `init` is the idiomatic short form and aligns with how other tools name their bootstrap commands.

## Goals / Non-Goals

**Goals:**

- Add `/hbt:reset` — lets a user wipe their current plant and start fresh with a new random species
- Add `/hbt:clean` — removes all Habitat-owned local state and settings entries; designed to be the last thing run before or after uninstalling the plugin
- Rename `/hbt:habitat-init` → `/hbt:init` — shorter name, no behavior change
- Ensure clean removes exactly what init created (permissions entry, hooks entries, `~/.habitat/` directory)

**Non-Goals:**

- Automatic cleanup on plugin uninstall (Claude Code plugin lifecycle doesn't expose an uninstall hook)
- Cloud sync or backup of plant state before reset/clean
- Undo / restore for reset or clean

## Decisions

### 1. `/hbt:reset` asks Claude to confirm before destroying state

**Decision**: The reset command prompt instructs Claude to ask the user for confirmation ("your plant will be lost forever") before calling `habitat_init.sh`.

**Rationale**: Reset is irreversible. A misfire in `/hbt:reset` would lose the user's entire plant progression. Putting the confirmation in the prompt (rather than the shell script) keeps hook scripts dumb and lets Claude's response reflect the plant's personality ("Are you sure you want to abandon Fern?").

**Alternative considered**: Shell-level `read` prompt in a new `reset.sh`. Rejected — interactive stdin in a shell script called from a Claude command is unreliable and violates the "hooks must not block" principle.

### 2. `/hbt:clean` is a shell script, not a pure Claude prompt

**Decision**: The clean command prompt calls a new `habitat_clean.sh` script that performs the actual deletions and settings mutations, then reports back.

**Rationale**: The cleanup operations (jq mutations on `settings.json`, `rm -rf ~/.habitat`) are deterministic shell operations that must not be paraphrased or hallucinated by Claude. Shell handles them reliably. Claude's role is to confirm the action with the user first and interpret the result.

**Alternative considered**: Inline the cleanup in the prompt with Bash tool calls. Rejected — Bash tool calls from slash commands require user permission prompts on every step, which is annoying for a multi-step cleanup.

### 3. Rename is file-only — no compatibility shim

**Decision**: Delete `habitat-init.md`, create `init.md`. No redirect or alias.

**Rationale**: There is no versioned API contract here. The command name lives in the user's plugin install; updating the file is sufficient. Adding a shim file that just says "use /hbt:init now" adds noise.

### 4. `habitat_clean.sh` removes only what `habitat_init.sh` wrote

**Decision**: The clean script removes:
- `~/.habitat/` directory (state + any future subdirs)
- The `Read(~/.habitat/**)` entry from `settings.json` permissions
- The `on_tool.sh` and `on_stop.sh` hook entries from `settings.json`

It does NOT touch any other permissions or hooks the user may have configured.

**Rationale**: Minimal blast radius. The script uses `jq` to surgically remove only the exact entries that init injected, identified by the plugin path pattern (`plugins/marketplaces/habitat`).

## Risks / Trade-offs

- **Risk**: User runs `/hbt:clean` then re-installs — hooks are gone until they run `/hbt:init` again. → Mitigation: clean output explicitly says "run /hbt:init to set up again."
- **Risk**: settings.json has been manually edited and the hook entries don't match the exact jq filter. → Mitigation: clean script uses a path-pattern match (`contains("habitat")`) rather than exact string equality, so minor edits don't break removal.
- **Risk**: rename breaks users who muscle-memoried `/hbt:habitat-init`. → Mitigation: it's a young plugin with a small user base; the README and install.sh output are updated in the same change.

## Migration Plan

1. Delete `habitat-claude/commands/habitat-init.md`
2. Create `habitat-claude/commands/init.md` (same prompt content)
3. Create `habitat-claude/commands/reset.md`
4. Create `habitat-claude/commands/clean.md`
5. Create `habitat-claude/scripts/habitat_clean.sh`
6. Update `install.sh` to copy `init.md` instead of `habitat-init.md` and reference `/hbt:init` in its output message
7. Update `README.md` references

No rollback needed — all changes are additive or rename-only within a local install. Users on the old plugin install simply won't have the new commands until they reinstall.
