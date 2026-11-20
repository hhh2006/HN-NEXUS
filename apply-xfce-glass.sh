#!/usr/bin/env bash
# Backward-compatible entry point; now applies the complete PRISM X theme.
set -Eeuo pipefail
HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/apply-prism-theme.sh" "$@"
