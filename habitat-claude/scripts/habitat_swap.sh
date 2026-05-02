#!/usr/bin/env bash
set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=hooks/lib.sh
source "${SCRIPTS_DIR}/../hooks/lib.sh"

CABINET_DIR="${HABITAT_DIR}/cabinet"

if [ $# -lt 1 ]; then
  echo "Usage: habitat_swap.sh <cabinet-filename>" >&2
  exit 1
fi

cabinet_arg="$1"

# Accept either a bare filename or a full path
if [[ "${cabinet_arg}" == /* ]]; then
  cabinet_file="${cabinet_arg}"
else
  cabinet_file="${CABINET_DIR}/${cabinet_arg}"
fi

if [ ! -f "${cabinet_file}" ]; then
  echo "Error: Cabinet file not found: ${cabinet_file}" >&2
  exit 1
fi

mkdir -p "${CABINET_DIR}"

# Stash the current active plant first (if one exists)
if [ -f "${PLANT_STATE}" ]; then
  bash "${SCRIPTS_DIR}/habitat_stash.sh"
fi

# Write-then-delete: write new active plant before removing from cabinet
cp "${cabinet_file}" "${PLANT_STATE}"
rm "${cabinet_file}"

species="$(jq -r '.species' "${PLANT_STATE}")"
echo "swapped:${species}"
