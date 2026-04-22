# Habitat

Habitat is a companion plant system for AI coding assistants. It gives you a living plant that evolves as you code.

<img src="openspec/specs/specs-assets/image.png" alt="habitat-plant"/>

## What it does

- Adds a `/habitat` command that renders your plant in chat.
- Stores plant state locally at `~/.habitat/plant.json`.
- Uses hooks to react to coding assistant events and update stats over time.
- Loads all species behavior from `species/*.json` (data-driven, no hardcoded species logic).

## Local-only by design

- No remote sync.
- No web dashboard.
- No permanent death state (plants become dormant and can recover).

## Requirements

- `bash`
- `jq`

## Install

### Claude Code (plugin-first)

```bash
claude plugin add eshraw/habitat
```

Then initialize:

```text
/hbt:init
```

### Codex CLI harness (plugin-first)

```bash
codex plugin add eshraw/habitat
```

Then initialize:

```text
/hbt:init
```

### Fallback (repository script)

If plugin install is unavailable, use the install script with an explicit target:

```bash
# Claude fallback
./install.sh --target claude

# Codex harness fallback
./install.sh --target codex-harness
```

Running `./install.sh` without a `--target` flag auto-detects the runtime:
- Uses `codex-harness` if `~/.codex/` exists, otherwise defaults to `claude`.

Installer behavior (both targets):

- Creates required directories and `~/.habitat` if needed.
- Copies hooks, commands, and species data into runtime-recognized locations.
- Is idempotent: re-running updates files without duplicate setup.
- Fails fast with remediation guidance if `jq` is missing.
- Cleans up partial installs on unexpected failure.

### Post-install verification

After installing for Codex harness, confirm setup is correct:

```bash
./scripts/verify_codex_install.sh
```

For Claude, the install script prints a readiness summary on completion.

## Hook behavior (v1)

- `PostToolUse` + `bash_tool`: increases hydration, and curiosity for new command patterns.
- `PostToolUse` + `str_replace`/`create_file`: increases growth and rootedness.
- `PostToolUse` + `web_search`: increases curiosity.
- `Notification` success: increases health (bounded to max).
- `Stop`: applies decay, increments sessions, and updates milestones.

## Verification

Run scripts after changes:

```bash
./scripts/validate_species.sh
./scripts/verify_hooks.sh
./scripts/verify_plugin_flow.sh
./scripts/verify_migration.sh
./scripts/verify_claude_regression.sh
./scripts/smoke_test.sh
```

What they verify:

- Species schema shape and required fields.
- State initialization, event mutations, and stop-session behavior.
- Hooks remain silent on stdout (non-interactive behavior).
- Plugin metadata and `/hbt:init` idempotency.
- Migration fallback behavior for users coming from script-based setup.
- Claude install regression (assets unchanged, idempotent after adding Codex support).
- Smoke tests for Claude and Codex harness install flows and reinstall idempotency.
