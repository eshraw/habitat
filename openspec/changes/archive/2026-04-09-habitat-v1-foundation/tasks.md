## 1. State Lifecycle Foundation

- [x] 1.1 Implement first-run state initialization in `~/.habitat/plant.json` with append-friendly default fields.
- [x] 1.2 Add atomic state write/read helpers used by all hooks and command flows.
- [x] 1.3 Implement XP-to-stage computation using per-species thresholds from species definition files.
- [x] 1.4 Implement dormant transition and recovery logic at minimum health without permanent-death paths.

## 2. Hook Event Mutations

- [x] 2.1 Implement `hooks/on_tool.sh` handling for `bash_tool`, `str_replace`, `create_file`, and `web_search` stat mutations.
- [x] 2.2 Implement command-pattern novelty tracking for `bash_tool` curiosity behavior.
- [x] 2.3 Implement Stop-event decay/session/milestone logic in `hooks/on_stop.sh`.
- [x] 2.4 Implement Notification success handling for bounded health improvements.
- [x] 2.5 Add guardrails and checks to keep hooks non-interactive, dependency-light, and under latency budget.

## 3. Species Data Contracts

- [x] 3.1 Define and document required species schema fields (weights, thresholds, stage art, variants, flavor descriptors).
- [x] 3.2 Add runtime validation/fallback handling for missing or malformed species fields.
- [x] 3.3 Implement stage 4/5 rare-variant selection inputs based on dominant stat signals.

## 4. `/habitat` Command Rendering

- [x] 4.1 Update `.claude/commands/habitat.md` to load existing state or trigger first-run spawn behavior.
- [x] 4.2 Ensure command prompt delegates stage rendering and commentary generation to Claude using species/state context.
- [x] 4.3 Add compact stats display instructions to command output format.
- [x] 4.4 Validate command behavior for both existing-plant and first-run scenarios.

## 5. Local Install Bootstrap

- [x] 5.1 Update `install.sh` to provision required command/hook paths and copy files idempotently.
- [x] 5.2 Add install-time dependency checks for shell + `jq` with clear failure guidance.
- [x] 5.3 Verify reinstall/upgrade path updates files safely without duplicate registration.

## 6. Verification and Documentation

- [x] 6.1 Add/refresh tests or validation scripts covering state init, stage transitions, event mutations, and dormancy recovery.
- [x] 6.2 Add verification steps for hook runtime constraints and no-output behavior.
- [x] 6.3 Update `README.md` with v1 install, behavior, and local-only constraints.
