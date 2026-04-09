## ADDED Requirements

### Requirement: Plant state file initialization
The system SHALL create `~/.habitat/plant.json` on first run when no state file exists, with required default fields for species, stage, timestamps, stats, xp, sessions, and milestones.

#### Scenario: First invocation without prior state
- **WHEN** `/habitat` runs and `~/.habitat/plant.json` is missing
- **THEN** the system creates a valid JSON state file with append-friendly defaults and `stage` set to seed state

### Requirement: Stage progression uses species thresholds
The system SHALL compute stage transitions from XP thresholds defined in the active species definition rather than global hardcoded values.

#### Scenario: XP crosses species stage threshold
- **WHEN** xp increases past a threshold declared in the selected species file
- **THEN** the stored stage updates to the corresponding stage index for that species

### Requirement: Dormant recovery at minimum health
The system MUST prevent permanent death and transition plants at minimum health into a dormant, recoverable condition.

#### Scenario: Health reaches floor
- **WHEN** decay or events reduce health to its minimum allowed value
- **THEN** the state reflects dormant behavior and allows later positive events to recover health
