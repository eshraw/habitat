#!/usr/bin/env bash
# Post-install verification for Codex harness Habitat install.
# Usage: CODEX_PLUGIN_ROOT=<path> bash verify_codex_install.sh
# Defaults to ~/.codex/plugins/habitat when not set.
set -euo pipefail

PLUGIN_ROOT="${CODEX_PLUGIN_ROOT:-${HOME}/.codex/plugins/habitat}"
HABITAT_DIR="${HABITAT_HOME:-${HOME}/.habitat}"
CODEX_CONFIG="${CODEX_CONFIG_FILE:-${HOME}/.codex/config.json}"
fail=0

check() {
  local label="$1"
  local path="$2"
  if [ -e "${path}" ]; then
    echo "  ok  ${label}"
  else
    echo "  MISSING  ${label} (${path})" >&2
    fail=1
  fi
}

check_exec() {
  local label="$1"
  local path="$2"
  if [ -x "${path}" ]; then
    echo "  ok  ${label}"
  else
    echo "  NOT EXECUTABLE  ${label} (${path})" >&2
    fail=1
  fi
}

echo "=== Habitat Codex harness install verification ==="
echo ""

echo "Commands:"
check "habitat.md"  "${PLUGIN_ROOT}/commands/habitat.md"
check "init.md"      "${PLUGIN_ROOT}/commands/init.md"

echo ""
echo "Hooks:"
check_exec "on_tool.sh"  "${PLUGIN_ROOT}/hooks/on_tool.sh"
check_exec "on_stop.sh"  "${PLUGIN_ROOT}/hooks/on_stop.sh"
check      "lib.sh"       "${PLUGIN_ROOT}/hooks/lib.sh"
check      "hooks.json"   "${PLUGIN_ROOT}/hooks/hooks.json"

echo ""
echo "Scripts:"
check_exec "habitat_init.sh"  "${PLUGIN_ROOT}/scripts/habitat_init.sh"
check_exec "habitat_clean.sh" "${PLUGIN_ROOT}/scripts/habitat_clean.sh"

echo ""
echo "Plugin manifest:"
check "plugin.json" "${PLUGIN_ROOT}/plugin.json"

echo ""
echo "Species:"
species_count=0
for f in "${PLUGIN_ROOT}/species/"*.json; do
  [ -e "${f}" ] && species_count=$((species_count + 1))
done
if [ "${species_count}" -ge 1 ]; then
  echo "  ok  ${species_count} species file(s)"
else
  echo "  MISSING  no species files in ${PLUGIN_ROOT}/species/" >&2
  fail=1
fi

echo ""
echo "Harness hook registration:"
if [ -f "${CODEX_CONFIG}" ] && \
   jq -e '.plugins.habitat.hooks.PostToolUse? // empty | length > 0' \
      "${CODEX_CONFIG}" >/dev/null 2>&1; then
  echo "  ok  hooks registered in ${CODEX_CONFIG}"
else
  echo "  MISSING  habitat hooks not registered in ${CODEX_CONFIG}" >&2
  fail=1
fi

echo ""
echo "State readiness:"
if [ -d "${HABITAT_DIR}" ]; then
  echo "  ok  ~/.habitat directory exists"
  if [ -f "${HABITAT_DIR}/plant.json" ]; then
    if jq -e '.species and .stats' "${HABITAT_DIR}/plant.json" >/dev/null 2>&1; then
      echo "  ok  plant.json is valid"
    else
      echo "  warning  plant.json exists but may be invalid — run /hbt:init"
    fi
  else
    echo "  info  plant.json not yet created — run /hbt:init to initialize"
  fi
else
  echo "  info  ~/.habitat not yet created — run /hbt:init to initialize"
fi

echo ""
if [ "${fail}" -ne 0 ]; then
  echo "Verification FAILED. Re-run: ./install.sh --target codex-harness" >&2
  exit 1
fi
echo "Habitat Codex harness install verified successfully."
