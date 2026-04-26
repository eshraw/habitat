## Why

The current plant ASCII art uses generic, interchangeable line characters (`|`, `/`, `\`, `*`) that make all species look nearly identical at a glance — a fern and a cactus share the same skeletal vocabulary. Richer, species-specific art makes the companion feel genuinely alive and lets users develop attachment to their specific plant.

## What Changes

- Replace `stage_art` values in all six species JSON files with multi-line ASCII illustrations that reference real botanical silhouettes (frond shapes for ferns, rib segments for cacti, split-leaf lobes for monstera, etc.)
- Art scales in visual complexity across the five stages (seed → sprout → juvenile → mature → ancient) using a consistent width budget of ~12 characters
- Each species uses a distinct character palette to reinforce its visual identity (e.g., `*` and `~` for moss, `Y` and `v` for fern fronds, `()` curves for cactus ribs)
- Rare variant flavour text in `rare_variants` is preserved; no schema changes needed

## Capabilities

### New Capabilities
<!-- none — this change improves content within existing structures -->

### Modified Capabilities
- `species-data-driven-definition`: `stage_art` strings within species JSON files are enriched to be botanically evocative rather than purely geometric; no schema contract changes, only richer values

## Impact

- **Files changed**: `habitat-claude/species/fern.json`, `cactus.json`, `moss.json`, `monstera.json`, `bonsai.json`, `strangler_fig.json` — `stage_art` field only
- **Rendering**: Claude reads `stage_art` verbatim and renders it in a code block; no render-path changes needed
- **No breaking changes**: same JSON schema, same field names, same five stage keys
