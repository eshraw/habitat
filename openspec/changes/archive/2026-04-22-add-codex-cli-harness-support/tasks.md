## 1. Runtime adapter and packaging foundation

- [x] 1.1 Add installer/bootstrap runtime-target selection (`claude`, `codex-harness`, fallback) with preflight validation.
- [x] 1.2 Define Codex plugin packaging metadata (`.codex-plugin/plugin.json`) and map Habitat command/hook assets to harness-recognized install paths.
- [x] 1.3 Keep shared Habitat assets (species definitions, state contract, hook mutation logic) as single-source inputs used by both runtimes.
- [x] 1.4 Define and document plugin-first install entrypoints for both Claude and Codex (`/plugin` workflows).

## 2. Install, verify, and error handling

- [x] 2.1 Implement Codex harness install flow that provisions assets idempotently and supports upgrade/reinstall.
- [x] 2.2 Add post-install verification checks for command discoverability, hook wiring, and `~/.habitat/plant.json` readiness.
- [x] 2.3 Implement failure handling for missing prerequisites (`jq`) and partial install cleanup/recovery messaging.
- [x] 2.4 Ensure plugin install in both runtimes stays lightweight (no new heavy runtime dependencies).

## 3. Regression coverage and documentation

- [x] 3.1 Add regression checks to confirm existing Claude plugin install behavior remains unchanged.
- [x] 3.2 Add smoke tests for plugin install in Claude and Codex plus Codex reinstall idempotency.
- [x] 3.3 Update README and onboarding docs with plugin-first (`/plugin`) install and verification instructions for both runtimes.
