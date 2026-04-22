## MODIFIED Requirements

### Requirement: Species are loaded from data files
The system SHALL source species behavior and presentation metadata from files in `species/` rather than hardcoded species branches in hook scripts.

#### Scenario: Species definition lookup
- **WHEN** the system needs stat weighting, thresholds, xp_rate, or stage art for a species
- **THEN** it reads those values from the corresponding species JSON definition

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
