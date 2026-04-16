## MODIFIED Requirements

### Requirement: PostToolUse event mutations
The system SHALL mutate plant stats on PostToolUse events according to configured event mappings for `bash_tool`, `str_replace`/`create_file`, and `web_search`. XP gains SHALL be scaled by the active species' `xp_rate` multiplier and SHALL use the reduced base values defined below.

#### Scenario: Bash tool event with known command pattern
- **WHEN** a PostToolUse payload indicates `bash_tool` execution
- **THEN** hydration increases, 1 base XP is applied (scaled by xp_rate), and curiosity novelty logic runs for the command pattern

#### Scenario: Bash tool event with a new command pattern
- **WHEN** a PostToolUse payload indicates `bash_tool` execution with a command signature not previously seen
- **THEN** curiosity increases and an additional 2 base XP bonus is applied (scaled by xp_rate), on top of the base 1 XP

#### Scenario: File edit tool event
- **WHEN** a PostToolUse payload indicates `str_replace`, `create_file`, or equivalent edit tool
- **THEN** growth and rootedness increase, and 3 base XP (scaled by xp_rate) is applied

#### Scenario: Web search tool event
- **WHEN** a PostToolUse payload indicates a web search tool
- **THEN** curiosity increases and 2 base XP (scaled by xp_rate) is applied

### Requirement: Stop and Notification event handling
The system SHALL process Stop events for decay/session logic and Notification events for successful-completion health improvements.

#### Scenario: Stop event occurs
- **WHEN** a Stop hook invocation is received
- **THEN** the system applies a decay tick, increments session count once, and evaluates milestone triggers

#### Scenario: Successful completion notification
- **WHEN** a Notification event indicates task completion success
- **THEN** health increases without exceeding the configured maximum stat boundary

### Requirement: Hook runtime and behavior constraints
Hook scripts MUST complete quickly, avoid external API calls, and remain non-interactive so Claude Code output is not blocked or polluted.

#### Scenario: Hook executes under normal load
- **WHEN** a hook runs with valid event payload input
- **THEN** it finishes within the defined latency budget and writes no interactive output that interrupts user flow
