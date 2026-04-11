## ADDED Requirements

### Requirement: Reset command exists and is accessible
The system SHALL provide a `/hbt:reset` slash command that resets the current plant to a fresh state.

#### Scenario: Command is available
- **WHEN** a user types `/hbt:reset` in Claude Code
- **THEN** the command prompt is loaded and Claude begins the reset flow

### Requirement: Confirmation required before reset
The `/hbt:reset` command MUST ask the user for explicit confirmation before destroying the existing plant state, referencing the plant's name or species in the confirmation message.

#### Scenario: User confirms reset
- **WHEN** the user invokes `/hbt:reset` and confirms the prompt
- **THEN** Claude runs `habitat_init.sh` with a force flag (or equivalent) to overwrite the existing state with a fresh random-species plant

#### Scenario: User declines reset
- **WHEN** the user invokes `/hbt:reset` and responds negatively to the confirmation
- **THEN** Claude cancels the operation, the existing `~/.habitat/plant.json` is untouched, and Claude acknowledges the cancellation

### Requirement: Reset produces valid fresh state
After a confirmed reset, the new plant state SHALL be a valid default state as produced by `habitat_init.sh` — new random species, stage 0, default stats.

#### Scenario: State file after reset
- **WHEN** reset completes successfully
- **THEN** `~/.habitat/plant.json` contains a valid new plant with `stage: 0`, `xp: 0`, and `sessions: 0`

### Requirement: Reset renders the new plant immediately
After a successful reset, the command SHALL display the new plant (species, stage 0 form, and intro commentary) without requiring the user to separately invoke `/hbt:habitat`.

#### Scenario: Post-reset display
- **WHEN** reset completes
- **THEN** Claude renders the new plant's ASCII form and writes a short "welcome" flavour sentence
