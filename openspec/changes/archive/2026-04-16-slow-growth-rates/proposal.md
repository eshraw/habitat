## Why

Plants currently advance through stages within 1–2 coding sessions — a fern can reach stage 1 after ~120 XP, which a moderate session of edits and bash calls provides easily. This undercuts the sense of long-term nurturing that makes a companion plant feel meaningful. Growth should feel earned, not automatic, while remaining visible enough to stay engaging.

## What Changes

- **Reduce base XP gains** in `on_tool.sh`: bash events drop from 2→1 XP (new command bonus 3→2), write/edit events drop from 5→3 XP, web search drops from 3→2 XP.
- **Add `xp_rate` multiplier to species definitions**: Each species JSON gets an `xp_rate` field (e.g., moss=1.2, fern=1.0, monstera=0.9, strangler_fig=0.85, cactus=0.7, bonsai=0.5). The hook reads this and scales XP accordingly, so some species inherently grow faster or slower.
- **Raise stage thresholds**: All species thresholds scale up ~1.8–2.0× to match the reduced XP rate while preserving relative species ordering (moss fastest, bonsai slowest).
- The `lib.sh` shared library may need a helper to read `xp_rate` from the species file alongside the existing `species_thresholds_or_default`.

## Capabilities

### New Capabilities

- `species-xp-rate`: Per-species XP multiplier field that adjusts how fast a given plant species accumulates XP from tool events.

### Modified Capabilities

- `event-hook-mutations`: Base XP values per tool event type are changing. The hook also gains species-aware XP scaling logic.
- `species-data-driven-definition`: Species JSON contract expands with a required `xp_rate` field.

## Impact

- `habitat-claude/hooks/on_tool.sh`: XP increment values reduced; reads species `xp_rate` before writing XP.
- `habitat-claude/hooks/lib.sh`: New helper `species_xp_rate_or_default` (or inline read) to extract `xp_rate` from the species file.
- `habitat-claude/species/*.json`: All six species files get `xp_rate` field and updated `stage_thresholds`.
- Existing plants keep their current XP but will progress more slowly going forward — no migration needed, no state restructuring.
