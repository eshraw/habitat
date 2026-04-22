## Context

Habitat commands are currently registered under the `habitat:` prefix (e.g., `habitat:water`, `habitat:info`). Command file names in `habitat-claude/commands/` follow the pattern `habitat-<subcommand>.md`, and the plugin manifest declares them accordingly. The prefix appears in Claude Code's slash-command picker and in skill trigger descriptions, making it longer than necessary.

## Goals / Non-Goals

**Goals:**
- Rename all slash commands from `habitat:<cmd>` to `hbt:<cmd>`
- Update the plugin manifest and any internal references
- Update user-facing documentation and skill descriptions

**Non-Goals:**
- Changing command behavior or prompts
- Modifying hook scripts or plant state schema
- Providing a compatibility shim or alias for the old `habitat:` prefix

## Decisions

**1. Rename command files directly (no aliases)**
Files in `habitat-claude/commands/` will be renamed from `habitat-<cmd>.md` to `hbt-<cmd>.md`. Claude Code derives the slash-command name from the filename, so this is the single source of truth.
- Alternative: keep old filenames and add aliases in `plugin.json`. Rejected — aliases add complexity and the old names offer no value to retain.

**2. Update plugin manifest in-place**
`plugin.json` skill name entries are updated to use `hbt:` prefix. No schema changes needed.

**3. Bulk find-and-replace in documentation**
All occurrences of `habitat:` (as a command reference) in `README.md`, `CLAUDE.md`, and skill description strings are replaced with `hbt:`. Plain English uses of the word "habitat" are left unchanged.

## Risks / Trade-offs

- **Existing users have memorised `habitat:` commands** → Low risk: the command picker autocompletes, so discovery is easy. No state or data is affected.
- **Skill trigger descriptions in plugin.json must be kept consistent** → Mitigation: update all in one pass; the task list enumerates every file.

## Migration Plan

1. Rename command files
2. Update `plugin.json` command name entries
3. Update README, CLAUDE.md, and skill description strings
4. Verify with `openspec` status and a quick local test of `/hbt:habitat`

Rollback: revert the file renames and manifest entries — no data migration involved.

## Open Questions

None.
