#!/usr/bin/env bash
set -Eeuo pipefail
ACTION="${1:-status}"
command -v xfconf-query >/dev/null 2>&1 || { echo '[BLOCKED] Run inside XFCE.'; exit 2; }
BASE="$HOME/HN-NEXUS/BACKUPS/PRISM-PERFORMANCE"
latest_backup(){ find "$BASE" -mindepth 1 -maxdepth 1 -type d -name 'profile-*' -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n1 | cut -d' ' -f2-; }
case "$ACTION" in
apply)
  stamp="$(date +%Y%m%d-%H%M%S)"; B="$BASE/profile-$stamp"; mkdir -p "$B" "$HOME/.config/autostart"
  xfconf-query -c xfwm4 -p /general/use_compositing 2>/dev/null > "$B/xfwm.before" || echo true > "$B/xfwm.before"
  if [[ -e "$HOME/.config/autostart/picom.desktop" ]]; then cp -a "$HOME/.config/autostart/picom.desktop" "$B/picom.desktop.before"; echo 1 > "$B/autostart-existed"; else echo 0 > "$B/autostart-existed"; fi
  cat > "$HOME/.config/autostart/picom.desktop" <<'DESKTOP'
[Desktop Entry]
Type=Application
Name=Picom disabled by HN PRISM Performance Profile
Hidden=true
DESKTOP
  pkill -x picom 2>/dev/null || true
  xfconf-query -c xfwm4 -p /general/use_compositing -t bool -s true 2>/dev/null || xfconf-query -c xfwm4 -p /general/use_compositing --create -t bool -s true
  cat > "$B/restore.sh" <<'RESTORE'
#!/usr/bin/env bash
set -Eeuo pipefail
B="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$(cat "$B/autostart-existed")" == 1 ]]; then cp -a "$B/picom.desktop.before" "$HOME/.config/autostart/picom.desktop"; else rm -f "$HOME/.config/autostart/picom.desktop"; fi
OLD="$(cat "$B/xfwm.before")"
xfconf-query -c xfwm4 -p /general/use_compositing -t bool -s "$OLD" 2>/dev/null || true
echo '[RESTORED] Previous XFWM compositor setting and Picom autostart entry.'
RESTORE
  chmod 700 "$B/restore.sh"
  echo '[APPLIED] Picom stopped and masked; XFWM compositor enabled.'; echo "[BACKUP] $B"; echo "[RESTORE] $B/restore.sh";;
status)
  echo '--- Picom ---'; pgrep -a -x picom || echo STOPPED
  echo '--- XFWM compositor ---'; xfconf-query -c xfwm4 -p /general/use_compositing 2>/dev/null || echo unknown
  echo '--- user Picom autostart override ---'; [[ -f "$HOME/.config/autostart/picom.desktop" ]] && grep -E '^(Name|Hidden)=' "$HOME/.config/autostart/picom.desktop" || echo none;;
restore)
  B="$(latest_backup)"; [[ -n "$B" && -x "$B/restore.sh" ]] || { echo '[BLOCKED] No profile backup found.'; exit 3; }; exec "$B/restore.sh";;
*) echo "Usage: $0 {apply|status|restore}" >&2; exit 2;;
esac
