## Context

Habitat currently relies on a repository-local `install.sh` workflow that copies files into user Claude directories. The new goal is to support plugin-native onboarding (`claude plugin add habitat`) and introduce `/habitat-init` as the explicit initialization entrypoint while keeping local-only behavior and the current hook/runtime constraints.

## Goals / Non-Goals

**Goals:**
- Make plugin installation the primary onboarding path.
- Provide a deterministic `/habitat-init` command for first-run setup and safe re-init.
- Preserve idempotent installation semantics and compatibility for existing users.
- Keep runtime dependency boundary unchanged (`bash` + `jq` for state/hook logic).

**Non-Goals:**
- No remote provisioning, cloud setup, or account-linked initialization.
- No change to plant evolution mechanics or species balancing in this change.
- No requirement for Node/Python runtime in hooks.

## Decisions

1. **Plugin-first install contract**
   - Introduce plugin metadata/package files so Claude can install Habitat via `claude plugin add habitat`.
   - Keep script-based install as optional fallback during migration.
   - **Alternative considered:** remove `install.sh` immediately. Rejected to avoid breaking existing manual flows.

2. **Initialization separated from install**
   - Add `/habitat-init` to create/validate `~/.habitat/plant.json` and check runtime prerequisites.
   - `/habitat` remains focused on rendering and should not perform heavy setup after this migration.
   - **Alternative considered:** implicit init only in `/habitat`. Rejected for reduced observability and harder troubleshooting.

3. **Idempotent migration behavior**
   - `/habitat-init` detects existing valid state and avoids destructive overwrites unless explicitly asked.
   - Existing installs can run init safely multiple times.
   - **Alternative considered:** force-reset state on init. Rejected because it destroys user progression.

4. **Command-level dependency validation**
   - `/habitat-init` surfaces missing `jq` with actionable guidance.
   - Plugin install itself stays lightweight; runtime checks happen at init/use time.
   - **Alternative considered:** fail plugin install on missing `jq`. Rejected because dependency availability can change post-install.

## Risks / Trade-offs

- **[CLI plugin API differences across versions]** -> Define minimum supported Claude CLI version and document fallback install path.
- **[Users skip `/habitat-init`]** -> Add clear prompt in README and `/habitat` guidance when state is missing or invalid.
- **[Migration confusion from dual install paths]** -> Mark plugin flow as recommended and script path as compatibility fallback.
- **[State corruption from partial init]** -> Use atomic writes and validation before replacing state files.

## Migration Plan

1. Add plugin packaging metadata and publish/install instructions.
2. Add `/habitat-init` command with validation + idempotent initialization behavior.
3. Update `/habitat` command docs to point users to `/habitat-init` when needed.
4. Keep `install.sh` documented as compatibility fallback for one release cycle.
5. Validate clean install (`plugin add` + init), existing-user upgrade, and repeated init behavior.

## Open Questions

- Which exact plugin metadata format/version is required by the target Claude CLI release?
- Should `/habitat-init` support a `--reset` mode now or in a follow-up change?
- Should `install.sh` be deprecated immediately in docs or after one additional release?
