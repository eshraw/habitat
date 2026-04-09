## Why

Habitat needs a clear v1 contract so implementation stays lightweight, local-first, and consistent with Claude Code hook constraints. Defining first-iteration capabilities now lets us ship a usable experience quickly without overbuilding.

## What Changes

- Define v1 behavior for spawning, persisting, and evolving a plant in local state.
- Define event-driven hook mutations and decay rules with strict runtime and dependency constraints.
- Define `/habitat` command responsibilities for rendering, commentary, and stat presentation.
- Define species data requirements so new species remain data-only additions.
- Define install flow for placing hooks and slash-command assets into the user's Claude environment.

## Capabilities

### New Capabilities
- `plant-state-lifecycle`: Create and maintain `~/.habitat/plant.json` with append-friendly defaults, XP/stage progression, and dormant recovery behavior.
- `event-hook-mutations`: Process Claude lifecycle events to mutate stats and sessions via small, non-blocking shell hooks.
- `habitat-command-rendering`: Execute `/habitat` prompt flow to spawn missing plants, render stage visuals, and generate mood-aware commentary from state.
- `species-data-driven-definition`: Load species behavior and stage thresholds from `species/*.json` without hardcoded species logic in hooks.
- `local-install-bootstrap`: Install and update command/hook files into user Claude directories with minimal runtime dependencies.

### Modified Capabilities
- None.

## Impact

- Affected code: `hooks/`, `.claude/commands/habitat.md`, `install.sh`, `species/*.json`, and project documentation.
- Affected runtime behavior: local state initialization, event handling, stage progression, and command output composition.
- Dependencies: shell + `jq` only for hook/state operations; no web services or remote sync.
