#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_HOOKS_DIR="${ROOT_DIR}/hooks"
SRC_COMMANDS_DIR="${ROOT_DIR}/.claude/commands"

CLAUDE_DIR="${HOME}/.claude"
DEST_HOOKS_DIR="${CLAUDE_DIR}/hooks"
DEST_COMMANDS_DIR="${CLAUDE_DIR}/commands"
HABITAT_DIR="${HOME}/.habitat"

require_cmd() {
  local cmd="$1"
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "error: required dependency '${cmd}' is missing." >&2
    echo "install '${cmd}' and re-run ./install.sh" >&2
    exit 1
  fi
}

require_cmd jq

mkdir -p "${DEST_HOOKS_DIR}" "${DEST_COMMANDS_DIR}" "${HABITAT_DIR}"

cp "${SRC_HOOKS_DIR}/lib.sh" "${DEST_HOOKS_DIR}/lib.sh"
cp "${SRC_HOOKS_DIR}/on_tool.sh" "${DEST_HOOKS_DIR}/habitat_on_tool.sh"
cp "${SRC_HOOKS_DIR}/on_stop.sh" "${DEST_HOOKS_DIR}/habitat_on_stop.sh"
cp "${SRC_COMMANDS_DIR}/habitat.md" "${DEST_COMMANDS_DIR}/habitat.md"

chmod +x "${DEST_HOOKS_DIR}/habitat_on_tool.sh" "${DEST_HOOKS_DIR}/habitat_on_stop.sh"

echo "Habitat installed."
echo "Hooks copied to ${DEST_HOOKS_DIR}"
echo "Command copied to ${DEST_COMMANDS_DIR}/habitat.md"
