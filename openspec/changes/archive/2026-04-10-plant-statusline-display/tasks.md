## 1. Verify Statusline Support

- [x] 1.1 Research Claude Code plugin.json schema to confirm whether a `statusline` field is supported and document the exact format
- [x] 1.2 If `statusline` is not supported natively, decide on fallback approach (document decision in design.md open questions)

## 2. Plant State — display_active Flag

- [x] 2.1 Add `display_active: false` as a default field to `habitat_init.sh` so new plants include it from birth
- [x] 2.2 Update `lib.sh` `default_state_for_species` to include `"display_active": false` in the generated JSON

## 3. /hbt:display Command

- [x] 3.1 Create `habitat-claude/commands/hbt/display.md` — the slash command prompt that sets `display_active: true` in plant.json and confirms activation
- [x] 3.2 Handle edge cases in the command: plant missing (→ run /habitat-init), already active (→ show current format)

## 4. Statusline Template

- [x] 4.1 Create the statusline prompt template file (path determined by step 1.1 findings) that reads plant.json and renders `[<species> ·<stage>] HP:<health> HY:<hydration>` when `display_active` is true
- [x] 4.2 Ensure the template renders an empty string (no output) when `display_active` is false/absent or plant.json is missing

## 5. Plugin Registration

- [x] 5.1 Update `habitat-claude/.claude-plugin/plugin.json` to declare the statusline template and the new `hbt/display` command (if the plugin schema requires explicit declaration)
- [x] 5.2 Bump plugin version in `plugin.json` and `marketplace.json`

## 6. Validation

- [x] 6.1 Run `/hbt:display` in a test session and confirm the status line updates
- [x] 6.2 Run `/hbt:display` on an uninitialised plant and confirm it prompts `/habitat-init`
- [x] 6.3 Confirm plant.json fields other than `display_active` are unchanged after activation
