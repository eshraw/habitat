---
description: Initialize Habitat state and runtime prerequisites
---

Initialize Habitat for this user.

1. Verify `jq` is available.
2. From the habitat repository root, run:
   - `bash "./scripts/habitat_init.sh"`
3. Report one of:
   - success with state path and selected species (first init)
   - already initialized (idempotent rerun)
   - clear remediation when `jq` is missing

Guidelines:
- Do not reset existing valid progression.
- If state is invalid JSON, keep a backup and reinitialize.
- Keep output short and actionable.
