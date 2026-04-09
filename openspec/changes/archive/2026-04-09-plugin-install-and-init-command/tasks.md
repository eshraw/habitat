## 1. Plugin Packaging Foundation

- [x] 1.1 Add Claude plugin manifest/metadata files required for `claude plugin add habitat`.
- [x] 1.2 Define supported Claude CLI compatibility version(s) and document them in plugin metadata and docs.
- [x] 1.3 Wire packaged assets so Habitat commands/hooks are discoverable after plugin installation.

## 2. `/habitat-init` Command

- [x] 2.1 Add `.claude/commands/habitat-init.md` with first-run initialization flow and clear success/failure messaging.
- [x] 2.2 Implement init path to create/validate `~/.habitat/plant.json` and required directories atomically.
- [x] 2.3 Ensure init is idempotent and preserves existing progression by default.
- [x] 2.4 Add runtime prerequisite checks (`jq`) with actionable remediation guidance.

## 3. Install Flow Migration

- [x] 3.1 Update existing bootstrap/install logic to treat plugin install as primary path.
- [x] 3.2 Keep `install.sh` as explicit compatibility fallback with behavior parity.
- [x] 3.3 Add guardrails preventing duplicate hook/command registration during reinstall/upgrade.

## 4. `/habitat` and UX Integration

- [x] 4.1 Update `/habitat` guidance to detect missing/uninitialized state and direct users to `/habitat-init`.
- [x] 4.2 Ensure plugin post-install messaging points to `/habitat-init` as required next step.

## 5. Verification and Documentation

- [x] 5.1 Add tests/verification scripts for plugin install path, init idempotency, and dependency failure cases.
- [x] 5.2 Add migration verification steps for existing users upgrading from script-based installs.
- [x] 5.3 Update `README.md` onboarding to plugin-first (`claude plugin add habitat` then `/habitat-init`) with fallback instructions.
