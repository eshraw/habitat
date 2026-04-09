#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_HOME="${ROOT_DIR}/.tmp/test-home-plugin"
STATE_DIR="${TEST_HOME}/.habitat"
STATE_FILE="${STATE_DIR}/plant.json"

jq -e '.name=="habitat" and .minimum_claude_cli and (.commands|length>=2) and (.hooks|length>=2)' "${ROOT_DIR}/claude-plugin.json" >/dev/null

rm -rf "${TEST_HOME}"
mkdir -p "${TEST_HOME}"

HABITAT_HOME="${STATE_DIR}" bash "${ROOT_DIR}/scripts/habitat_init.sh" >/dev/null
test -f "${STATE_FILE}"
before_hash="$(shasum "${STATE_FILE}" | awk '{print $1}')"
HABITAT_HOME="${STATE_DIR}" bash "${ROOT_DIR}/scripts/habitat_init.sh" >/dev/null
after_hash="$(shasum "${STATE_FILE}" | awk '{print $1}')"

if [ "${before_hash}" != "${after_hash}" ]; then
  echo "init is not idempotent" >&2
  exit 1
fi

echo "Plugin flow verification passed."
