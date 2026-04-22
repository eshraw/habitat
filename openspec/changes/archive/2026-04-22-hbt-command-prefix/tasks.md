## 1. Update Plugin Name

- [x] 1.1 Change `"name": "habitat"` to `"name": "hbt"` in `habitat-claude/.claude-plugin/plugin.json`

## 2. Update Documentation

- [x] 2.1 Replace all `habitat:` command references (e.g., `/habitat:water`) with `hbt:` in `README.md`
- [x] 2.2 Replace all `habitat:` command references with `hbt:` in `CLAUDE.md` (skill trigger descriptions and usage examples)

## 3. Verify

- [x] 3.1 Confirm command files in `habitat-claude/commands/` are unchanged (filenames stay as-is; plugin name drives the prefix)
- [x] 3.2 Reinstall / reload the plugin locally and verify `/hbt:habitat`, `/hbt:water`, `/hbt:info` are all discoverable in the slash-command picker
