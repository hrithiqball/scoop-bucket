#!/usr/bin/env bash
set -euo pipefail

REPO="hrithiqball/tridennote-tui"
MANIFEST="bucket/tridennote.json"

TAG="${1:-$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')}"
VERSION="${TAG#v}"
BASE="https://github.com/${REPO}/releases/download/${TAG}"
CHECKSUMS="$(curl -fsSL "${BASE}/checksums.txt")"

sha() {
  local value
  value="$(printf '%s\n' "${CHECKSUMS}" | awk -v file="$1" '$2 == file { print $1 }')"
  if [ -z "${value}" ]; then
    echo "No checksum for $1 in ${TAG}" >&2
    exit 1
  fi
  printf '%s' "${value}"
}

cat > "${MANIFEST}" <<JSON
{
    "version": "${VERSION}",
    "description": "Notes, next level, in your terminal",
    "homepage": "https://github.com/${REPO}",
    "license": "MIT",
    "architecture": {
        "64bit": {
            "url": "${BASE}/tridennote_windows_amd64.zip",
            "hash": "$(sha tridennote_windows_amd64.zip)"
        },
        "arm64": {
            "url": "${BASE}/tridennote_windows_arm64.zip",
            "hash": "$(sha tridennote_windows_arm64.zip)"
        }
    },
    "bin": "tridennote.exe",
    "checkver": {
        "github": "https://github.com/${REPO}"
    },
    "autoupdate": {
        "architecture": {
            "64bit": {
                "url": "https://github.com/${REPO}/releases/download/v\$version/tridennote_windows_amd64.zip"
            },
            "arm64": {
                "url": "https://github.com/${REPO}/releases/download/v\$version/tridennote_windows_arm64.zip"
            }
        },
        "hash": {
            "url": "\$baseurl/checksums.txt"
        }
    }
}
JSON

echo "Wrote ${MANIFEST} for ${TAG}"
