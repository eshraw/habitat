## Why

The current `install.sh` flow is manual and less aligned with native Claude plugin workflows. Moving to `claude plugin add habitat` plus an explicit `/habitat-init` command makes setup simpler, repeatable, and easier for new users.

## What Changes

- Introduce plugin-native install packaging so Habitat is installed via Claude plugin tooling instead of manual shell bootstrap.
- Add a `/habitat-init` command to perform first-time local setup and safe re-initialization.
- Refine existing install behavior to keep idempotency while removing direct dependence on `install.sh` for primary onboarding.
- Keep local-only behavior and shell + `jq` runtime constraints unchanged.

## Capabilities

### New Capabilities
- `claude-plugin-packaging`: Define plugin metadata and install hooks so Habitat can be installed through `claude plugin add habitat`.
- `habitat-init-command`: Provide a dedicated `/habitat-init` command that creates/validates local state and required runtime files.

### Modified Capabilities
- `local-install-bootstrap`: Change installation requirements from script-first (`install.sh`) to plugin-first onboarding with compatible migration behavior.

## Impact

- Affected code: plugin manifest/config files, `.claude/commands/`, bootstrap logic, and `README.md`.
- Affected UX: setup path changes from running `./install.sh` to plugin add + init command.
- Dependencies: no new runtime dependencies for hooks; `jq` remains required for JSON handling.
