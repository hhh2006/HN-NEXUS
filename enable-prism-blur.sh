#!/usr/bin/env bash
# Optional X11 Picom blur. Deliberately opt-in: VMware/llvmpipe may render slowly.
set -Eeuo pipefail
command -v picom >/dev/null || { echo '[BLOCKED] picom is not installed; no packages were installed.'; exit 2; }
if command -v glxinfo >/dev/null 2>&1 && glxinfo -B 2>/dev/null | grep -Eqi 'llvmpipe|softpipe|Software Rasterizer'; then
  [[ "${HN_ALLOW_SLOW_BLUR:-0}" == 1 ]] || { echo '[BLOCKED] llvmpipe software rendering detected; refusing blur to protect VMware performance.'; exit 5; }
fi
command -v xfconf-query >/dev/null || { echo '[BLOCKED] xfconf-query not found.'; exit 2; }
[[ -n "${DISPLAY:-}" && "${XDG_SESSION_TYPE:-x11}" != wayland ]] || { echo '[BLOCKED] Requires an X11 session.'; exit 2; }
if pgrep -x picom >/dev/null 2>&1; then echo '[SAFE STOP] Picom is already running. Existing compositor was not modified.'; exit 0; fi
STAMP="$(date +%Y%m%d-%H%M%S)"; B="$HOME/HN-NEXUS/BACKUPS/PRISM-COMPOSITOR-$STAMP"; C="$HOME/.config/picom/prism-x.conf"
mkdir -p "$B" "$(dirname "$C")"
if [[ -e "$C" ]]; then cp -a "$C" "$B/prism-x.conf.before"; echo 1 > "$B/config-existed"; else echo 0 > "$B/config-existed"; fi
OLD="$(xfconf-query -c xfwm4 -p /general/use_compositing 2>/dev/null || echo true)"; printf '%s\n' "$OLD" > "$B/xfwm-compositing.before"
cat > "$C" <<'PICOM'
# HN//CIT PRISM X — restrained blur profile for X11 (opt-in)
backend = "xrender";
vsync = false;
shadow = true;
shadow-radius = 6;
shadow-opacity = 0.28;
shadow-offset-x = -6;
shadow-offset-y = -6;
fading = false;
fade-in-step = 0.035;
fade-out-step = 0.035;
active-opacity = 0.97;
inactive-opacity = 0.94;
frame-opacity = 0.96;
blur-method = "none";
blur-strength = 0;
blur-background = false;
blur-background-frame = false;
blur-background-fixed = false;
blur-background-exclude = [
  "window_type = 'dock'",
  "window_type = 'desktop'"
];
PICOM
# Only transfer compositor ownership after config has passed Picom's parser.
if ! picom --config "$C" --diagnostics >/dev/null 2>&1; then
  echo '[BLOCKED] Picom rejected the configuration. XFWM compositor remains unchanged.' >&2
  if [[ "$(cat "$B/config-existed")" == 1 ]]; then
    cp -a "$B/prism-x.conf.before" "$C"
  else
    rm -f "$C"
  fi
  exit 3
fi
xfconf-query -c xfwm4 -p /general/use_compositing -t bool -s false 2>/dev/null || xfconf-query -c xfwm4 -p /general/use_compositing --create -t bool -s false
if ! picom --config "$C" --daemon; then
  xfconf-query -c xfwm4 -p /general/use_compositing -t bool -s "$OLD" 2>/dev/null || true
  if [[ "$(cat "$B/config-existed")" == 1 ]]; then
    cp -a "$B/prism-x.conf.before" "$C"
  else
    rm -f "$C"
  fi
  echo '[ERROR] Picom did not start; previous XFWM compositor state restored.' >&2; exit 4
fi
PID="$(pgrep -n -x picom || true)"; printf '%s\n' "$PID" > "$B/picom.pid"
cat > "$B/restore.sh" <<RESTORE
#!/usr/bin/env bash
set -Eeuo pipefail
PID='$PID'; OLD='$OLD'; CFG='$C'
if [[ -n "\$PID" ]] && kill -0 "\$PID" 2>/dev/null; then kill "\$PID"; fi
xfconf-query -c xfwm4 -p /general/use_compositing -t bool -s "\$OLD" 2>/dev/null || true
if [[ "\$(cat '$B/config-existed')" == 1 ]]; then cp -a '$B/prism-x.conf.before' "\$CFG"; else rm -f "\$CFG"; fi
echo '[RESTORED] Previous compositor ownership and Picom config.'
RESTORE
chmod 700 "$B/restore.sh"
echo '[ACTIVE] Low-cost Picom compositor started; blur disabled by default.'
echo "[BACKUP] $B"; echo "[RESTORE] $B/restore.sh"
echo '[VMWARE] If animations stutter, immediately run the restore script.'
