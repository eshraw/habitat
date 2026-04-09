## ADDED Requirements

### Requirement: Species are loaded from data files
The system SHALL source species behavior and presentation metadata from files in `species/` rather than hardcoded species branches in hook scripts.

#### Scenario: Species definition lookup
- **WHEN** the system needs stat weighting, thresholds, or stage art for a species
- **THEN** it reads those values from the corresponding species JSON definition

### Requirement: Per-species stage threshold contract
Each species definition MUST include stage XP threshold data used to determine seed-through-ancient progression.

#### Scenario: Missing threshold field in species file
- **WHEN** a species file is missing required threshold data
- **THEN** validation fails with safe fallback behavior that avoids corrupted state transitions

### Requirement: Rare variant selection contract
Species definitions SHALL support stage 4 and stage 5 rare variant metadata keyed by dominant stat signals.

#### Scenario: High-stage render with dominant stat
- **WHEN** a plant reaches stage 4 or 5 and has a dominant stat signal
- **THEN** the render context can select an eligible rare variant defined for that species
