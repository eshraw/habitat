#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail=0

for file in "${ROOT_DIR}"/species/*.json; do
  if ! jq -e '
    .name
    and (.description | type=="string")
    and (.stat_weights | type=="object")
    and (.stage_thresholds | type=="array" and length==5)
    and (.stage_art.seed and .stage_art.sprout and .stage_art.juvenile and .stage_art.mature and .stage_art.ancient)
    and (.rare_variants | type=="object")
    and (.flavor_adjectives | type=="array" and length>0)
  ' "${file}" >/dev/null; then
    echo "invalid species file: ${file}" >&2
    fail=1
  fi
done

if [ "${fail}" -ne 0 ]; then
  exit 1
fi

echo "Species validation passed."
