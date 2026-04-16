## Why

Plant people are collectors — a single plant is nice, but a cabinet full is an identity. The current system only supports one active plant at a time, which means starting fresh destroys progress and reduces the emotional investment users build with their companions. Giving users a way to stash and swap plants makes Habitat feel like a real collection, not a single slot.

## What Changes

- Users can stash their current plant into a cabinet (freezing its state — no decay, no growth)
- Users can view their cabinet to see all stashed plants with a brief summary
- Users can swap the active plant for one in the cabinet (the current active plant gets stashed automatically)
- Users can start a brand new plant without losing their existing one
- The cabinet is a local store (`~/.habitat/cabinet/`) with one JSON file per stashed plant
- Stashed plants do not receive hook events and do not decay
- The `/habitat` command continues to operate only on the active plant

## Capabilities

### New Capabilities

- `plant-cabinet`: Store, view, and swap multiple plants in a local cabinet. Includes stash, list, and swap operations.

### Modified Capabilities

- `plant-state-lifecycle`: Active plant state gains awareness of the cabinet — swap-in restores a stashed plant as the new active plant, swap-out freezes the current plant into the cabinet.

## Impact

- New directory: `~/.habitat/cabinet/` — one JSON file per stashed plant, named by species + born timestamp slug
- New commands: `/habitat stash`, `/habitat cabinet`, `/habitat swap`
- `habitat_init.sh` may need to create the cabinet directory alongside `~/.habitat/`
- Hook scripts (`on_tool.sh`, `on_stop.sh`) are unchanged — they operate only on the active plant
- No breaking changes to `~/.habitat/plant.json` format
