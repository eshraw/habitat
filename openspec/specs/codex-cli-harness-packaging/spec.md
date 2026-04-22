## ADDED Requirements

### Requirement: Codex harness-installable Habitat package
The system SHALL provide Codex CLI harness packaging metadata and assets required to install and run Habitat without requiring Claude plugin installation.

#### Scenario: Fresh Codex harness installation
- **WHEN** a user installs Habitat for Codex CLI harness in a supported environment
- **THEN** required Habitat command and hook assets are installed into harness-recognized locations
- **AND** the runtime can invoke Habitat commands without manual file copying

### Requirement: Plugin-first installation parity across runtimes
The system MUST support lightweight plugin-based installation semantics for both Claude and Codex runtime surfaces, using each platform's `/plugin` workflow as the primary onboarding path.

#### Scenario: User installs from Claude plugin flow
- **WHEN** a user installs Habitat through Claude's plugin flow
- **THEN** Habitat becomes available without manual file copy or custom bootstrap commands beyond documented first-run initialization

#### Scenario: User installs from Codex plugin flow
- **WHEN** a user installs Habitat through Codex's plugin flow
- **THEN** Habitat becomes available without manual file copy or custom bootstrap commands beyond documented first-run initialization

### Requirement: Harness onboarding guidance and verification
The Codex harness installation flow MUST provide explicit first-run guidance and a verification outcome indicating whether Habitat is ready.

#### Scenario: Successful harness install completion
- **WHEN** installation completes without errors
- **THEN** the user is shown the required first-run initialization step and a clear "ready" verification result

#### Scenario: Harness install with missing prerequisites
- **WHEN** installation is attempted without required prerequisites such as `jq`
- **THEN** installation fails with actionable remediation guidance
- **AND** no partial broken configuration is left active

### Requirement: Runtime behavior parity with existing Habitat model
Codex harness execution MUST preserve Habitat's existing state lifecycle and species-driven rendering contract.

#### Scenario: Habitat runs in Codex harness after install
- **WHEN** a user invokes Habitat after successful harness setup
- **THEN** plant state is read and written from `~/.habitat/plant.json` using the same schema and stat mutation semantics as existing runtime behavior
