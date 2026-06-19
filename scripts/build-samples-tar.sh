#!/usr/bin/env bash
# Bundle FLAC samples into an uncompressed tar (FLAC is already compressed).
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
version="$(tr -d '[:space:]' < "${root}/VERSION")"
staging="${root}/build/samples-staging"
out="${root}/dist/sfz-lutheal-samples_${version}_all.tar"

attack_dir="$(find "${root}" -maxdepth 1 -type d -name '*Cimbalom (All Stops) Samples' ! -name '*Release*' -print -quit)"
release_dir="$(find "${root}" -maxdepth 1 -type d -name '*Release Cimbalom (All Stops) Samples' -print -quit)"
pedal_dir="$(find "${root}" -maxdepth 1 -type d -name '*Cimbalom Pedal Noise' -print -quit)"

for label in attack release pedal; do
  case "${label}" in
    attack)  path="${attack_dir}" ;;
    release) path="${release_dir}" ;;
    pedal)   path="${pedal_dir}" ;;
  esac
  if [[ -z "${path}" || ! -d "${path}" ]]; then
    echo "ERROR: missing ${label} sample directory under ${root}" >&2
    exit 1
  fi
done

rm -rf "${staging}"
mkdir -p "${staging}/samples/attack" "${staging}/samples/release" "${staging}/samples/pedal"

cp -a "${attack_dir}/." "${staging}/samples/attack/"
cp -a "${release_dir}/." "${staging}/samples/release/"
cp -a "${pedal_dir}/." "${staging}/samples/pedal/"

mkdir -p "${root}/dist"
tar -cf "${out}" -C "${staging}" samples

attack_n="$(find "${staging}/samples/attack" -name '*.flac' | wc -l)"
release_n="$(find "${staging}/samples/release" -name '*.flac' | wc -l)"
pedal_n="$(find "${staging}/samples/pedal" -name '*.flac' | wc -l)"
size_mb="$(du -m "${out}" | awk '{print $1}')"

echo "Created ${out} (${size_mb} MiB)"
echo "  attack:  ${attack_n} flacs"
echo "  release: ${release_n} flacs"
echo "  pedal:   ${pedal_n} flacs"
