#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=hooks/lib.sh
source "${SCRIPT_DIR}/lib.sh"

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

payload="$(cat)"
ensure_state
state="$(read_state)"
tool_name="$(printf "%s" "${payload}" | jq -r '.tool_name // .toolName // .tool // empty' 2>/dev/null || true)"
event_name="$(printf "%s" "${payload}" | jq -r '.event // .event_name // empty' 2>/dev/null || true)"
success="$(printf "%s" "${payload}" | jq -r '.success // .ok // false' 2>/dev/null || echo "false")"
raw_command="$(printf "%s" "${payload}" | jq -r '.command // .args.command // .input.command // empty' 2>/dev/null || true)"
command_sig="$(printf "%s" "${raw_command}" | awk '{print $1}')"

updated="${state}"

if [ "${event_name}" = "Notification" ] && [ "${success}" = "true" ]; then
  updated="$(printf "%s" "${updated}" | jq '.stats.health = ((.stats.health + 4) | if . > 100 then 100 else . end)')"
fi

if [ "${event_name}" = "PostToolUse" ] || [ -n "${tool_name}" ]; then
  case "${tool_name}" in
    bash_tool|bash)
      updated="$(printf "%s" "${updated}" | jq '.stats.hydration = ((.stats.hydration + 3) | if . > 100 then 100 else . end) | .xp += 2')"
      if [ -n "${command_sig}" ]; then
        seen="$(printf "%s" "${updated}" | jq -r --arg sig "${command_sig}" '.seen_commands | index($sig) | if . == null then "no" else "yes" end')"
        if [ "${seen}" = "no" ]; then
          updated="$(printf "%s" "${updated}" | jq --arg sig "${command_sig}" '.stats.curiosity = ((.stats.curiosity + 3) | if . > 100 then 100 else . end) | .seen_commands += [$sig] | .xp += 3')"
        fi
      fi
      ;;
    str_replace|create_file)
      updated="$(printf "%s" "${updated}" | jq '.stats.growth = ((.stats.growth + 4) | if . > 100 then 100 else . end) | .stats.rootedness = ((.stats.rootedness + 2) | if . > 100 then 100 else . end) | .xp += 5')"
      ;;
    web_search)
      updated="$(printf "%s" "${updated}" | jq '.stats.curiosity = ((.stats.curiosity + 4) | if . > 100 then 100 else . end) | .xp += 3')"
      ;;
  esac
fi

species="$(printf "%s" "${updated}" | jq -r '.species')"
if ! species_has_required_shape "${species}"; then
  species="fern"
  updated="$(printf "%s" "${updated}" | jq --arg species "${species}" '.species = $species')"
fi
thresholds="$(species_thresholds_or_default "${species}")"
xp="$(printf "%s" "${updated}" | jq -r '.xp')"
stage="$(compute_stage "${xp}" "${thresholds}")"
dominant="$(dominant_stat "${updated}")"
variant_hint="$(rare_variant_hint "${species}" "${stage}" "${dominant}")"

updated="$(printf "%s" "${updated}" | jq --arg now "$(now_iso)" --argjson stage "${stage}" --arg dominant "${dominant}" --arg variant "${variant_hint}" '
  .stage = $stage
  | .last_seen = $now
  | .dormant = (.stats.health <= 0)
  | if .dormant == true and .stats.health >= 5 then .dormant = false else . end
  | .render_hint = {dominant_stat: $dominant, rare_variant: $variant}
  | if .stage >= 3 and (.milestones | index("mature_plant") == null) then .milestones += ["mature_plant"] else . end
  | if .stage >= 4 and (.milestones | index("ancient_roots") == null) then .milestones += ["ancient_roots"] else . end
  | if $dominant == "curiosity" and (.milestones | index("curious_mind") == null) then .milestones += ["curious_mind"] else . end
')"

write_state_atomic "${updated}"
