#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_DIR="${ROOT_DIR}/habitat-claude"
SRC_HOOKS_DIR="${SHARED_DIR}/hooks"
SRC_COMMANDS_DIR="${SHARED_DIR}/commands"
SRC_SCRIPTS_DIR="${SHARED_DIR}/scripts"
SRC_SPECIES_DIR="${SHARED_DIR}/species"

HABITAT_DIR="${HOME}/.habitat"

# ── Target detection ──────────────────────────────────────────────────────────

TARGET=""
for arg in "$@"; do
  case "${arg}" in
    --target=*) TARGET="${arg#--target=}" ;;
    --target)   shift; TARGET="${1:-}" ;;
  esac
done

if [ -z "${TARGET}" ]; then
  if [ -d "${HOME}/.codex" ]; then
    TARGET="codex-harness"
  else
    TARGET="claude"
  fi
fi

case "${TARGET}" in
  claude|codex-harness) ;;
  *)
    echo "error: unknown --target '${TARGET}'. Use 'claude' or 'codex-harness'." >&2
    exit 1
    ;;
esac

# ── Preflight ─────────────────────────────────────────────────────────────────

require_cmd() {
  local cmd="$1"
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "error: required dependency '${cmd}' is missing." >&2
    echo "Install '${cmd}' and re-run ./install.sh --target ${TARGET}" >&2
    exit 1
  fi
}

require_cmd jq

copy_if_changed() {
  local src="$1"
  local dest="$2"
  if [ -f "${dest}" ] && cmp -s "${src}" "${dest}"; then
    return
  fi
  cp "${src}" "${dest}"
}

# ── Claude adapter ────────────────────────────────────────────────────────────

install_claude() {
  local claude_dir="${HOME}/.claude"
  local dest_hooks="${claude_dir}/hooks"
  local dest_commands="${claude_dir}/commands"

  mkdir -p "${dest_hooks}" "${dest_commands}" "${HABITAT_DIR}"

  copy_if_changed "${SRC_HOOKS_DIR}/lib.sh"          "${dest_hooks}/lib.sh"
  copy_if_changed "${SRC_HOOKS_DIR}/on_tool.sh"       "${dest_hooks}/habitat_on_tool.sh"
  copy_if_changed "${SRC_HOOKS_DIR}/on_stop.sh"        "${dest_hooks}/habitat_on_stop.sh"
  copy_if_changed "${SRC_SCRIPTS_DIR}/habitat_init.sh" "${dest_hooks}/habitat_init.sh"
  copy_if_changed "${SRC_COMMANDS_DIR}/habitat.md"     "${dest_commands}/habitat.md"
  copy_if_changed "${SRC_COMMANDS_DIR}/init.md"        "${dest_commands}/init.md"
  copy_if_changed "${SRC_COMMANDS_DIR}/reset.md"       "${dest_commands}/reset.md"
  copy_if_changed "${SRC_COMMANDS_DIR}/clean.md"       "${dest_commands}/clean.md"
  copy_if_changed "${SRC_SCRIPTS_DIR}/habitat_clean.sh" "${dest_hooks}/habitat_clean.sh"

  chmod +x \
    "${dest_hooks}/habitat_on_tool.sh" \
    "${dest_hooks}/habitat_on_stop.sh" \
    "${dest_hooks}/habitat_init.sh" \
    "${dest_hooks}/habitat_clean.sh"

  echo "Habitat installed (claude fallback mode)."
  echo "Recommended onboarding: claude plugin add eshraw/habitat"
  echo "Then run: /hbt:init"
  echo "Fallback assets copied to ${dest_hooks} and ${dest_commands}"
}

# ── Codex harness adapter ─────────────────────────────────────────────────────

