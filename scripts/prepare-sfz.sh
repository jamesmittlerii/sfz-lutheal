#!/usr/bin/env bash
# Rewrite sample paths for /usr/share/sfz/pianos/lutheal/ (ASCII, no accents).
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
src="$(find "${root}" -maxdepth 1 -name '*Combined.sfz' -print -quit)"
out="${root}/packaging/lutheal-cimbalom.sfz"

if [[ -z "${src}" || ! -f "${src}" ]]; then
  echo "ERROR: could not find *Combined.sfz in ${root}" >&2
  exit 1
fi

mkdir -p "${root}/packaging"

sed \
  -e 's|Luthéal Piano - Cimbalom (All Stops) Samples/|samples/attack/|g' \
  -e 's|Luthéal Piano - Release Cimbalom (All Stops) Samples/|samples/release/|g' \
  -e 's|Luthéal Piano - Cimbalom Pedal Noise/|samples/pedal/|g' \
  "${src}" > "${out}"

echo "Wrote ${out}"
