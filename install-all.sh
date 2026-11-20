#!/usr/bin/env bash
# Friendly one-command entry point; setup handles detection, backups and confirmation.
set -Eeuo pipefail
HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/setup.sh" "$@"
