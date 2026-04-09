## ADDED Requirements

### Requirement: Plugin-installable Habitat package
The project SHALL provide Claude plugin metadata and packaging artifacts required for installation through `claude plugin add habitat`.

#### Scenario: Fresh plugin installation
- **WHEN** a user runs `claude plugin add habitat`
- **THEN** Habitat plugin assets are installed and discoverable by the Claude runtime without manual file copy steps

### Requirement: Declared compatibility and dependencies
The plugin packaging MUST declare supported Claude CLI compatibility and runtime prerequisites needed by Habitat commands/hooks.

#### Scenario: Install on unsupported CLI version
- **WHEN** the user attempts installation with an unsupported Claude CLI version
- **THEN** the plugin installation or startup path reports a clear compatibility error with upgrade guidance

### Requirement: Post-install guidance for initialization
The plugin setup SHALL guide users to run `/habitat-init` as the required first-run initialization step.

#### Scenario: Plugin installed successfully
- **WHEN** installation completes
- **THEN** user-facing guidance indicates `/habitat-init` is the next step before normal `/habitat` usage
