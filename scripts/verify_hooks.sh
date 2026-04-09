#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_HOME="${ROOT_DIR}/.tmp/test-home-hooks"
STATE_DIR="${TEST_HOME}/.habitat"
STATE_FILE="${STATE_DIR}/plant.json"

mkdir -p "${STATE_DIR}"
rm -f "${STATE_FILE}"

run_and_assert_silent() {
  local script="$1"
  local payload="$2"
  local out
  out="$(printf "%s" "${payload}" | HABITAT_HOME="${STATE_DIR}" bash "${script}")"
  if [ -n "${out}" ]; then
    echo "expected no stdout from ${script}" >&2
    exit 1
  fi
}

assert_jq() {
  local expr="$1"
  jq -e "${expr}" "${STATE_FILE}" >/dev/null
}

run_and_assert_silent "${ROOT_DIR}/hooks/on_tool.sh" '{"event":"PostToolUse","tool_name":"create_file"}'
assert_jq '.xp >= 5'
assert_jq '.stats.growth >= 49'

run_and_assert_silent "${ROOT_DIR}/hooks/on_tool.sh" '{"event":"PostToolUse","tool_name":"bash_tool","command":"git status"}'
assert_jq '.stats.hydration >= 63'

run_and_assert_silent "${ROOT_DIR}/hooks/on_stop.sh" '{"event":"Stop"}'
assert_jq '.sessions >= 1'

echo "Hook verification passed."
