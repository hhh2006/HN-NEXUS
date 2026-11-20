#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$HOME/HN-NEXUS"
if [[ -f "$HOME/.zshrc" ]] && grep -q 'HN-HEXUS' "$HOME/.zshrc" && ! grep -q 'HN-NEXUS' "$HOME/.zshrc"; then ROOT="$HOME/HN-HEXUS"; fi
RECOVERY="$ROOT/RECOVERY"
latest_core="$(find "$RECOVERY" -maxdepth 1 -type f -name 'rollback-prism-x-*.sh' -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n1 | cut -d' ' -f2-)"
latest_visual="$(find "$ROOT/BACKUPS" -maxdepth 2 -type f -path '*/restore.sh' -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n1 | cut -d' ' -f2-)"
if [[ -z "$latest_core" && -z "$latest_visual" ]]; then echo '[INFO] No HN recovery scripts found.'; exit 1; fi
printf 'This detaches HN from .zshrc and restores saved HN config/desktop settings. Continue? [y/N] '
read -r answer
[[ "$answer" =~ ^[Yy]$ ]] || { echo '[CANCELLED]'; exit 0; }
if [[ -n "$latest_visual" && -x "$latest_visual" ]]; then
  echo "[RESTORE] Desktop: $latest_visual"
  "$latest_visual"
else echo '[INFO] No visual-theme restore script found; desktop settings were not changed by this recovery.'; fi
if [[ -n "$latest_core" && -x "$latest_core" ]]; then
  echo "[ROLLBACK] Core: $latest_core"
  "$latest_core"
else echo '[INFO] No core rollback script found.'; fi
echo '[DONE] Recovery actions completed where matching backups existed.'
echo '[NOTE] User files and shell history are not intentionally deleted. Review ~/HN-NEXUS/BACKUPS before manually removing anything.'
