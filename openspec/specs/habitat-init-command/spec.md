## ADDED Requirements

### Requirement: Explicit initialization command
The system SHALL provide a `/hbt:init` command that initializes Habitat local state and required directories for first-time users.

#### Scenario: First initialization
- **WHEN** a user runs `/hbt:init` and no Habitat state exists
- **THEN** the command creates required local directories and a valid default `~/.habitat/plant.json`

### Requirement: Idempotent re-initialization behavior
The `/hbt:init` command MUST be safe to run multiple times and MUST NOT destroy existing plant progression unless explicitly requested by the user.

#### Scenario: Init run with existing valid state
- **WHEN** a user runs `/hbt:init` and valid state already exists
- **THEN** the command confirms readiness and leaves existing state values intact

### Requirement: Runtime prerequisite validation
The `/hbt:init` command SHALL validate required runtime tools (including `jq`) and provide actionable remediation when requirements are missing.

#### Scenario: Missing jq during init
- **WHEN** `/hbt:init` runs on a machine without `jq`
- **THEN** the command returns clear instructions for installing `jq` and does not leave partial initialization artifacts
