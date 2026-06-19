#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <upstream-version> [debian-revision]" >&2
  exit 1
fi

root="$(cd "$(dirname "$0")/.." && pwd)"
upstream="$1"
changelog="${root}/debian/changelog"
maintainer="${DEBFULLNAME:-James Mittler} <${DEBEMAIL:-jamesmittlerii@my.smccd.edu}>"
date="$(date -R)"

if [[ $# -ge 2 && -n "${2}" ]]; then
  full_version="${upstream}-${2}"
else
  full_version="${upstream}"
fi

tmp="$(mktemp)"
{
  cat <<EOF
sfz-lutheal (${full_version}) bookworm; urgency=medium

  * Release ${upstream}.

 -- ${maintainer}  ${date}

EOF
  cat "${changelog}" 2>/dev/null || true
} > "${tmp}"
mv "${tmp}" "${changelog}"
