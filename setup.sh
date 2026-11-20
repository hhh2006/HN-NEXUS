#!/usr/bin/env bash
# HN NEXUS one-command installer: core plus supported XFCE visual suite.
set -Eeuo pipefail
HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MODE="guided"; DRY_RUN=0
usage(){ cat <<'USAGE'
HN NEXUS setup
  ./setup.sh                 Guided one-command install (core + XFCE visuals when supported)
  ./setup.sh --check         Check prerequisites without changing files
  ./setup.sh --dry-run       Preview the selected installation
  ./setup.sh --core          Install terminal core only
  ./setup.sh --visual        Apply optional XFCE/GTK visual theme (after core)
  ./setup.sh --full          Same guided full installation
  ./setup.sh --help          Show this help

No sudo is required. On XFCE/X11, one confirmation applies desktop styling after backup.
USAGE
}
for arg in "$@"; do case "$arg" in
  --core) MODE=core;; --visual) MODE=visual;; --full) MODE=full;;
  --check) MODE=check;; --dry-run) DRY_RUN=1;; --help|-h) usage; exit 0;;
  *) echo "Unknown option: $arg" >&2; usage >&2; exit 2;; esac; done
ok=0; warn=0
check(){ local label="$1" result="$2"; if [[ "$result" == yes ]]; then printf '[PASS] %s\n' "$label"; ((ok+=1)); else printf '[WARN] %s\n' "$label"; ((warn+=1)); fi; }
command -v zsh >/dev/null 2>&1 && zshbin=yes || zshbin=no
check 'ZSH is installed' "$zshbin"
command -v python3 >/dev/null 2>&1 && py=yes || py=no
check 'Python 3 is installed (installer safety checks)' "$py"
if [[ "$MODE" == visual || "$MODE" == full || "$MODE" == guided ]]; then
  command -v xfconf-query >/dev/null 2>&1 && xf=yes || xf=no
  command -v xfce4-terminal >/dev/null 2>&1 && term=yes || term=no
  [[ -n "${DISPLAY:-}" ]] && display=yes || display=no
  check 'XFCE configuration service (xfconf-query)' "$xf"
  check 'XFCE Terminal' "$term"
  check 'Active X11 display' "$display"
  if [[ "$MODE" == visual && "$xf$term$display" != yesyesyes ]]; then
    echo '[BLOCKED] --visual requires all three XFCE/X11 checks. No project changes were made.' >&2
    exit 2
  fi
fi
printf '\n[PLAN] mode=%s home=%s\n' "$MODE" "$HOME"
if [[ "$MODE" == check ]]; then [[ "$zshbin$py" == yesyes ]]; exit $?; fi
if [[ "$zshbin$py" != yesyes ]]; then echo '[BLOCKED] Install ZSH and Python 3, then rerun. No project changes were made.' >&2; exit 2; fi
if (( DRY_RUN )); then
  echo '[DRY-RUN] No files were changed.'
  echo '[DRY-RUN] Core: backup .zshrc and existing HN config, install ZSH configuration, create verify/rollback scripts.'
  if [[ "$MODE" == visual || "$MODE" == full || "$MODE" == guided ]]; then
    if [[ "$xf$term$display" == yesyesyes ]]; then echo '[DRY-RUN] Visual: back up XFCE theme/GTK settings, then apply HN-Prism-X.'; else echo '[DRY-RUN] Visual: skipped; XFCE/X11 requirements are not all available.'; fi
  fi
  exit 0
fi
if [[ "$MODE" == visual ]]; then
  echo '[INFO] Applying desktop styling only. Existing core installation is not changed.'
  exec "$HERE/apply-prism-theme.sh"
fi

# For the normal guided path, determine desktop support before changing core.
VISUAL_SUPPORTED=0
if [[ "$MODE" == guided || "$MODE" == full ]]; then
  if [[ "${xf:-no}${term:-no}${display:-no}" == yesyesyes && "${XDG_CURRENT_DESKTOP:-}" =~ (XFCE|Xfce) ]]; then
    VISUAL_SUPPORTED=1
  elif [[ "${xf:-no}${term:-no}${display:-no}" == yesyesyes ]]; then
    # xfconf and terminal may exist in a non-XFCE session; don't assume XFWM is active.
    if xfconf-query -c xfwm4 -p /general/theme >/dev/null 2>&1; then VISUAL_SUPPORTED=1; fi
  fi
fi

if (( VISUAL_SUPPORTED )); then
  if [[ -t 0 ]]; then
    printf '\n[CONFIRM] HN NEXUS will also customize XFCE window frames, GTK styling and terminal palette. A restore backup will be created first. Continue? [y/N] '
    read -r answer
    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
      echo '[INFO] Desktop styling declined; installing terminal core only.'
      VISUAL_SUPPORTED=0
    fi
  else
    echo '[INFO] Non-interactive session: desktop styling skipped safely. Run ./setup.sh --visual from an XFCE terminal to apply it.'
    VISUAL_SUPPORTED=0
  fi
else
  if [[ "$MODE" == guided || "$MODE" == full ]]; then
    echo '[INFO] XFCE/X11 visual environment not detected; desktop styling will be skipped. Terminal core will still be installed.'
  fi
fi

"$HERE/install.sh"
if (( VISUAL_SUPPORTED )); then "$HERE/apply-prism-theme.sh"; fi
echo '[SUCCESS] HN NEXUS installation finished.'
echo '[NEXT] Open a new ZSH terminal and run: hnhelp'
if (( VISUAL_SUPPORTED )); then
  echo '[DESKTOP] HN-Prism-X window frames and GTK styling were applied.'
else
  echo '[DESKTOP] No desktop theme changes were made in this session.'
fi
echo '[TIP] To restore, run ./uninstall.sh from this extracted project folder.'
