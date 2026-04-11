#!/usr/bin/env bash
# habitat_clean.sh — remove all Habitat-managed local state and settings entries.
# Safe to run multiple times (idempotent). Does not touch non-Habitat settings.
set -euo pipefail

HABITAT_DIR="${HABITAT_HOME:-${HOME}/.habitat}"
SETTINGS_FILE="${HOME}/.claude/settings.json"
CLAUDE_HOOKS_DIR="${HOME}/.claude/hooks"
CLAUDE_COMMANDS_DIR="${HOME}/.claude/commands"
PERM_ENTRY="Read(${HABITAT_DIR}/**)"

removed=()
skipped=()

# ── 1. Remove state directory ──────────────────────────────────────────────────
if [ -d "${HABITAT_DIR}" ]; then
  rm -rf "${HABITAT_DIR}"
  removed+=("state directory: ${HABITAT_DIR}")
else
  skipped+=("state directory: ${HABITAT_DIR} (not found)")
fi

# ── 2. Remove installed command files ─────────────────────────────────────────
for cmd in habitat.md init.md reset.md clean.md; do
  f="${CLAUDE_COMMANDS_DIR}/${cmd}"
  if [ -f "${f}" ]; then
    rm -f "${f}"
    removed+=("command file: ${f}")
  else
    skipped+=("command file: ${f} (not found)")
  fi
done

# ── 3. Remove installed hook/script files ─────────────────────────────────────
for hook in habitat_on_tool.sh habitat_on_stop.sh habitat_init.sh habitat_statusline.sh lib.sh; do
  f="${CLAUDE_HOOKS_DIR}/${hook}"
  if [ -f "${f}" ]; then
    rm -f "${f}"
    removed+=("hook file: ${f}")
  else
    skipped+=("hook file: ${f} (not found)")
  fi
done
# Remove self last so the script can finish
if [ -f "${CLAUDE_HOOKS_DIR}/habitat_clean.sh" ]; then
  rm -f "${CLAUDE_HOOKS_DIR}/habitat_clean.sh"
  removed+=("hook file: ${CLAUDE_HOOKS_DIR}/habitat_clean.sh")
fi

# ── 4. Clean settings.json ─────────────────────────────────────────────────────
if [ ! -f "${SETTINGS_FILE}" ]; then
  skipped+=("settings.json: not found at ${SETTINGS_FILE}")
else
  tmp="$(mktemp)"

  # Remove Read permission entry for ~/.habitat/**
  jq --arg p "${PERM_ENTRY}" '
    if (.permissions.allow // []) | index($p) != null
    then .permissions.allow |= map(select(. != $p))
    else .
    end
  ' "${SETTINGS_FILE}" > "${tmp}" && mv "${tmp}" "${SETTINGS_FILE}"

  # Remove PostToolUse hook entries whose command contains "habitat"
  tmp="$(mktemp)"
  jq '
    if .hooks.PostToolUse then
      .hooks.PostToolUse |= map(
        .hooks |= map(select(.command | contains("habitat") | not))
        | select(.hooks | length > 0)
      )
      | if (.hooks.PostToolUse | length) == 0 then del(.hooks.PostToolUse) else . end
    else .
    end
  ' "${SETTINGS_FILE}" > "${tmp}" && mv "${tmp}" "${SETTINGS_FILE}"

  # Remove Stop hook entries whose command contains "habitat"
  tmp="$(mktemp)"
  jq '
    if .hooks.Stop then
      .hooks.Stop |= map(
        .hooks |= map(select(.command | contains("habitat") | not))
        | select(.hooks | length > 0)
      )
      | if (.hooks.Stop | length) == 0 then del(.hooks.Stop) else . end
    else .
    end
  ' "${SETTINGS_FILE}" > "${tmp}" && mv "${tmp}" "${SETTINGS_FILE}"

  # Remove statusLine if it points to a habitat script
  tmp="$(mktemp)"
  jq '
    if (.statusLine.command // "") | contains("habitat")
    then del(.statusLine)
    else .
    end
  ' "${SETTINGS_FILE}" > "${tmp}" && mv "${tmp}" "${SETTINGS_FILE}"

  removed+=("Habitat entries from ${SETTINGS_FILE}")
fi

# ── 5. Report ──────────────────────────────────────────────────────────────────
echo "Habitat clean complete."
for item in "${removed[@]+"${removed[@]}"}"; do
  echo "  removed: ${item}"
done
for item in "${skipped[@]+"${skipped[@]}"}"; do
  echo "  skipped: ${item}"
done
