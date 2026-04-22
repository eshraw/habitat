## Context

Habitat currently ships as a Claude plugin package plus script fallback install. The runtime model is intentionally lightweight: shell hooks mutate `~/.habitat/plant.json`, and slash-command prompts render state-driven output using species JSON definitions. We need Codex CLI harness support without forking plant logic, species data, or state semantics.

Constraints:
- Preserve existing Claude plugin behavior.
- Keep runtime dependency boundary at shell + `jq`.
- Avoid introducing remote services or daemon processes.
- Keep install/update idempotent across repeated runs.

## Goals / Non-Goals

**Goals:**
- Add a Codex harness-compatible packaging/install path for Habitat.
- Keep installation plugin-first and lightweight in both Claude and Codex (`/plugin` workflows).
- Reuse shared command templates, species definitions, and hook/state logic across runtimes.
- Define deterministic install/verification steps so users can confirm a healthy harness setup quickly.
- Ensure fallback and recovery behavior for partial installs and missing prerequisites.

**Non-Goals:**
- Re-architecting plant state or stat mutation rules.
- Introducing cloud sync, telemetry, or non-local storage.
- Replacing Claude plugin distribution; this is additive support.
- Building a separate Codex-only feature set.

## Decisions

1. **Single source of runtime assets**
   - Decision: Maintain one canonical set of Habitat assets (species data, state schema expectations, hook logic) and project runtime-specific wrappers around those assets.
   - Rationale: Prevent behavioral drift between Claude and Codex paths.
   - Alternatives considered:
     - Duplicate assets per runtime: rejected due to long-term divergence risk.
     - Generate assets on install dynamically: rejected as harder to validate/debug.

2. **Adapter-based install target selection**
   - Decision: Extend install/bootstrap flow with runtime adapters (`claude`, `codex-harness`) selected by explicit flag or auto-detection with safe fallback.
   - Rationale: Keeps bootstrap logic centralized while isolating target-specific path conventions.
   - Alternatives considered:
     - Separate installer scripts: rejected due to duplicated validation/update logic.
     - Hardcoded auto-detection only: rejected because explicit targeting is needed for CI and advanced local setups.

3. **Shared verification contract**
   - Decision: Add a post-install verification checklist that validates file placement, command discoverability, and state bootstrap readiness for the selected runtime.
   - Rationale: Users need fast confidence and clear diagnostics when setup fails.
   - Alternatives considered:
     - Rely on first command execution only: rejected due to delayed failure detection.

4. **No new runtime dependencies**
   - Decision: Keep Codex harness support within shell tooling and existing JSON processing (`jq`).
   - Rationale: Matches current install footprint and reduces adoption friction.
   - Alternatives considered:
     - Node/Python installer helper: rejected as unnecessary dependency expansion.

## Risks / Trade-offs

- **[Risk] Runtime path assumptions differ across Codex harness environments** -> **Mitigation:** implement explicit path discovery/override flags and verify before writing.
- **[Risk] Installer regression for existing Claude users** -> **Mitigation:** preserve Claude adapter as default where plugin metadata is detected and add regression checks in tasks.
- **[Risk] Partial install leaves mixed runtime artifacts** -> **Mitigation:** perform staged writes with preflight checks and idempotent overwrite rules.
- **[Trade-off] Adapter abstraction adds some script complexity** -> **Mitigation:** keep adapter interface minimal (resolve paths, install assets, validate).

## Migration Plan

1. Implement runtime adapter layer in installer/bootstrap path.
2. Add Codex harness packaging metadata and asset mapping.
3. Add `/plugin` onboarding and verification guidance for both Claude and Codex surfaces.
4. Update docs with target-specific setup and verify commands.
5. Run smoke tests:
   - Claude plugin path unchanged.
   - Fresh Codex harness install works.
   - Reinstall/upgrade remains idempotent.
6. Rollback strategy:
   - Re-run installer targeting previous stable runtime path.
   - Remove new Codex harness artifacts from target locations if validation fails.

## Open Questions

- What is the canonical Codex harness command registration directory expected across macOS/Linux environments?
- Should auto-detection prefer Claude plugin when both runtimes are present, or require explicit user choice?
- Do we need a dedicated health-check command, or is installer-time verification sufficient for v1?
