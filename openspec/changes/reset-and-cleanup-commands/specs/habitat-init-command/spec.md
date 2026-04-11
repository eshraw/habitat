## RENAMED Requirements

### Requirement: Explicit initialization command
FROM: `/habitat-init` command
TO: `/hbt:init` command

### Requirement: Idempotent re-initialization behavior
FROM: The `/habitat-init` command MUST be safe to run multiple times
TO: The `/hbt:init` command MUST be safe to run multiple times and MUST NOT destroy existing plant progression unless explicitly requested by the user.

#### Scenario: Init run with existing valid state
- **WHEN** a user runs `/hbt:init` and valid state already exists
- **THEN** the command confirms readiness and leaves existing state values intact

### Requirement: Runtime prerequisite validation
FROM: The `/habitat-init` command SHALL validate required runtime tools
TO: The `/hbt:init` command SHALL validate required runtime tools (including `jq`) and provide actionable remediation when requirements are missing.

#### Scenario: Missing jq during init
- **WHEN** `/hbt:init` runs on a machine without `jq`
- **THEN** the command returns clear instructions for installing `jq` and does not leave partial initialization artifacts
