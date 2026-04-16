## 1. lib.sh — species XP rate helper

- [x] 1.1 Add `species_xp_rate_or_default` function to `habitat-claude/hooks/lib.sh` that reads `.xp_rate` from the species JSON file, clamps to [0.1, 2.0], and returns 1.0 if the field is absent or invalid

## 2. on_tool.sh — reduce base XP and apply species multiplier

- [x] 2.1 Reduce base XP values in `on_tool.sh`: bash_tool 2→1, new-command bonus 3→2, write/edit 5→3, web_search 3→2
- [x] 2.2 After computing the XP delta, read `xp_rate` via the lib.sh helper and apply `floor(delta * xp_rate)` before writing to state

## 3. Species JSON — add xp_rate field

- [x] 3.1 Add `"xp_rate": 1.2` to `species/moss.json`
- [x] 3.2 Add `"xp_rate": 1.0` to `species/fern.json`
- [x] 3.3 Add `"xp_rate": 0.9` to `species/monstera.json`
- [x] 3.4 Add `"xp_rate": 0.85` to `species/strangler_fig.json`
- [x] 3.5 Add `"xp_rate": 0.7` to `species/cactus.json`
- [x] 3.6 Add `"xp_rate": 0.5` to `species/bonsai.json`

## 4. Species JSON — raise stage thresholds

- [x] 4.1 Update `stage_thresholds` in `moss.json` to `[0, 200, 500, 1050, 1900]`
- [x] 4.2 Update `stage_thresholds` in `fern.json` to `[0, 220, 560, 1180, 2200]`
- [x] 4.3 Update `stage_thresholds` in `monstera.json` to `[0, 240, 610, 1280, 2380]`
- [x] 4.4 Update `stage_thresholds` in `strangler_fig.json` to `[0, 250, 640, 1350, 2500]`
- [x] 4.5 Update `stage_thresholds` in `cactus.json` to `[0, 260, 670, 1420, 2650]`
- [x] 4.6 Update `stage_thresholds` in `bonsai.json` to `[0, 280, 720, 1520, 2800]`

## 5. Validation

- [x] 5.1 Manually run `on_tool.sh` with a test payload for each tool type and verify XP delta matches expected reduced values
- [x] 5.2 Verify the xp_rate multiplier is applied correctly for at least two species (e.g., moss at 1.2 and bonsai at 0.5)
- [x] 5.3 Confirm a missing or zero `xp_rate` in a species file falls back to 1.0 without error
- [x] 5.4 Check all six species JSON files are valid JSON after edits (`jq . species/*.json`)
