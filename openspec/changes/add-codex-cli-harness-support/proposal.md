## Why

Habitat should be installable through a lightweight `/plugin` workflow in both Claude and Codex, instead of being effectively Claude-only today. Aligning both runtimes on the same plugin-first install UX expands adoption while preserving one shared Habitat behavior model.

## What Changes

- Add a Codex CLI harness distribution path that installs Habitat commands, hooks, and state bootstrap wiring in a harness-compatible layout.
- Ensure both Claude and Codex install paths are plugin-first (`/plugin` entrypoint) with minimal setup friction.
- Define a shared runtime contract so Claude plugin and Codex harness entry points both use the same species data, state file, and hook mutation model.
- Document plugin install/verify steps and failure modes for both runtimes (missing `jq`, unsupported environment, partial install recovery).
- Extend installer/bootstrap requirements so provisioning is idempotent across both Claude plugin and Codex harness targets.

## Capabilities

### New Capabilities
- `codex-cli-harness-packaging`: Provide Codex plugin packaging, install metadata, and onboarding flow required to run Habitat through Codex CLI harness.

### Modified Capabilities
- `local-install-bootstrap`: Expand installer/bootstrap requirements to provision and validate both Claude plugin and Codex harness runtime assets.

## Impact

- Affected code: packaging manifests, install/bootstrap scripts, command/hook asset sync logic, and README/setup docs.
- Affected systems: Claude Code plugin runtime and Codex CLI harness runtime, both exposed through plugin installation flows.
- Dependencies: no new heavy runtime dependencies; continue shell + `jq` boundary.
