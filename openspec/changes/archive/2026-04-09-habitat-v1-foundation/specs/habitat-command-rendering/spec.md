## ADDED Requirements

### Requirement: Command-driven spawn and load flow
The `/habitat` command SHALL read existing plant state and spawn a new plant with random species and initial stage when state is absent.

#### Scenario: Existing plant state
- **WHEN** `/habitat` is invoked and a valid state file exists
- **THEN** the command reads and uses the persisted species, stage, and stats values

#### Scenario: No existing plant state
- **WHEN** `/habitat` is invoked and no state file exists
- **THEN** the command initializes state with a random species and stage 0 before rendering output

### Requirement: Claude-rendered visual and commentary output
The command MUST delegate stage visual selection and personality commentary generation to Claude using species and state context.

#### Scenario: Render with dominant-stat mood
- **WHEN** the command has species art data and current stats
- **THEN** Claude renders the stage-appropriate form and writes 1-2 commentary sentences aligned with dominant stat and mood

### Requirement: Minimal stats presentation
The command SHALL display stats in a compact textual or bar-style representation suitable for chat output.

#### Scenario: Display state summary
- **WHEN** rendering completes
- **THEN** the output includes a minimal stats representation for key plant metrics
