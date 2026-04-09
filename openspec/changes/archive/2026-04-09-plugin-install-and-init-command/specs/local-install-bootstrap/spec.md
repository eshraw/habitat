## MODIFIED Requirements

### Requirement: Installer provisions required Claude assets
The installer SHALL place or update Habitat command and hook files into the user's Claude directories required for runtime behavior, with plugin-based installation as the primary onboarding path and script-based install as compatibility fallback.

#### Scenario: First install via plugin
- **WHEN** a user installs Habitat through `claude plugin add habitat`
- **THEN** required command and hook assets are available to Claude without manual repository script execution

#### Scenario: Reinstall or upgrade
- **WHEN** a user reinstalls or upgrades Habitat through the plugin workflow
- **THEN** assets are updated idempotently without duplicate registration or broken command paths

#### Scenario: Compatibility fallback install
- **WHEN** plugin install is unavailable in the user's environment and the fallback script path is used
- **THEN** required assets are provisioned with behavior equivalent to plugin-installed assets

### Requirement: Minimal runtime dependency enforcement
The installer MUST enforce the Habitat runtime dependency boundary for shell plus `jq`, whether setup is performed via plugin onboarding or fallback script path.

#### Scenario: Dependency check during init or install
- **WHEN** required lightweight dependencies are unavailable
- **THEN** setup fails with actionable guidance and does not leave partial broken configuration
