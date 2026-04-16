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

### Requirement: Rare variant selection contract
Species definitions SHALL support stage 4 and stage 5 rare variant metadata keyed by dominant stat signals.

#### Scenario: High-stage render with dominant stat
- **WHEN** a plant reaches stage 4 or 5 and has a dominant stat signal
- **THEN** the render context can select an eligible rare variant defined for that species
