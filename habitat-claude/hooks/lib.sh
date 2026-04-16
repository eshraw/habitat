#!/usr/bin/env bash
set -euo pipefail

HABITAT_DIR="${HABITAT_HOME:-${HOME}/.habitat}"
PLANT_STATE="${HABITAT_DIR}/plant.json"
STATE_LOCK="${HABITAT_DIR}/.lock"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPECIES_DIR="${SCRIPT_DIR}/../species"

now_iso() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

default_state_for_species() {
  local species="$1"
  local ts
  ts="$(now_iso)"
  jq -n --arg species "${species}" --arg ts "${ts}" '{
    species: $species,
    stage: 0,
    name: null,
    dormant: false,
    born: $ts,
    last_seen: $ts,
    stats: {
      health: 80,
      growth: 45,
      hydration: 60,
      curiosity: 70,
      rootedness: 55
    },
    xp: 0,
    sessions: 0,
    seen_commands: [],
    milestones: [],
    display_active: false
  }'
}

random_species() {
  local choices=""
  local f
  for f in "${SPECIES_DIR}"/*.json; do
    [ -e "${f}" ] || continue
    choices="${choices}$(basename "${f}" .json)"$'\n'
  done
  if [ -z "${choices}" ]; then
    echo "fern"
    return
  fi
  printf "%s\n" "${choices}" | awk 'BEGIN{srand()} {a[NR]=$0} END{print a[int(rand()*NR)+1]}'
}

ensure_state() {
  mkdir -p "${HABITAT_DIR}"
  if [ ! -f "${PLANT_STATE}" ]; then
    local species
    species="$(random_species)"
    default_state_for_species "${species}" > "${PLANT_STATE}"
  fi
}

read_state() {
  ensure_state
  jq '.' "${PLANT_STATE}"
}

write_state_atomic() {
  local input_json="$1"
  local tmp_file
  tmp_file="${PLANT_STATE}.tmp.$$"
  printf "%s" "${input_json}" > "${tmp_file}"
  mv "${tmp_file}" "${PLANT_STATE}"
}

clamp_stat() {
  local value="$1"
  if [ "${value}" -lt 0 ]; then
    echo 0
  elif [ "${value}" -gt 100 ]; then
    echo 100
  else
    echo "${value}"
  fi
}

species_file() {
  local species="$1"
  echo "${SPECIES_DIR}/${species}.json"
}

species_xp_rate_or_default() {
  local species="$1"
  local file
  file="$(species_file "${species}")"
  if [ ! -f "${file}" ]; then
    echo "1.0"
    return
  fi
  local rate
  rate="$(jq -r 'if (.xp_rate | type) == "number" and .xp_rate > 0 then .xp_rate else 1.0 end' "${file}" 2>/dev/null || echo "1.0")"
  # clamp to [0.1, 2.0]
  jq -nr --argjson r "${rate}" '[$r, 0.1] | max | [., 2.0] | min'
}

species_thresholds_or_default() {
  local species="$1"
  local file
  file="$(species_file "${species}")"
  if [ ! -f "${file}" ]; then
    echo "[0,120,300,650,1200]"
    return
  fi
  if ! jq -e '.stage_thresholds | type=="array" and length==5' "${file}" >/dev/null 2>&1; then
    echo "[0,120,300,650,1200]"
    return
  fi
  jq -c '.stage_thresholds' "${file}"
}

species_has_required_shape() {
  local species="$1"
  local file
  file="$(species_file "${species}")"
  jq -e '
    .name
    and (.stat_weights | type=="object")
    and (.stage_thresholds | type=="array" and length==5)
    and (.stage_art.seed and .stage_art.sprout and .stage_art.juvenile and .stage_art.mature and .stage_art.ancient)
    and (.rare_variants | type=="object")
    and (.flavor_adjectives | type=="array")
  ' "${file}" >/dev/null 2>&1
}

compute_stage() {
  local xp="$1"
  local thresholds="$2"
  jq -nr --argjson xp "${xp}" --argjson t "${thresholds}" '
    if $xp >= $t[4] then 4
    elif $xp >= $t[3] then 3
    elif $xp >= $t[2] then 2
    elif $xp >= $t[1] then 1
    else 0 end
  '
}

dominant_stat() {
  local state_json="$1"
  printf "%s" "${state_json}" | jq -r '
    .stats
    | to_entries
    | sort_by(.value)
    | reverse
    | .[0].key
  '
}

rare_variant_hint() {
  local species="$1"
  local stage="$2"
  local dominant="$3"
  local file
  file="$(species_file "${species}")"
  if [ ! -f "${file}" ]; then
    echo ""
    return
  fi
  local stage_key=""
  if [ "${stage}" -eq 3 ]; then
    stage_key="mature"
  elif [ "${stage}" -ge 4 ]; then
    stage_key="ancient"
  fi
  if [ -z "${stage_key}" ]; then
    echo ""
    return
  fi
  jq -r --arg stage "${stage_key}" --arg dom "${dominant}" '
    .rare_variants[$stage][$dom] // ""
  ' "${file}" 2>/dev/null || echo ""
}
