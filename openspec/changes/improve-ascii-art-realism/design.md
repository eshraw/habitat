## Context

All six species JSON files contain a `stage_art` field with five string values (seed, sprout, juvenile, mature, ancient). These strings are rendered verbatim by Claude inside a code block when the `/habitat` command runs. The current art uses a minimal, shared vocabulary of `|`, `/`, `\`, `*`, and `.` that makes species visually indistinguishable at a glance.

This change is a pure content replacement — no schema changes, no render-path changes, no hook changes.

## Goals / Non-Goals

**Goals:**
- Each species has a visually distinct character palette drawn from real botanical shapes
- Art complexity visibly increases from stage to stage, giving users a sense of growth
- Art renders correctly in monospace terminal output (ASCII-only, no Unicode box drawing)
- Width stays within ~14 characters so it renders cleanly in the Claude Code status line and chat

**Non-Goals:**
- Adding color or ANSI escape codes
- Changing the JSON schema or adding new fields
- Modifying how Claude renders or selects art (the render path is already correct)
- Creating animation or multi-frame art

## Decisions

### Character palette per species

Each species gets a distinct vocabulary of characters chosen to suggest its real botanical silhouette:

| Species | Key chars | Botanical reference |
|---|---|---|
| Fern | `v`, `V`, `(`, `)`, `~` | Pinnate fronds, arching stems |
| Cactus | `(`, `)`, `\|`, `:` | Vertical ribs, columnar body |
| Moss | `,`, `.`, `~`, `^`, `"` | Low spreading mat, cushion texture |
| Monstera | `@`, `Q`, `O`, `d`, `b` | Fenestrated, split leaf lobes |
| Bonsai | `&`, `Y`, `T`, `^`, `_` | Windswept crown, gnarled trunk |
| Strangler Fig | `{`, `}`, `(`, `)`, `\|` | Braided aerial roots, lattice wrap |

**Rationale**: Shared characters (like `|` for trunk) are still used where structurally necessary, but each species has 2–3 unique chars that make them identifiable without reading the name.

### Width budget

Max 14 characters wide, 6 lines tall at ancient stage. Seed is always `.` (a single dot — universally readable as "dormant potential"). Sprout is 2–3 lines. Each subsequent stage adds 1–2 lines and/or horizontal spread.

**Rationale**: The status line display wraps at ~16 chars. Keeping art within this budget means the same strings work in both status line and chat without truncation.

### ASCII-only

No Unicode, no emoji, no ANSI codes. All characters MUST be in the printable ASCII range (32–126).

**Rationale**: Terminal compatibility. Species art is stored in JSON and must survive `jq` round-trips, SSH sessions, and varied terminal emulators without mangling.

## Risks / Trade-offs

- [Risk] Art that looks good in a wide font may look cramped in a narrow terminal → Mitigation: keep art width under 14 chars and test renders in a standard 80-col terminal before committing
- [Risk] Claude may reflow art if it wraps the string in prose → Mitigation: art is always rendered inside a fenced code block per the existing `/habitat` command prompt; no change needed
- [Risk] Subjective — what looks "botanical" to one person looks noisy to another → Mitigation: prefer silhouette legibility over detail density; when in doubt, use fewer characters

## Open Questions

- None. All decisions can be made locally from the species JSON files.
