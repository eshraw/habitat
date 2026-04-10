# Habitat

A Claude Code companion system. Users spawn a living plant inside their Claude Code session via `/habitat`. The plant evolves visually and stat-wise over time through hooks that react to what the user does in their coding sessions.

## What this project is

Habitat is not a plugin in the npm sense. It is a collection of files that installs into a user's Claude Code environment:

- A slash command (`/habitat`) that spawns and renders the plant
- Hook scripts that fire on Claude Code lifecycle events and mutate plant state
- A state file (`~/.habitat/plant.json`) that persists the plant across sessions and projects
- A set of plant species definitions (ASCII appearance at each growth stage, stat thresholds, flavour text)

The plant is rendered by Claude itself inside the chat, reading the state file and choosing the right ASCII form. Claude also generates personality commentary that reflects the plant's current mood and stats.

## Core concepts

### Plant state

Each plant has a JSON state file with the following shape:

```json
{
  "species": "fern",
  "stage": 2,
  "name": null,
  "born": "2025-04-09T10:00:00Z",
  "last_seen": "2025-04-09T14:32:00Z",
  "stats": {
    "health": 80,
    "growth": 45,
    "hydration": 60,
    "curiosity": 70,
    "rootedness": 55
  },
  "xp": 340,
  "sessions": 12,
  "milestones": ["first_edit", "night_owl"]
}
```

Stats decay slowly over real time. A plant that is not visited wilts. A plant that is visited often and treated well thrives.

### Species

Each species has a different visual identity, a different stat weighting, and different evolution triggers. Species are assigned randomly at spawn. The full list lives in `habitat-claude/species/`. Do not hardcode species logic in hook scripts — always read from the species definition file.

### Stages

Every species has 5 stages: seed → sprout → juvenile → mature → ancient. Stage is determined by XP thresholds defined per species, not by a global rule. Visual representation (ASCII art) changes at each stage. At stage 4 and 5, the plant gets rare visual variants that depend on its dominant stat.

### Hooks

Hook scripts live in `hooks/`. They receive a JSON payload on stdin from Claude Code and write mutations back to the state file. Each hook is a small, focused script — one concern per file. Hook scripts must be fast (under 200ms), must not call external APIs, and must never block Claude Code.

Event mapping (what each hook does to stats):

- `PostToolUse / bash_tool` → +hydration, +curiosity if new command pattern
- `PostToolUse / str_replace or create_file` → +growth, +rootedness
- `PostToolUse / web_search` → +curiosity
- `Stop` → decay tick, session count increment, milestone check
- `Notification` → +health if task completed successfully

### The `/habitat` command

The slash command at `.claude/commands/habitat.md` does the following when invoked:

1. Reads `~/.habitat/plant.json`
2. If no plant exists, spawns a new one (random species, stage 0)
3. Asks Claude to render the plant at its current stage using the species ASCII definition
4. Asks Claude to write 1–2 sentences of flavour commentary that reflect the plant's dominant stat and current mood
5. Displays stats as a minimal bar or text representation

The command file is a prompt template — Claude does the rendering, not a script.

## File structure

```
habitat/
├── CLAUDE.md                  ← this file
├── README.md
├── install.sh                 ← manual fallback: copies plugin files into ~/.claude/
├── openspec/                  ← dev-only specs and change history
├── scripts/                   ← dev-only validation scripts
├── .claude/                   ← dev-only IDE commands (opsx, etc.)
├── .claude-plugin/
│   └── marketplate.json       ← marketplace index (declares plugins in this repo)
└── habitat-claude/            ← marketplace distributable (only this is installed)
    ├── .claude-plugin/
    │   └── plugin.json        ← plugin manifest
    ├── commands/
    │   ├── habitat.md         ← the slash command prompt
    │   └── habitat-init.md    ← init command prompt
    ├── hooks/
    │   ├── lib.sh             ← shared shell library
    │   ├── on_tool.sh         ← PostToolUse handler
    │   └── on_stop.sh         ← Stop handler
    ├── scripts/
    │   └── habitat_init.sh    ← state bootstrap script
    └── species/
        ├── fern.json
        ├── cactus.json
        ├── moss.json
        ├── monstera.json
        ├── bonsai.json
        └── strangler_fig.json
```

## Design principles

**Claude does the rendering.** Do not generate ASCII art in shell scripts. The slash command passes the species definition and current stats to Claude and lets Claude pick the right form and write the commentary. This means the output is always slightly different and alive.

**Hooks are dumb, Claude is smart.** Hook scripts only do arithmetic on JSON — they increment stats, apply decay, check thresholds, write to disk. All narrative intelligence lives in the slash command prompt.

**State is append-friendly.** When adding new stats or milestone types, always add fields with defaults rather than restructuring the JSON. Old state files must always load cleanly.

**Species are data, not code.** Adding a new species means adding a JSON file in `habitat-claude/species/`. No code changes required. Species files define: name, stat weights, stage XP thresholds, ASCII art per stage, rare variants, and flavour adjectives Claude can use in commentary.

**Decay is gentle.** A plant should never die from a single missed day. Decay rates should feel like real plants — a fern notices after 3 days, a cactus after 3 weeks.

## What to avoid

- Do not add a web dashboard or remote sync in v1. Local-only is a feature.
- Do not make hook scripts interactive or print to stdout in a way that interrupts Claude Code's output.
- Do not add a dependency on Node or Python if the hooks can be plain shell + `jq`. Keep the install surface minimal.
- Do not let the plant die permanently. At minimum health, it enters a "dormant" state that recovers with care.