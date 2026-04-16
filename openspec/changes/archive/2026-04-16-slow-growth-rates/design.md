## Context

Plant growth is driven by XP accumulated through tool events (bash, write/edit, web search). XP gains are currently hardcoded in `on_tool.sh`, and stage thresholds are defined per species in species JSON files. The current numbers produce stages within 1–2 sessions for most species, which is too fast for a meaningful companion arc.

Stage thresholds already vary by species (moss: 1020 XP to ancient; bonsai: 1500 XP), but the gap is not wide enough to feel meaningfully different, and XP per event is the same regardless of species.

## Goals / Non-Goals

**Goals:**
- Reduce base XP gains by roughly 40–50% so sessions accumulate XP more slowly
- Introduce a per-species `xp_rate` multiplier (0.5–1.2) so fast growers (moss) and slow growers (bonsai) feel genuinely different
- Raise stage thresholds proportionally so the full seed-to-ancient journey spans weeks of regular use rather than a few hours
- Keep the hook scripts lean and dependency-free (shell + jq only)

**Non-Goals:**
- Retroactively adjusting existing plant XP (plants keep current XP, just progress more slowly)
- Changing what events fire or what stats they affect (only the XP amounts change)
- Adding time-based XP decay or capping per-session XP

## Decisions

### D1: XP multiplier lives in species JSON, applied in on_tool.sh

**Decision**: Add `xp_rate` (float) to each species file. `on_tool.sh` reads it via a helper in `lib.sh` and multiplies the computed XP delta before writing.

**Alternatives considered**:
- Separate per-species threshold scaling (adjust thresholds only, leave XP flat): simpler but loses the real-time differentiation — two plants of different species accumulating the same XP per event feels wrong.
- Global slow-down knob in settings file: adds a new config surface with unclear ownership. Species JSON already owns this domain.

**Rationale**: Species files are the canonical source of species-specific behavior. `xp_rate` belongs there alongside stat_weights and stage_thresholds.

### D2: Reduced base XP values (not threshold inflation only)

**Decision**: Lower the per-event XP values in `on_tool.sh` rather than only raising thresholds.

| Event | Old XP | New XP |
|---|---|---|
| bash_tool | 2 | 1 |
| bash_tool (new command) | +3 bonus | +2 bonus |
| write/edit/str_replace | 5 | 3 |
| web_search | 3 | 2 |

**Rationale**: Reducing the source values is transparent and composable. Raising thresholds alone would require re-tuning every species file; reducing gains is a single-file change that naturally propagates through all species before the multiplier is applied.

### D3: lib.sh helper `species_xp_rate_or_default`

**Decision**: Add a small function in `lib.sh` that reads `.xp_rate` from a species file, defaulting to `1.0` if absent. `on_tool.sh` calls it once, stores result, and multiplies XP delta.

**Rationale**: Keeps `on_tool.sh` readable and mirrors the pattern of `species_thresholds_or_default`. The default of 1.0 means old or incomplete species files continue to work.

### D4: New threshold targets per species

Target: seed-to-ancient requires roughly 8–12 weeks of daily moderate use (~50 XP per session after multiplier).

| Species | xp_rate | Sprout | Juvenile | Mature | Ancient |
|---|---|---|---|---|---|
| moss | 1.2 | 200 | 500 | 1050 | 1900 |
| fern | 1.0 | 220 | 560 | 1180 | 2200 |
| monstera | 0.9 | 240 | 610 | 1280 | 2380 |
| strangler_fig | 0.85 | 250 | 640 | 1350 | 2500 |
| cactus | 0.7 | 260 | 670 | 1420 | 2650 |
| bonsai | 0.5 | 280 | 720 | 1520 | 2800 |

## Risks / Trade-offs

- **Existing plants feel stalled** → Mitigation: plants keep their accumulated XP. A plant already at 800 XP is already juvenile/mature; only future progression is slower. No jarring regression.
- **xp_rate math rounding** → Mitigation: use `jq`'s `round` or integer truncation via `| floor` to avoid fractional XP accumulation that could cause threshold edge-case bugs.
- **lib.sh helper adds latency** → Mitigation: it's a single `jq` read from a small JSON file, well within the 200ms hook budget.

## Migration Plan

No state migration needed. Changes deploy by updating the six species JSON files and the two hook files. Existing `~/.habitat/plant.json` files continue loading without modification.

## Open Questions

- Should `xp_rate` be clamped on read (e.g., min 0.1, max 2.0) to guard against malformed species files? Recommendation: yes, add a clamp in the helper for robustness.
