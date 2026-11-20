#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
for test in static-check.sh color-output-check.sh theme-check.sh prompt-geometry-check.sh installer-rollback-check.sh prism-theme-rollback-check.sh intelligence-check.sh; do
  printf '\n===== %s =====\n' "$test"
  bash "$ROOT/tests/$test"
done
if command -v python3 >/dev/null 2>&1; then
  printf '\n===== website-check.py =====\n'
  python3 "$ROOT/tests/website-check.py"
fi
if command -v zsh >/dev/null 2>&1; then
  for f in "$ROOT/config/hn-sovereign.zsh" "$ROOT/config/hn-terminal.zsh" "$ROOT/config/hn-tools.zsh"; do zsh -n "$f"; done
  echo '[PASS] ZSH parser'
  zsh -f -i "$ROOT/tests/prompt-runtime-check.zsh" "$ROOT"
else
  echo '[SKIP] ZSH parser unavailable in this environment'
fi
