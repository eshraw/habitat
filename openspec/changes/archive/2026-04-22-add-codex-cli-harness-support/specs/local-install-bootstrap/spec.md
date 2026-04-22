## MODIFIED Requirements

### Requirement: Installer provisions required Claude assets
The installer SHALL place or update Habitat command and hook files into the selected runtime target directories, supporting Claude plugin installation as the primary Claude onboarding path, Codex CLI harness installation as a first-class runtime path, and script-based install as compatibility fallback.

#### Scenario: First install via plugin
- **WHEN** a user installs Habitat through `claude plugin add habitat`
- **THEN** required command and hook assets are available to Claude without manual repository script execution

#### Scenario: First install via Codex harness target
- **WHEN** a user installs Habitat for Codex CLI harness
- **THEN** required command and hook assets are provisioned in harness-recognized locations without manual file copying

#### Scenario: Reinstall or upgrade
- **WHEN** a user reinstalls or upgrades Habitat through a supported install workflow
- **THEN** assets are updated idempotently without duplicate registration or broken command paths

#### Scenario: Compatibility fallback install
- **WHEN** plugin or harness-native install is unavailable in the user's environment and the fallback script path is used
- **THEN** required assets are provisioned with behavior equivalent to supported runtime installs

### Requirement: Minimal runtime dependency enforcement
The installer MUST enforce the Habitat runtime dependency boundary for shell plus `jq` across Claude plugin, Codex harness, and fallback script setup paths.

#### Scenario: Dependency check during init or install
- **WHEN** required lightweight dependencies are unavailable
- **THEN** setup fails with actionable guidance and does not leave partial broken configuration
