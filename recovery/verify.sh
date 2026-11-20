#!/usr/bin/env bash
set -u
ROOT="$HOME/HN-NEXUS"
failed=0
for f in "$ROOT/CORE/CONFIG/hn-sovereign.zsh" "$ROOT/CORE/CONFIG/hn-terminal.zsh" "$ROOT/CORE/CONFIG/hn-tools.zsh" "$HOME/.zshrc"; do
  if command -v zsh >/dev/null && zsh -n "$f"; then echo "[PASS] $f"; else echo "[FAIL or unavailable] $f"; failed=1; fi
done
exit "$failed"
