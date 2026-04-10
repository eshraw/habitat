#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="${ROOT_DIR}/habitat-claude"
SRC_HOOKS_DIR="${PLUGIN_DIR}/hooks"
SRC_COMMANDS_DIR="${PLUGIN_DIR}/commands"
SRC_SCRIPTS_DIR="${PLUGIN_DIR}/scripts"

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

copy_if_changed() {
  local src="$1"
  local dest="$2"
  if [ -f "${dest}" ] && cmp -s "${src}" "${dest}"; then
    return
  fi
  cp "${src}" "${dest}"
}

copy_if_changed "${SRC_HOOKS_DIR}/lib.sh" "${DEST_HOOKS_DIR}/lib.sh"
copy_if_changed "${SRC_HOOKS_DIR}/on_tool.sh" "${DEST_HOOKS_DIR}/habitat_on_tool.sh"
copy_if_changed "${SRC_HOOKS_DIR}/on_stop.sh" "${DEST_HOOKS_DIR}/habitat_on_stop.sh"
copy_if_changed "${SRC_SCRIPTS_DIR}/habitat_init.sh" "${DEST_HOOKS_DIR}/habitat_init.sh"
copy_if_changed "${SRC_COMMANDS_DIR}/habitat.md" "${DEST_COMMANDS_DIR}/habitat.md"
copy_if_changed "${SRC_COMMANDS_DIR}/habitat-init.md" "${DEST_COMMANDS_DIR}/habitat-init.md"

chmod +x "${DEST_HOOKS_DIR}/habitat_on_tool.sh" "${DEST_HOOKS_DIR}/habitat_on_stop.sh" "${DEST_HOOKS_DIR}/habitat_init.sh"

echo "Habitat installed (fallback mode)."
echo "Recommended onboarding: claude plugin add habitat"
echo "Then run: /habitat-init"
echo "Fallback assets copied to ${DEST_HOOKS_DIR} and ${DEST_COMMANDS_DIR}"
