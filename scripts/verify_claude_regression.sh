#!/usr/bin/env bash
# Regression check: confirm Claude fallback install behavior is unchanged after
# the addition of Codex harness support to install.sh.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_HOME="${ROOT_DIR}/.tmp/test-claude-regression"

rm -rf "${TEST_HOME}"
mkdir -p "${TEST_HOME}"

# First install
HOME="${TEST_HOME}" bash "${ROOT_DIR}/install.sh" --target claude >/dev/null

# Verify all required Claude assets are in place
test -f "${TEST_HOME}/.claude/commands/habitat.md"
test -f "${TEST_HOME}/.claude/commands/init.md"
test -f "${TEST_HOME}/.claude/commands/reset.md"
test -f "${TEST_HOME}/.claude/commands/clean.md"
test -f "${TEST_HOME}/.claude/hooks/habitat_on_tool.sh"
test -f "${TEST_HOME}/.claude/hooks/habitat_on_stop.sh"
test -f "${TEST_HOME}/.claude/hooks/habitat_init.sh"
test -f "${TEST_HOME}/.claude/hooks/habitat_clean.sh"
test -f "${TEST_HOME}/.claude/hooks/lib.sh"
test -x "${TEST_HOME}/.claude/hooks/habitat_on_tool.sh"
test -x "${TEST_HOME}/.claude/hooks/habitat_on_stop.sh"
test -x "${TEST_HOME}/.claude/hooks/habitat_init.sh"
test -x "${TEST_HOME}/.claude/hooks/habitat_clean.sh"

# Verify habitat state dir was created
test -d "${TEST_HOME}/.habitat"

# Idempotency: second install must not change any file content
hash_before="$(find "${TEST_HOME}/.claude" -type f | sort | xargs shasum | shasum | awk '{print $1}')"
HOME="${TEST_HOME}" bash "${ROOT_DIR}/install.sh" --target claude >/dev/null
hash_after="$(find "${TEST_HOME}/.claude" -type f | sort | xargs shasum | shasum | awk '{print $1}')"

if [ "${hash_before}" != "${hash_after}" ]; then
  echo "error: Claude install is not idempotent — files changed on reinstall" >&2
  exit 1
fi

echo "Claude install regression check passed."