install_codex_harness() {
  local codex_plugin_root="${HOME}/.codex/plugins/habitat"
  local dest_commands="${codex_plugin_root}/commands"
  local dest_hooks="${codex_plugin_root}/hooks"
  local dest_species="${codex_plugin_root}/species"
  local dest_scripts="${codex_plugin_root}/scripts"
  local codex_config="${HOME}/.codex/config.json"
  local codex_src="${ROOT_DIR}/habitat-codex"

  # Fail fast on missing source assets so partial installs don't leave broken state
  if [ ! -d "${codex_src}" ]; then
    echo "error: habitat-codex source directory not found at ${codex_src}" >&2
    echo "Ensure you are running from the habitat repository root." >&2
    exit 1
  fi

  # Clean up plugin root on unexpected failure to prevent mixed-state installs
  local _plugin_root_existed=false
  [ -d "${codex_plugin_root}" ] && _plugin_root_existed=true
  cleanup_on_fail() {
    local rc=$?
    if [ "${rc}" -ne 0 ] && [ "${_plugin_root_existed}" = "false" ]; then
      echo "Install failed — removing partial install at ${codex_plugin_root}" >&2
      rm -rf "${codex_plugin_root}"
    fi
    exit "${rc}"
  }
  trap cleanup_on_fail EXIT

  mkdir -p "${dest_commands}" "${dest_hooks}" "${dest_species}" "${dest_scripts}" "${HABITAT_DIR}"

  # Codex-specific packaging assets (commands, plugin manifest)
  copy_if_changed "${codex_src}/commands/habitat.md"      "${dest_commands}/habitat.md"
  copy_if_changed "${codex_src}/commands/init.md"          "${dest_commands}/init.md"
  copy_if_changed "${codex_src}/.codex-plugin/plugin.json" "${codex_plugin_root}/plugin.json"
  copy_if_changed "${codex_src}/hooks/hooks.json"           "${dest_hooks}/hooks.json"

  # Shared runtime assets from habitat-claude (single source of truth)
  copy_if_changed "${SRC_HOOKS_DIR}/lib.sh"           "${dest_hooks}/lib.sh"
  copy_if_changed "${SRC_HOOKS_DIR}/on_tool.sh"        "${dest_hooks}/on_tool.sh"
  copy_if_changed "${SRC_HOOKS_DIR}/on_stop.sh"         "${dest_hooks}/on_stop.sh"
  copy_if_changed "${SRC_SCRIPTS_DIR}/habitat_init.sh"  "${dest_scripts}/habitat_init.sh"
  copy_if_changed "${SRC_SCRIPTS_DIR}/habitat_clean.sh" "${dest_scripts}/habitat_clean.sh"

  for species_file in "${SRC_SPECIES_DIR}"/*.json; do
    [ -e "${species_file}" ] || continue
    copy_if_changed "${species_file}" "${dest_species}/$(basename "${species_file}")"
  done

  chmod +x \
    "${dest_hooks}/on_tool.sh" \
    "${dest_hooks}/on_stop.sh" \
    "${dest_scripts}/habitat_init.sh" \
    "${dest_scripts}/habitat_clean.sh"

  # Register hooks in ~/.codex/config.json (idempotent merge)
  [ -f "${codex_config}" ] || echo '{}' > "${codex_config}"

  local on_tool="bash \"${dest_hooks}/on_tool.sh\""
  local on_stop="bash \"${dest_hooks}/on_stop.sh\""

  if jq -e --arg cmd "${on_tool}" \
      '(.plugins.habitat.hooks.PostToolUse? // "") == $cmd' \
      "${codex_config}" >/dev/null 2>&1; then
    : # already registered
  else
    local tmp
    tmp="$(mktemp)"
    jq --arg on_tool "${on_tool}" --arg on_stop "${on_stop}" \
       --arg plugin_root "${codex_plugin_root}" '
      .plugins.habitat |= (. // {}) + {
        enabled: true,
        path: $plugin_root,
        hooks: {
          PostToolUse: $on_tool,
          Stop: $on_stop
        }
      }
    ' "${codex_config}" > "${tmp}" && mv "${tmp}" "${codex_config}"
  fi

  echo "Habitat installed (codex-harness mode)."
  echo "Plugin root: ${codex_plugin_root}"
  echo "Run /hbt:init inside Codex to initialize your plant."
}

# ── Dispatch ──────────────────────────────────────────────────────────────────

case "${TARGET}" in
  claude)        install_claude ;;
  codex-harness) install_codex_harness ;;
esac
