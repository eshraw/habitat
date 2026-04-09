## Context

Habitat v1 is a local-only Claude Code companion that combines a prompt-driven UI (`/habitat`) with shell hooks that mutate a persistent state file. The current direction constrains runtime surfaces: hooks must be fast, non-interactive, and dependency-light (`sh` + `jq`), while expressive rendering and narrative remain inside Claude prompt templates.

## Goals / Non-Goals

**Goals:**
- Ship a complete first-iteration lifecycle: spawn, persist, mutate, decay, and render.
- Keep species behavior data-driven through `species/*.json` so adding species avoids code changes.
- Enforce non-blocking hook execution and safe state updates under repeated event traffic.
- Keep installation and updates simple through file copy/sync into user Claude directories.

**Non-Goals:**
- No remote sync, account model, or cloud APIs.
- No web dashboard or external visualization surface.
- No permanent death state; lowest health transitions to recoverable dormancy.
- No Node/Python runtime requirement for hook logic.

## Decisions

1. **State schema is stable and append-friendly**
   - Store plant state in `~/.habitat/plant.json` with fixed top-level keys and a `stats` object.
   - New fields are added with defaults; existing keys are never renamed in place.
   - **Alternative considered:** versioned schema migrations in v1. Rejected to reduce complexity and avoid brittle upgrade paths this early.

2. **Hooks are deterministic mutators, not presenters**
   - `hooks/on_tool.sh` handles PostToolUse/Notification mutations and XP increments.
   - `hooks/on_stop.sh` handles decay tick, session increment, milestone checks, and dormant transitions.
   - **Alternative considered:** single all-events hook file. Rejected to preserve one-concern-per-file and reduce regression blast radius.

3. **Species logic comes from data contracts**
   - Hooks read species metadata (weights, stage thresholds) from `species/*.json`.
   - Stage transitions use species threshold arrays, never global constants in scripts.
   - **Alternative considered:** embedding species tables in shell code. Rejected because it violates extensibility and increases maintenance.

4. **`/habitat` command delegates visual intelligence to Claude**
   - Command template reads state and species definitions, then asks Claude to choose stage/variant rendering and write mood-aware text.
   - Scripts never generate ASCII directly.
   - **Alternative considered:** precomputed ASCII outputs from hooks. Rejected because output becomes static and harder to evolve.

5. **Installer remains file-based and idempotent**
   - `install.sh` ensures required directories exist and copies command/hooks safely.
   - Re-running install updates assets without duplicating files or requiring interactive steps.
   - **Alternative considered:** package manager distribution. Rejected for v1 simplicity and portability.

## Risks / Trade-offs

- **[Concurrent writes to `plant.json`]** -> Use atomic write pattern (`tmp` + move) to avoid partial writes and malformed JSON.
- **[`jq` missing on user machine]** -> Fail gracefully with install-time validation and actionable error messaging in docs/install script.
- **[Hook runtime exceeds latency budget]** -> Keep payload parsing narrow, avoid subprocess-heavy pipelines, and cap work per event.
- **[Species files drift from required shape]** -> Validate required keys at read time and skip invalid species with safe fallback behavior.
- **[Prompt output inconsistency]** -> Keep strict command template constraints for stats format and commentary length.

## Migration Plan

1. Introduce v1 state initializer for first-run users.
2. Ship install flow that writes/updates hooks and command template.
3. Add species contracts and baseline species files.
4. Verify hook events mutate expected stats and stage transitions.
5. Rollback path: restore previous command/hooks and preserve existing `plant.json` contents.

## Open Questions

- Should command novelty detection for `bash_tool` use exact command hashes or prefix-normalized patterns in v1?
- Should dormancy apply only at minimum health or also when hydration reaches floor for prolonged periods?
- Should milestone definitions remain code-driven in hooks or move into species/config data in a follow-up change?
