## ADDED Requirements

### Requirement: Stash active plant into cabinet
The system SHALL copy the current active plant's state to `~/.habitat/cabinet/` and freeze it there, so it no longer receives hook events or decays.

#### Scenario: User stashes the active plant
- **WHEN** the user invokes `/habitat stash`
- **THEN** the active plant JSON is written to `~/.habitat/cabinet/<species>-<born-slug>.json` and the user is shown a confirmation with the plant's name/species

#### Scenario: Stash when cabinet directory does not yet exist
- **WHEN** the user invokes `/habitat stash` and `~/.habitat/cabinet/` is missing
- **THEN** the directory is created automatically before writing the cabinet file

### Requirement: List cabinet plants
The system SHALL display all stashed plants in the cabinet with enough information for the user to identify and choose among them.

#### Scenario: User views non-empty cabinet
- **WHEN** the user invokes `/habitat cabinet`
- **THEN** each stashed plant is shown with its species, stage name, dominant stat, and time since it was stashed

#### Scenario: User views empty cabinet
- **WHEN** the user invokes `/habitat cabinet` and no plants are stashed
- **THEN** the system informs the user the cabinet is empty and suggests using `/habitat stash` to add one

#### Scenario: Cabinet contains more than 20 plants
- **WHEN** the user invokes `/habitat cabinet` and the cabinet holds more than 20 plants
- **THEN** the system displays all plants and appends a note suggesting the user might want to prune old entries manually

### Requirement: Swap a stashed plant with the active plant
The system SHALL swap a chosen stashed plant into the active slot, automatically stashing the current active plant in the process.

#### Scenario: User swaps in a cabinet plant
- **WHEN** the user invokes `/habitat swap` and selects a plant from the cabinet
- **THEN** the current active plant is written to the cabinet, the chosen cabinet plant is written to `~/.habitat/plant.json`, and the chosen plant is removed from the cabinet file

#### Scenario: Write-then-delete ordering on swap
- **WHEN** a swap operation is performed
- **THEN** the new active plant file is written successfully before the cabinet entry is removed, so a partial failure does not destroy either plant

### Requirement: Start a new plant without losing the active plant
The system SHALL allow users to begin a fresh plant while stashing the current one, rather than resetting.

#### Scenario: User starts a new plant via stash-and-new flow
- **WHEN** the user invokes `/habitat stash` and then `/habitat` with no existing active plant (or triggers new-plant flow explicitly)
- **THEN** a new random-species plant is initialised as the active plant and the former plant remains safely in the cabinet
