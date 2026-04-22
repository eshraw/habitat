#!/usr/bin/env bash
# Smoke tests: Claude plugin install, Codex harness install, Codex reinstall idempotency.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
pass=0
fail=0

run_test() {
  local name="$1"
  local cmd="$2"
  if eval "${cmd}" >/dev/null 2>&1; then
    echo "  PASS  ${name}"
    pass=$((pass + 1))
  else
    echo "  FAIL  ${name}" >&2
    fail=$((fail + 1))
  fi
}

echo "=== Habitat smoke tests ==="
echo ""

# ── Claude install ─────────────────────────────────────────────────────────────

CLAUDE_TEST_HOME="${ROOT_DIR}/.tmp/smoke-claude"
rm -rf "${CLAUDE_TEST_HOME}" && mkdir -p "${CLAUDE_TEST_HOME}"

run_test "Claude: fresh install exits 0" \
  "HOME=${CLAUDE_TEST_HOME} bash ${ROOT_DIR}/install.sh --target claude"

run_test "Claude: habitat.md command present" \
  "test -f ${CLAUDE_TEST_HOME}/.claude/commands/habitat.md"

run_test "Claude: hook scripts executable" \
  "test -x ${CLAUDE_TEST_HOME}/.claude/hooks/habitat_on_tool.sh && \
   test -x ${CLAUDE_TEST_HOME}/.claude/hooks/habitat_on_stop.sh"

run_test "Claude: reinstall is idempotent" \
  "HOME=${CLAUDE_TEST_HOME} bash ${ROOT_DIR}/install.sh --target claude"

# ── Codex harness install ──────────────────────────────────────────────────────

CODEX_TEST_HOME="${ROOT_DIR}/.tmp/smoke-codex"
rm -rf "${CODEX_TEST_HOME}" && mkdir -p "${CODEX_TEST_HOME}"

run_test "Codex: fresh install exits 0" \
  "HOME=${CODEX_TEST_HOME} bash ${ROOT_DIR}/install.sh --target codex-harness"

run_test "Codex: habitat.md command present" \
  "test -f ${CODEX_TEST_HOME}/.codex/plugins/habitat/commands/habitat.md"

run_test "Codex: hook scripts executable" \
  "test -x ${CODEX_TEST_HOME}/.codex/plugins/habitat/hooks/on_tool.sh && \
   test -x ${CODEX_TEST_HOME}/.codex/plugins/habitat/hooks/on_stop.sh"

run_test "Codex: plugin.json present" \
  "test -f ${CODEX_TEST_HOME}/.codex/plugins/habitat/plugin.json"

run_test "Codex: species files present" \
  "ls ${CODEX_TEST_HOME}/.codex/plugins/habitat/species/*.json >/dev/null 2>&1"

run_test "Codex: hooks registered in config.json" \
  "jq -e '.plugins.habitat.hooks.PostToolUse? // empty | length > 0' \
    ${CODEX_TEST_HOME}/.codex/config.json"

# ── Codex reinstall idempotency ────────────────────────────────────────────────

hash_before="$(find "${CODEX_TEST_HOME}/.codex/plugins/habitat" -type f | sort | \
               xargs shasum 2>/dev/null | shasum | awk '{print $1}')"
HOME="${CODEX_TEST_HOME}" bash "${ROOT_DIR}/install.sh" --target codex-harness >/dev/null 2>&1
hash_after="$(find "${CODEX_TEST_HOME}/.codex/plugins/habitat" -type f | sort | \
              xargs shasum 2>/dev/null | shasum | awk '{print $1}')"

if [ "${hash_before}" = "${hash_after}" ]; then
  echo "  PASS  Codex: reinstall is idempotent"
  pass=$((pass + 1))
else
  echo "  FAIL  Codex: reinstall changed files unexpectedly" >&2
  fail=$((fail + 1))
fi

# ── Codex post-install verification ───────────────────────────────────────────

run_test "Codex: verify_codex_install.sh passes" \
  "CODEX_PLUGIN_ROOT=${CODEX_TEST_HOME}/.codex/plugins/habitat \
   CODEX_CONFIG_FILE=${CODEX_TEST_HOME}/.codex/config.json \
   HABITAT_HOME=${CODEX_TEST_HOME}/.habitat \
   bash ${ROOT_DIR}/scripts/verify_codex_install.sh"

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "Results: ${pass} passed, ${fail} failed"
if [ "${fail}" -ne 0 ]; then
  exit 1
fi
echo "All smoke tests passed."
