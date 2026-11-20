#!/usr/bin/env bash
set -u
echo '=== HN//CIT COMMAND CENTER DIAGNOSTICS ==='
echo '[SESSION]'; printf 'TYPE=%s DISPLAY=%s TERM=%s\n' "${XDG_SESSION_TYPE:-unknown}" "${DISPLAY:-none}" "${TERM:-none}"
echo '[MEMORY]'; free -h 2>/dev/null || true
echo '[LOAD]'; uptime 2>/dev/null || true
echo '[COMPOSITORS]'; pgrep -a -x picom || echo 'picom: stopped'; pgrep -a -x xfwm4 || true
if command -v xfconf-query >/dev/null 2>&1; then printf 'XFWM_COMPOSITING='; xfconf-query -c xfwm4 -p /general/use_compositing 2>/dev/null || echo unknown; fi
echo '[GPU]'; if command -v glxinfo >/dev/null 2>&1; then glxinfo -B 2>/dev/null | grep -E 'direct rendering|OpenGL vendor|OpenGL renderer|OpenGL version' || true; else echo unavailable; fi
echo '[AUTOSTART]'; grep -Ril picom "$HOME/.config/autostart" /etc/xdg/autostart 2>/dev/null | head -20 || true
echo '[ZSH]'; command -v zsh >/dev/null && zsh --version || echo unavailable
