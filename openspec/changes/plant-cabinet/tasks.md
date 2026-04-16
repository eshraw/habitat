## 1. Bootstrap cabinet storage

- [ ] 1.1 Update `habitat_init.sh` to create `~/.habitat/cabinet/` alongside `~/.habitat/`
- [ ] 1.2 Update `habitat-init.md` command prompt to reflect that init also sets up the cabinet directory

## 2. Stash command

- [ ] 2.1 Create `commands/habitat-stash.md` — prompt that reads `~/.habitat/plant.json`, writes it to `~/.habitat/cabinet/<species>-<born-slug>.json` (via a shell script or inline jq), and confirms to the user
- [ ] 2.2 Create `scripts/habitat_stash.sh` — shell script that performs the actual file copy with `mkdir -p ~/.habitat/cabinet` guard and slug-collision detection (append 4-char hex suffix if filename exists)
- [ ] 2.3 After stash, clear `~/.habitat/plant.json` so the active slot is empty (ready for a new plant on next `/habitat` invocation)

## 3. Cabinet list command

- [ ] 3.1 Create `commands/habitat-cabinet.md` — prompt that reads all JSON files in `~/.habitat/cabinet/`, renders a summary list (species, stage, dominant stat, stash timestamp), and handles the empty-cabinet case
- [ ] 3.2 Add the >20 plants warning to the cabinet prompt rendering logic

## 4. Swap command

- [ ] 4.1 Create `commands/habitat-swap.md` — prompt that lists cabinet plants and asks the user to pick one, then calls the swap script
- [ ] 4.2 Create `scripts/habitat_swap.sh` — shell script that takes a cabinet filename as argument, writes the chosen cabinet file to `~/.habitat/plant.json` (stashing the current active plant first using stash logic), then removes the chosen file from the cabinet using write-then-delete ordering

## 5. Plugin manifest and command wiring

- [ ] 5.1 Register `habitat-stash`, `habitat-cabinet`, and `habitat-swap` in `habitat-claude/.claude-plugin/plugin.json` under the commands list
- [ ] 5.2 Update the main `habitat.md` command prompt to mention the cabinet sub-commands in its help/intro section

## 6. Validation

- [ ] 6.1 Manually test stash → verify file appears in `~/.habitat/cabinet/` and active slot is cleared
- [ ] 6.2 Manually test `/habitat` after stash → verify a new plant is spawned
- [ ] 6.3 Manually test cabinet list → verify stashed plant appears with correct summary
- [ ] 6.4 Manually test swap → verify active plant is stashed, chosen plant becomes active, and cabinet file is removed
- [ ] 6.5 Verify write-then-delete ordering: simulate an interrupted swap and confirm no plant is lost
