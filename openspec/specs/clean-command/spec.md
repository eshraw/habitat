## ADDED Requirements

### Requirement: Clean command exists and is accessible
The system SHALL provide a `/hbt:clean` slash command for removing all Habitat-managed local state and settings.

#### Scenario: Command is available
- **WHEN** a user types `/hbt:clean` in Claude Code
- **THEN** the command prompt is loaded and Claude begins the clean flow

### Requirement: Confirmation required before clean
The `/hbt:clean` command MUST inform the user of exactly what will be deleted and ask for explicit confirmation before proceeding.

#### Scenario: User confirms clean
- **WHEN** the user invokes `/hbt:clean` and confirms
- **THEN** Claude runs `habitat_clean.sh` and reports what was removed

#### Scenario: User declines clean
- **WHEN** the user invokes `/hbt:clean` and responds negatively
- **THEN** Claude cancels the operation, no files or settings are modified, and Claude acknowledges the cancellation

### Requirement: Clean removes state directory
The `habitat_clean.sh` script SHALL remove the `~/.habitat/` directory and all its contents.

#### Scenario: State directory present
- **WHEN** clean runs and `~/.habitat/` exists
- **THEN** the directory is deleted and the script reports it was removed

#### Scenario: State directory absent
- **WHEN** clean runs and `~/.habitat/` does not exist
- **THEN** the script continues without error and reports nothing to remove for that item

### Requirement: Clean removes injected settings entries
The `habitat_clean.sh` script SHALL remove the Habitat-injected `Read` permission entry and both hook entries (`PostToolUse` and `Stop`) from `~/.claude/settings.json`.

#### Scenario: Settings entries present
- **WHEN** clean runs and settings.json contains Habitat hook and permission entries
- **THEN** those entries are removed via `jq` and settings.json is rewritten; all other settings are preserved

#### Scenario: Settings entries absent or already removed
- **WHEN** clean runs and settings.json does not contain Habitat entries
- **THEN** the script reports nothing to remove for settings and exits cleanly

### Requirement: Clean is non-destructive to non-Habitat settings
The clean script MUST NOT remove any permissions or hooks that were not injected by Habitat's init script.

#### Scenario: User has other hooks configured
- **WHEN** clean runs on a settings.json that has non-Habitat hook entries alongside Habitat entries
- **THEN** only the Habitat entries (identified by the plugin path containing `habitat`) are removed; all other entries remain intact

### Requirement: Clean output guides re-initialization
After a successful clean, the command output SHALL inform the user that they can run `/hbt:init` if they want to set Habitat up again.

#### Scenario: Clean completes successfully
- **WHEN** `habitat_clean.sh` exits 0
- **THEN** Claude's response includes a note that `/hbt:init` can be used to reinstall
