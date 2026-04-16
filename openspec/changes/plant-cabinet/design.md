## Context

Habitat currently supports exactly one active plant, stored at `~/.habitat/plant.json`. Hook scripts mutate this file on every Claude Code event. There is no concept of multiple plants or a way to preserve a plant while starting a new one.

Users who want a fresh start must `/habitat reset`, which destroys their existing plant. The cabinet feature introduces a secondary store — `~/.habitat/cabinet/` — where plants can be frozen and later restored.

## Goals / Non-Goals

**Goals:**
- Allow the active plant to be stashed into the cabinet (state frozen, no decay)
- Allow viewing all stashed plants at a glance
- Allow swapping a stashed plant back in as the active plant
- Allow starting a brand-new plant without destroying the current one
- Keep all storage local; no network calls

**Non-Goals:**
- Cabinet plants do not evolve, decay, or receive hook events while stashed
- No cloud sync, sharing, or backup in v1
- No limit enforcement on cabinet size in v1 (trust the user)
- No rename/tagging of cabinet plants in v1

## Decisions

### Cabinet storage: directory of JSON files, not a single array

**Decision**: Each stashed plant is a standalone JSON file in `~/.habitat/cabinet/`, named `<species>-<born-slug>.json` (e.g., `fern-20250409T100000Z.json`).

**Why over a single `cabinet.json` array**: Parallel writes would require locking. Individual files are atomic, easier to inspect and debug, and match the existing single-file pattern for the active plant.

### Stash copies current state snapshot; active slot is cleared on swap-in

**Decision**: Stashing writes a copy of `plant.json` to the cabinet. Swapping in copies the chosen cabinet file to `plant.json` and removes it from the cabinet. The previously active plant is automatically stashed before the swap completes.

**Why**: This keeps `plant.json` as the single source of truth for the active plant. Hook scripts require no changes — they only ever touch `plant.json`.

### New commands as slash command arguments, not new top-level commands

**Decision**: Implement via `/habitat stash`, `/habitat cabinet`, `/habitat swap <slug>` rather than separate `/habitat-stash`, `/habitat-cabinet` commands.

**Why**: Reduces command namespace clutter. Users already know `/habitat`. Arguments are documented in the existing habitat command prompt.

### Cabinet directory created by `habitat_init.sh`

**Decision**: `habitat_init.sh` creates `~/.habitat/cabinet/` alongside `~/.habitat/` during init.

**Why**: Centralises bootstrap logic. Avoids scattered `mkdir -p` calls in each command handler. Existing users who already ran init need a one-time migration — the command handlers should create the directory if missing rather than failing (defensive mkdir).

## Risks / Trade-offs

- **Slug collisions if two plants of same species born at the same second** → Mitigation: append a random 4-char hex suffix to the filename if a collision is detected.
- **Cabinet grows unbounded** → Acceptable in v1; document that users can delete files manually. Add a count warning in `/habitat cabinet` if > 20 plants are stashed.
- **Swap leaves active plant in inconsistent state if write fails mid-operation** → Mitigation: write the new active file before removing the cabinet entry (write-then-delete ordering).
- **Users on old installs without `~/.habitat/cabinet/`** → Mitigation: each command handler does `mkdir -p ~/.habitat/cabinet` before operating, so it self-heals without requiring a re-init.
