## MODIFIED Requirements

### Requirement: Species are loaded from data files
The system SHALL source species behavior and presentation metadata from files in `species/` rather than hardcoded species branches in hook scripts.

#### Scenario: Species definition lookup
- **WHEN** the system needs stat weighting, thresholds, xp_rate, or stage art for a species
- **THEN** it reads those values from the corresponding species JSON definition

### Requirement: Per-species stage threshold contract
Each species definition MUST include stage XP threshold data used to determine seed-through-ancient progression. Thresholds SHALL be set so that completing the full seed-to-ancient arc requires weeks of regular use rather than a few sessions.

#### Scenario: Missing threshold field in species file
- **WHEN** a species file is missing required threshold data
- **THEN** validation fails with safe fallback behavior that avoids corrupted state transitions

### Requirement: Per-species XP rate contract
Each species definition MUST include an `xp_rate` field that modulates how quickly that species accumulates XP. This field is part of the required species schema alongside `stage_thresholds` and `stat_weights`.

#### Scenario: Species file passes validation with xp_rate present
- **WHEN** a species JSON file includes a valid positive `xp_rate` value
- **THEN** the species is considered well-formed and the hook applies the multiplier during XP accumulation

#### Scenario: Species file missing xp_rate fails soft validation
- **WHEN** a species JSON file has no `xp_rate` field
- **THEN** the hook treats the species as valid but applies a default multiplier of 1.0, logging no error

### Requirement: Stage art is botanically evocative and species-distinct
Each species definition MUST include `stage_art` strings that are visually distinct from other species and reference real botanical silhouettes rather than generic geometric line art. Art SHALL use a species-specific character palette (2–3 unique characters per species) chosen to suggest the plant's real form. Art width SHALL NOT exceed 14 characters per line. Art height SHALL NOT exceed 6 lines at the ancient stage. All characters MUST be printable ASCII (codepoints 32–126). Art complexity SHALL visibly increase from stage to stage.

#### Scenario: Fern art uses frond-like characters
- **WHEN** the fern's `stage_art` is rendered at juvenile or above
- **THEN** the art uses characters such as `v`, `V`, `(`, `)`, or `~` that suggest pinnate fronds rather than generic slash/backslash lines

#### Scenario: Cactus art uses rib-like characters
- **WHEN** the cactus's `stage_art` is rendered at juvenile or above
- **THEN** the art uses characters such as `(`, `)`, or `:` that suggest vertical ribs and a columnar body

#### Scenario: Each species is visually distinguishable at mature stage
- **WHEN** two different species' `stage_art` values for the `mature` key are displayed side by side
- **THEN** a reader can identify which is which without reading the species name, based on character choice alone

#### Scenario: Art fits within width budget
- **WHEN** any `stage_art` string for any species is split by newline
- **THEN** no individual line exceeds 14 characters in length

#### Scenario: Art complexity increases with stage
- **WHEN** `stage_art` values for a species are ordered seed → sprout → juvenile → mature → ancient
- **THEN** each subsequent stage has more lines or wider spread than the previous stage

### Requirement: Rare variant selection contract
Species definitions SHALL support stage 4 and stage 5 rare variant metadata keyed by dominant stat signals.

#### Scenario: High-stage render with dominant stat
- **WHEN** a plant reaches stage 4 or 5 and has a dominant stat signal
- **THEN** the render context can select an eligible rare variant defined for that species
