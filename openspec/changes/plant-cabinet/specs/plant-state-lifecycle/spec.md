## MODIFIED Requirements

### Requirement: Plant state file initialization
The system SHALL create `~/.habitat/plant.json` on first run when no state file exists, with required default fields for species, stage, timestamps, stats, xp, sessions, and milestones. The system SHALL also create `~/.habitat/cabinet/` at the same time.

#### Scenario: First invocation without prior state
- **WHEN** `/habitat` runs and `~/.habitat/plant.json` is missing
- **THEN** the system creates a valid JSON state file with append-friendly defaults and `stage` set to seed state, and creates `~/.habitat/cabinet/` if it does not exist
