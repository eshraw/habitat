## MODIFIED Requirements

### Requirement: Command-driven spawn and load flow
The `/hbt:habitat` command SHALL read existing plant state and spawn a new plant with random species and initial stage when state is absent. All sub-commands (`hbt:water`, `hbt:info`, `hbt:clue`, `hbt:display`, `hbt:reset`, `hbt:init`, `hbt:clean`) SHALL be invoked using the `hbt:` prefix.

#### Scenario: Existing plant state
- **WHEN** `/hbt:habitat` is invoked and a valid state file exists
- **THEN** the command reads and uses the persisted species, stage, and stats values

#### Scenario: No existing plant state
- **WHEN** `/hbt:habitat` is invoked and no state file exists
- **THEN** the command initializes state with a random species and stage 0 before rendering output

#### Scenario: Sub-command invocation with hbt prefix
- **WHEN** a user invokes any habitat sub-command (e.g., `/hbt:water`)
- **THEN** the command executes as expected, identical to prior `habitat:` behavior
