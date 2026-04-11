#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=hooks/lib.sh
source "${SCRIPT_DIR}/lib.sh"

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

# Bail out if habitat has not been initialized — do not auto-create state.
if [ ! -f "${PLANT_STATE}" ]; then
  exit 0
fi

payload="$(cat)"
ensure_state
state="$(read_state)"
event_name="$(printf "%s" "${payload}" | jq -r '.event // .event_name // "Stop"' 2>/dev/null || echo "Stop")"

if [ "${event_name}" != "Stop" ]; then
  exit 0
fi

updated="$(printf "%s" "${state}" | jq '
  .sessions += 1
  | .stats.health = ((.stats.health - 1) | if . < 0 then 0 else . end)
  | .stats.hydration = ((.stats.hydration - 2) | if . < 0 then 0 else . end)
  | .stats.growth = ((.stats.growth - 1) | if . < 0 then 0 else . end)
  | .dormant = (.stats.health <= 0)
')"

if [ "$(printf "%s" "${updated}" | jq -r '.dormant')" = "true" ]; then
  # Dormancy is recoverable; keep a minimum vitality floor for future recovery.
  updated="$(printf "%s" "${updated}" | jq '.stats.health = 0')"
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
  | .render_hint = {dominant_stat: $dominant, rare_variant: $variant}
  | if .sessions >= 1 and (.milestones | index("first_session") == null) then .milestones += ["first_session"] else . end
  | if .sessions >= 10 and (.milestones | index("habit_builder") == null) then .milestones += ["habit_builder"] else . end
')"

write_state_atomic "${updated}"
