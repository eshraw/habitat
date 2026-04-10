#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=hooks/lib.sh
source "${SCRIPT_DIR}/../hooks/lib.sh"

if ! command -v jq >/dev/null 2>&1; then
  echo "Habitat init failed: 'jq' is required." >&2
  echo "Install jq, then run /habitat-init again." >&2
  exit 1
fi

mkdir -p "${HABITAT_DIR}"

# Inject read permission for ~/.habitat into Claude settings so /habitat
# never prompts the user for file access.
inject_read_permission() {
  local settings_file="${HOME}/.claude/settings.json"
  local perm="Read(${HABITAT_DIR}/**)"

  [ -f "${settings_file}" ] || echo '{}' > "${settings_file}"

  if jq -e --arg p "$perm" '(.permissions.allow // []) | index($p) != null' \
      "${settings_file}" >/dev/null 2>&1; then
    return  # already present
  fi

  local tmp
  tmp="$(mktemp)"
  jq --arg p "$perm" '.permissions.allow |= (. // []) + [$p]' \
    "${settings_file}" > "$tmp" && mv "$tmp" "${settings_file}"
}

inject_hooks() {
  local settings_file="${HOME}/.claude/settings.json"
  local plugin_dir="${HOME}/.claude/plugins/marketplaces/habitat/habitat-claude"
  local on_tool="${plugin_dir}/hooks/on_tool.sh"
  local on_stop="${plugin_dir}/hooks/on_stop.sh"

  [ -f "${settings_file}" ] || echo '{}' > "${settings_file}"

  # Check if habitat hooks are already registered
  if jq -e --arg cmd "$on_tool" \
      '.. | objects | select(.command? == $cmd)' \
      "${settings_file}" >/dev/null 2>&1; then
    return  # already present
  fi

  local tmp
  tmp="$(mktemp)"
  jq --arg on_tool "$on_tool" --arg on_stop "$on_stop" '
    .hooks.PostToolUse |= (. // []) + [{"hooks": [{"type": "command", "command": ("bash \"" + $on_tool + "\"")}]}] |
    .hooks.Stop        |= (. // []) + [{"hooks": [{"type": "command", "command": ("bash \"" + $on_stop + "\"")}]}]
  ' "${settings_file}" > "$tmp" && mv "$tmp" "${settings_file}"
}

inject_read_permission
inject_hooks

if [ -f "${PLANT_STATE}" ]; then
  if jq -e '.species and .stats and (.stats | type=="object") and (.xp|type=="number")' "${PLANT_STATE}" >/dev/null 2>&1; then
    echo "Habitat already initialized at ${PLANT_STATE}"
    exit 0
  fi

  backup="${PLANT_STATE}.invalid.$(date +%s)"
  mv "${PLANT_STATE}" "${backup}"
  echo "Existing invalid state moved to ${backup}"
fi

species="$(random_species)"
state_json="$(default_state_for_species "${species}")"
write_state_atomic "${state_json}"
echo "Habitat initialized at ${PLANT_STATE} (species: ${species})"
