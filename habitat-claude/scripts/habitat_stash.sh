#!/usr/bin/env bash
set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=hooks/lib.sh
source "${SCRIPTS_DIR}/../hooks/lib.sh"

CABINET_DIR="${HABITAT_DIR}/cabinet"

if [ ! -f "${PLANT_STATE}" ]; then
  echo "Error: No active plant found at ${PLANT_STATE}" >&2
  exit 1
fi

if ! jq -e '.species and .born' "${PLANT_STATE}" >/dev/null 2>&1; then
  echo "Error: Active plant state is invalid" >&2
  exit 1
fi

mkdir -p "${CABINET_DIR}"

species="$(jq -r '.species' "${PLANT_STATE}")"
born_slug="$(jq -r '.born' "${PLANT_STATE}" | tr -d ':-')"

cabinet_file="${CABINET_DIR}/${species}-${born_slug}.json"

# Collision detection: append 4-char hex suffix if filename already exists
if [ -f "${cabinet_file}" ]; then
  hex_suffix="$(printf '%04x' $((RANDOM * RANDOM % 65536)))"
  cabinet_file="${CABINET_DIR}/${species}-${born_slug}-${hex_suffix}.json"
fi

cp "${PLANT_STATE}" "${cabinet_file}"
rm "${PLANT_STATE}"

echo "stashed:$(basename "${cabinet_file}")"
