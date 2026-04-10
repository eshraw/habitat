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
