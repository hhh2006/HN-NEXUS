#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
for f in "$ROOT/apply-prism-theme.sh" "$ROOT/apply-xfce-glass.sh" "$ROOT/enable-prism-blur.sh" "$ROOT/install-all.sh"; do bash -n "$f"; echo "[PASS] Bash syntax: ${f##*/}"; done
[[ -s "$ROOT/theme/HN-Prism-X/xfwm4/themerc" ]]
[[ -s "$ROOT/theme/gtk-3.0/gtk.css" ]]
for f in "$ROOT"/theme/HN-Prism-X/xfwm4/*.xpm; do
  grep -q '^/\* XPM \*/' "$f" || { echo "[FAIL] XPM header: $f"; exit 1; }
  grep -q 'static char \*' "$f" || { echo "[FAIL] XPM data: $f"; exit 1; }
done
echo '[PASS] XFWM theme assets and GTK CSS present.'
if command -v zsh >/dev/null 2>&1; then
  for f in "$ROOT"/config/*.zsh; do zsh -n "$f"; echo "[PASS] ZSH syntax: ${f##*/}"; done
else echo '[SKIP] zsh not installed in build environment.'; fi
