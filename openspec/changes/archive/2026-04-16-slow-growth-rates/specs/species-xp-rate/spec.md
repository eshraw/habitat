## ADDED Requirements

### Requirement: Per-species XP rate multiplier
Each species definition SHALL include an `xp_rate` field (positive float) that scales how much XP that species accumulates per tool event. A value of 1.0 is neutral; values below 1.0 slow growth; values above 1.0 accelerate it.

#### Scenario: Species with xp_rate below 1.0 gains less XP per event
- **WHEN** a tool event fires and the active plant's species has `xp_rate` of 0.7
- **THEN** the XP delta applied to the plant equals floor(base_xp * 0.7), producing slower progression than a neutral species

#### Scenario: Species with xp_rate above 1.0 gains more XP per event
- **WHEN** a tool event fires and the active plant's species has `xp_rate` of 1.2
- **THEN** the XP delta applied equals floor(base_xp * 1.2), producing faster progression than a neutral species

### Requirement: xp_rate defaults to 1.0 when absent or invalid
The system MUST apply a default `xp_rate` of 1.0 if the field is missing, null, zero, or outside the clamped range [0.1, 2.0] in the species file, so that malformed or legacy species definitions continue to work without corrupting XP state.

#### Scenario: Species file missing xp_rate field
- **WHEN** a species JSON file has no `xp_rate` key
- **THEN** the hook uses 1.0 as the multiplier and XP accumulates at the base rate

#### Scenario: Species file has xp_rate of 0 or negative
- **WHEN** a species file sets `xp_rate` to 0 or a negative number
- **THEN** the hook clamps to 0.1 (minimum) to prevent XP from stalling completely
