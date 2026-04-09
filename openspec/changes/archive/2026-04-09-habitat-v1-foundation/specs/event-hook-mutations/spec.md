## ADDED Requirements

### Requirement: PostToolUse event mutations
The system SHALL mutate plant stats on PostToolUse events according to configured event mappings for `bash_tool`, `str_replace`/`create_file`, and `web_search`.

#### Scenario: Bash tool event with known command pattern
- **WHEN** a PostToolUse payload indicates `bash_tool` execution
- **THEN** hydration increases and curiosity handling follows novelty logic for command patterns

#### Scenario: File edit tool event
- **WHEN** a PostToolUse payload indicates `str_replace` or `create_file`
- **THEN** growth and rootedness increase based on configured mutation amounts

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
