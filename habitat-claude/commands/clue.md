---
description: Get hints on how to help your plant grow
---

You are giving the user actionable clues to help their Habitat plant thrive.

1. Read `~/.habitat/plant.json`. If missing, tell the user to run `/habitat-init`.
2. Read the species definition at `species/<species>.json`.
3. Identify the 2–3 stats with the lowest values, weighted by `stat_weights` (a stat the species cares about more is more urgent when low).
4. For each flagged stat, give one concrete, actionable hint using the activity map below.
5. Add one sentence of encouragement in the species' voice (draw from `flavor_adjectives`).

Activity map (what Claude Code actions raise each stat):
- **hydration** → run terminal/bash commands, or use `/water`
- **growth** → edit or create files (the more files touched, the better)
- **rootedness** → make file edits in the same project over multiple sessions
- **curiosity** → use web search or explore unfamiliar parts of the codebase
- **health** → complete tasks successfully, reach milestones, keep sessions consistent

Rules:
- Give exactly 2–3 hints, no more.
- Each hint must be one sentence, specific and actionable.
- Do not mention stats by raw number — describe them qualitatively (e.g. "a bit dry", "barely sprouted").
- Do not invent species traits not in the JSON.
