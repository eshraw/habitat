## ADDED Requirements

### Requirement: User can activate persistent plant display
The system SHALL provide a `/hbt:display` slash command that activates a compact plant display in the Claude Code status line for the current session.

#### Scenario: First activation
- **WHEN** the user runs `/hbt:display` and `display_active` is absent or false in `plant.json`
- **THEN** the command sets `display_active: true` in `~/.habitat/plant.json` and confirms activation with a single line

#### Scenario: Already active
- **WHEN** the user runs `/hbt:display` and `display_active` is already true
- **THEN** the command responds that the display is already active and shows the current compact format

#### Scenario: Plant not initialized
- **WHEN** the user runs `/hbt:display` and `~/.habitat/plant.json` does not exist
- **THEN** the command tells the user to run `/habitat-init` first and does not modify any state

### Requirement: Status line renders compact plant presence
The system SHALL render a compact one-line plant string in the Claude Code status line when `display_active` is true in `plant.json`.

#### Scenario: Active display renders correctly
- **WHEN** `display_active` is true and `plant.json` is valid
- **THEN** the statusline shows: species name, current stage number, health value, and hydration value in the format `[<species> ·<stage>] HP:<health> HY:<hydration>`

#### Scenario: Display suppressed when inactive
- **WHEN** `display_active` is false or absent in `plant.json`
- **THEN** the statusline renders nothing (empty string)

#### Scenario: Display suppressed when plant missing
- **WHEN** `~/.habitat/plant.json` does not exist
- **THEN** the statusline renders nothing (empty string)

### Requirement: Display flag persists in plant state
The `display_active` boolean field SHALL be stored in `~/.habitat/plant.json` as a top-level field alongside existing fields.

#### Scenario: Field added on first activation
- **WHEN** `/hbt:display` is run on a plant.json that lacks `display_active`
- **THEN** `display_active: true` is written to the file and all other fields are preserved exactly

#### Scenario: Existing state unaffected
- **WHEN** `display_active` is written
- **THEN** no other field in `plant.json` changes value
