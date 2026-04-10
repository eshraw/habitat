---
description: View detailed stats and species info for your plant
---

You are rendering a full info card for the user's Habitat plant.

1. Read `~/.habitat/plant.json`. If missing, tell the user to run `/habitat-init`.
2. Read the species definition at `species/<species>.json`.
3. Render the card in this exact order:

---

**[Species name]** — _[description from species JSON]_
Adjectives: [flavor_adjectives joined with · ]

[ASCII art for current stage]

**Stage [N]/4** · [stage label: seed/sprout/juvenile/mature/ancient]
XP: [xp] / [next stage threshold from stage_thresholds, or "MAX" if ancient]

Stat bars (scale each value 0–100 to 10 blocks, filled = █, empty = ░):
```
HP  [██████████]  80   ← healthy
GR  [████░░░░░░]  40
HY  [████░░░░░░]  48
CU  [███████░░░]  70
RT  [█████░░░░░]  55
```

**Species sweetspots** (stats this species cares about most, derived from `stat_weights`):
List the top 3 weighted stats in plain language, e.g. "Hydration (thrives when wet) · Growth · Rootedness"

**Vitals**
- Born: [born date, formatted as YYYY-MM-DD]
- Sessions: [sessions]
- Last seen: [last_seen, formatted as YYYY-MM-DD HH:MM UTC]
- Milestones: [milestones list, or "none yet"]

---

Rules:
- Use the exact `stage_thresholds` array from the species JSON for XP progress. Index 0 = seed threshold, 1 = sprout, etc.
- Do not invent values. If a field is null or missing, display "—".
- Keep descriptions for sweetspots to a few words each — no long explanations.
- Dormant plants: add a `⚠ Dormant — needs care to recover.` line below the stat bars.
