#!/usr/bin/env bash
# Fail if the .deb ships save/ or scripts/ from the source tree.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
shopt -s nullglob
debs=("${root}"/../sfz-lutheal_*.deb "${root}"/dist/sfz-lutheal_*.deb)

if [ ${#debs[@]} -eq 0 ]; then
  echo "ERROR: no sfz-lutheal_*.deb found" >&2
  exit 1
fi

deb="${debs[0]}"
echo "Checking ${deb}"

if dpkg-deb -c "${deb}" | awk '{print $6}' | grep -E '/(save|scripts)(/|$)'; then
  echo "ERROR: save/ or scripts/ found in package contents" >&2
  exit 1
fi

echo "OK: package does not include save/ or scripts/."
