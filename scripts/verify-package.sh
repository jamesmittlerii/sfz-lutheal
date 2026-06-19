#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"

"${root}/scripts/prepare-sfz.sh"
sfz="${root}/packaging/lutheal-cimbalom.sfz"

if grep -E '^sample=.*Luthéal' "${sfz}" || grep -E '<region> sample=.*Luthéal' "${sfz}"; then
  echo "ERROR: packaged SFZ still contains accented sample paths" >&2
  exit 1
fi

for prefix in samples/attack/ samples/release/ samples/pedal/; do
  count="$(grep -c "sample=${prefix}" "${sfz}" || true)"
  if [[ "${count}" -eq 0 ]]; then
    echo "ERROR: no regions reference ${prefix}" >&2
    exit 1
  fi
  echo "OK: ${count} regions -> ${prefix}"
done

attack_dir="$(find "${root}" -maxdepth 1 -type d -name '*Cimbalom (All Stops) Samples' ! -name '*Release*' -print -quit)"
release_dir="$(find "${root}" -maxdepth 1 -type d -name '*Release Cimbalom (All Stops) Samples' -print -quit)"
pedal_dir="$(find "${root}" -maxdepth 1 -type d -name '*Cimbalom Pedal Noise' -print -quit)"

attack_src="$(find "${attack_dir}" -name '*.flac' | wc -l)"
release_src="$(find "${release_dir}" -name '*.flac' | wc -l)"
pedal_src="$(find "${pedal_dir}" -name '*.flac' | wc -l)"

attack_ref="$(grep -c 'sample=samples/attack/' "${sfz}")"
release_ref="$(grep -c 'sample=samples/release/' "${sfz}")"
pedal_ref="$(grep -c 'sample=samples/pedal/' "${sfz}")"

[[ "${attack_ref}" -eq "${attack_src}" ]] || { echo "ERROR: attack count mismatch sfz=${attack_ref} disk=${attack_src}" >&2; exit 1; }
[[ "${pedal_ref}" -eq "${pedal_src}" ]] || { echo "ERROR: pedal count mismatch sfz=${pedal_ref} disk=${pedal_src}" >&2; exit 1; }
[[ "${release_ref}" -le "${release_src}" ]] || { echo "ERROR: release sfz refs (${release_ref}) exceed disk files (${release_src})" >&2; exit 1; }

while IFS= read -r sample_path; do
  base="$(basename "${sample_path}")"
  if [[ ! -f "${release_dir}/${base}" ]]; then
    echo "ERROR: missing release sample ${base}" >&2
    exit 1
  fi
done < <(grep -oE 'sample=samples/release/[^[:space:]]+' "${sfz}" | sed 's/^sample=//')

echo "Release: ${release_ref} regions reference existing samples (${release_src} on disk)."

echo "All sample references verified."
