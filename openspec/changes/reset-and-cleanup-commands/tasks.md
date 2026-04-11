## 1. Rename habitat-init to init

- [x] 1.1 Rename `habitat-claude/commands/habitat-init.md` to `habitat-claude/commands/init.md`
- [x] 1.2 Update the prompt text inside `init.md` to reference `/hbt:init` (not `/hbt:habitat-init` or `/habitat-init`)
- [x] 1.3 Update `install.sh` to copy `init.md` instead of `habitat-init.md`
- [x] 1.4 Update the `install.sh` post-install message from `run /habitat-init` to `run /hbt:init`
- [x] 1.5 Update `README.md` — replace all references to `/habitat-init` with `/hbt:init`

## 2. Add reset command

- [x] 2.1 Create `habitat-claude/commands/reset.md` — prompt instructs Claude to read current plant state, ask for confirmation referencing the plant species/name, then run `habitat_init.sh` with force if confirmed
- [x] 2.2 After confirmed reset, have the prompt instruct Claude to render the new plant inline (reuse habitat.md rendering logic)

## 3. Add clean script

- [x] 3.1 Create `habitat-claude/scripts/habitat_clean.sh` — removes `~/.habitat/` directory
- [x] 3.2 In `habitat_clean.sh`, remove the `Read(~/.habitat/**)` permission entry from `~/.claude/settings.json` using `jq` (match by exact string)
- [x] 3.3 In `habitat_clean.sh`, remove Habitat hook entries from `settings.json` `.hooks.PostToolUse` and `.hooks.Stop` arrays — match entries whose `command` field contains the `habitat` plugin path
- [x] 3.4 Ensure `habitat_clean.sh` is non-destructive when entries are already absent (idempotent)
- [x] 3.5 Make `habitat_clean.sh` executable (`chmod +x`)

## 4. Add clean command

- [x] 4.1 Create `habitat-claude/commands/clean.md` — prompt instructs Claude to describe what will be removed (state dir + settings entries), ask for confirmation, then run `habitat_clean.sh` if confirmed
- [x] 4.2 After clean completes, prompt instructs Claude to tell the user they can run `/hbt:init` to set Habitat up again

## 5. Update install.sh for new files

- [x] 5.1 Add `copy_if_changed` calls in `install.sh` for `reset.md`, `clean.md`, and `habitat_clean.sh`
- [x] 5.2 Ensure `habitat_clean.sh` is marked executable after copy in `install.sh`

## 6. Verify

- [x] 6.1 Run `install.sh` locally and confirm `init.md`, `reset.md`, `clean.md`, and `habitat_clean.sh` are installed to the expected destination
- [ ] 6.2 Invoke `/hbt:init` — confirm it runs and leaves state intact if already initialized
- [ ] 6.3 Invoke `/hbt:reset` — confirm confirmation prompt fires, and after confirming, state is wiped and new plant renders
- [ ] 6.4 Invoke `/hbt:clean` — confirm confirmation prompt fires, and after confirming, `~/.habitat/` is removed and settings entries are gone
