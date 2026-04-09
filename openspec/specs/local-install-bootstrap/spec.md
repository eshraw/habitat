## ADDED Requirements

### Requirement: Installer provisions required Claude assets
The installer SHALL place or update Habitat command and hook files into the user's Claude directories required for runtime behavior.

#### Scenario: First install
- **WHEN** a user runs the installer on a system without prior Habitat assets
- **THEN** required directories and files are created in expected locations

#### Scenario: Reinstall or upgrade
- **WHEN** a user reruns the installer with existing Habitat assets
- **THEN** files are updated idempotently without duplicating hooks or breaking command registration

### Requirement: Minimal runtime dependency enforcement
The installer MUST enforce the v1 dependency boundary for shell plus `jq` and avoid introducing Node or Python runtime requirements for hooks.

#### Scenario: Dependency check during install
- **WHEN** required lightweight dependencies are unavailable
- **THEN** the installer fails with actionable guidance and does not leave partial broken setup
