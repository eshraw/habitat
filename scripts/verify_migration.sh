#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_HOME="${ROOT_DIR}/.tmp/test-home-migration"

rm -rf "${TEST_HOME}"
mkdir -p "${TEST_HOME}"

HOME="${TEST_HOME}" bash "${ROOT_DIR}/install.sh" >/dev/null
HOME="${TEST_HOME}" bash "${ROOT_DIR}/install.sh" >/dev/null

test -f "${TEST_HOME}/.claude/commands/habitat.md"
test -f "${TEST_HOME}/.claude/commands/habitat-init.md"
test -f "${TEST_HOME}/.claude/hooks/habitat_on_tool.sh"
test -f "${TEST_HOME}/.claude/hooks/habitat_on_stop.sh"
test -f "${TEST_HOME}/.claude/hooks/habitat_init.sh"

echo "Migration fallback verification passed."
