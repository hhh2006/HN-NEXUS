#!/usr/bin/env bash
set -Eeuo pipefail

# Assert that grep finds no match; propagate grep I/O/usage errors instead of
# treating every non-zero status as a successful absence check.
assert_absent() {
  local rc
  if grep "$@"; then
    echo "[FAIL] Unexpected forbidden pattern found: $*" >&2
    return 1
  else
    rc=$?
    [[ "$rc" -eq 1 ]] || return "$rc"
  fi
}
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
for f in setup.sh install.sh uninstall.sh install-all.sh apply-prism-theme.sh apply-xfce-glass.sh enable-prism-blur.sh prism-performance.sh diagnostics.sh recovery/verify.sh; do bash -n "$ROOT/$f"; done
grep -q '_hn_hud_top' "$ROOT/config/hn-terminal.zsh"
grep -q '_hn_hud_info' "$ROOT/config/hn-terminal.zsh"
grep -q '╰─' "$ROOT/config/hn-terminal.zsh"
grep -q 'vcs_info' "$ROOT/config/hn-terminal.zsh"
grep -q 'VIRTUAL_ENV' "$ROOT/config/hn-terminal.zsh"
grep -q 'SSH_CONNECTION' "$ROOT/config/hn-terminal.zsh"
grep -q 'pyproject.toml' "$ROOT/config/hn-terminal.zsh"
grep -q "alias l=" "$ROOT/config/hn-tools.zsh"
grep -q "alias ll=" "$ROOT/config/hn-tools.zsh"
grep -q 'hnprism()' "$ROOT/config/hn-tools.zsh"
grep -q 'hnicons()' "$ROOT/config/hn-tools.zsh"
assert_absent -Eq 'alias[[:space:]]+ls=' "$ROOT/config/hn-tools.zsh"
assert_absent -Eq '(^|[[:space:]])(rm|truncate|tee)[[:space:]].*\.zsh_history|(^|[[:space:]])(:|>|>>)[[:space:]]*[^#]*\.zsh_history' "$ROOT/install.sh"
assert_absent -q 'apt install\|apt-get install' "$ROOT/enable-prism-blur.sh"
grep -q 'apply-prism-theme.sh' "$ROOT/apply-xfce-glass.sh"
grep -q 'xfce4-terminal' "$ROOT/apply-prism-theme.sh"
grep -q 'no packages were installed' "$ROOT/enable-prism-blur.sh"
grep -q 'llvmpipe' "$ROOT/enable-prism-blur.sh"
grep -q 'check-for-changes.*HN_GIT_DIRTY' "$ROOT/config/hn-terminal.zsh"
grep -q 'setup.sh' "$ROOT/install-all.sh"
grep -q 'MODE="guided"' "$ROOT/setup.sh"
grep -q 'HN-Prism-X window frames' "$ROOT/setup.sh"
grep -q 'XFCE/X11 visual environment not detected' "$ROOT/setup.sh"
grep -q 'INSTALLATION-AND-RECOVERY' "$ROOT/README.md"
echo '[PASS] Bash syntax and static safety checks'
grep -q 'hnops()' "$ROOT/config/hn-tools.zsh"
grep -q 'hnports()' "$ROOT/config/hn-tools.zsh"
grep -q 'hnproc()' "$ROOT/config/hn-tools.zsh"
grep -q 'hninspect()' "$ROOT/config/hn-tools.zsh"
grep -q 'hndiff()' "$ROOT/config/hn-tools.zsh"
assert_absent -Eq 'alias[[:space:]]+(ps|ss|diff|file)=' "$ROOT/config/hn-tools.zsh"
echo '[PASS] PRISM X 2.6 operator utilities are present'

grep -q 'hnfiles()' "$ROOT/config/hn-tools.zsh"
grep -q 'hnicon()' "$ROOT/config/hn-tools.zsh"
grep -q 'hidden files included' "$ROOT/config/hn-tools.zsh"
assert_absent -Eq 'alias[[:space:]]+(ls|find|tree)=' "$ROOT/config/hn-tools.zsh"
echo '[PASS] PRISM X 2.7 semantic file intelligence is present'

grep -q 'hnoutput()' "$ROOT/config/hn-tools.zsh"
grep -q 'COMMAND CENTER OUTPUT TRIAGE' "$ROOT/config/hn-tools.zsh"
grep -q 'No piped input' "$ROOT/config/hn-tools.zsh"
assert_absent -Eq 'alias[[:space:]]+(cat|grep|awk|tail|less)=' "$ROOT/config/hn-tools.zsh"
echo '[PASS] PRISM X 2.8 smart output triage is present'

grep -q 'hnnet()' "$ROOT/config/hn-tools.zsh"
grep -q 'COMMAND CENTER NETWORK INTELLIGENCE' "$ROOT/config/hn-tools.zsh"
grep -q 'No piped input' "$ROOT/config/hn-tools.zsh"
assert_absent -Eq 'alias[[:space:]]+(ip|ss|nmap|tcpdump|wireshark)=' "$ROOT/config/hn-tools.zsh"
echo '[PASS] PRISM X 2.9 passive network output intelligence is present'

grep -q 'hnanalyze()' "$ROOT/config/hn-tools.zsh"
grep -q 'HN//CIT COMMAND CENTER · OPERATOR INTELLIGENCE' "$ROOT/config/hn-tools.zsh"
assert_absent -Eq 'alias[[:space:]]+(nmap|tshark|ssh|tcpdump)=' "$ROOT/config/hn-tools.zsh"
echo '[PASS] PRISM X 3.0 operator intelligence is present'

grep -q 'HN_KALI_ICON=.*uf327' "$ROOT/config/hn-terminal.zsh"
grep -q 'JetBrainsMono Nerd Font' "$ROOT/config/hn-terminal.zsh"
grep -q 'hnvisual()' "$ROOT/config/hn-tools.zsh"
grep -q 'COMMAND CENTER VISUAL ASSET DIAGNOSTICS' "$ROOT/config/hn-tools.zsh"
echo '[PASS] PRISM visual identity and Kali dragon glyph checks'

grep -q 'hnmenu()' "$ROOT/config/hn-tools.zsh"
grep -q 'hnvisual()' "$ROOT/config/hn-tools.zsh"
echo '[PASS] PRISM X 3.0.4 interactive HUD and diagnostics are present'

grep -q 'hnipa()' "$ROOT/config/hn-tools.zsh"
grep -q 'NETWORK INTERFACES / ADDRESS MATRIX' "$ROOT/config/hn-tools.zsh"
grep -q 'hncat()' "$ROOT/config/hn-tools.zsh"
grep -q 'numbered fallback view' "$ROOT/config/hn-tools.zsh"
assert_absent -Eq 'alias[[:space:]]+(cat|ip)=' "$ROOT/config/hn-tools.zsh"
echo '[PASS] PRISM X 3.0.5 structured CAT and IP address output'


grep -q '^cat()' "$ROOT/config/hn-tools.zsh"
# shellcheck disable=SC2016 # Match literal shell source; expansion is not intended.
grep -q 'command cat "\$@"' "$ROOT/config/hn-tools.zsh"
grep -q '^ip()' "$ROOT/config/hn-tools.zsh"
# shellcheck disable=SC2016 # Match literal shell source; expansion is not intended.
grep -q 'command ip "\$@"' "$ROOT/config/hn-tools.zsh"
grep -q 'NETWORK INTERFACE MATRIX' "$ROOT/config/hn-tools.zsh"
grep -q 'batcat --color=always' "$ROOT/config/hn-tools.zsh"
echo '[PASS] PRISM X 3.1.0 native cat/ip presentation and fallback checks'


grep -q '^ps()' "$ROOT/config/hn-tools.zsh"
grep -q '^df()' "$ROOT/config/hn-tools.zsh"
grep -q '^free()' "$ROOT/config/hn-tools.zsh"
grep -q '^ss()' "$ROOT/config/hn-tools.zsh"
grep -q '_prism_color_stream' "$ROOT/config/hn-tools.zsh"
grep -q 'pipestatus\[1\]' "$ROOT/config/hn-tools.zsh"
echo '[PASS] PRISM X 3.2.0 native system command color layer'

grep -q '^du()' "$ROOT/config/hn-tools.zsh"
grep -q 'mode!="du"' "$ROOT/config/hn-tools.zsh"
grep -q 'MANPAGER' "$ROOT/config/hn-tools.zsh"
grep -q 'SYSTEMD_COLORS' "$ROOT/config/hn-tools.zsh"
grep -q 'COMMAND CENTER VIEW' "$ROOT/config/hn-tools.zsh"
echo '[PASS] PRISM X 3.3.0 structured native system output and pager defaults'


grep -q '^hnreport()' "$ROOT/config/hn-tools.zsh"
grep -q '^hnyaml()' "$ROOT/config/hn-tools.zsh"
grep -q '^ls()' "$ROOT/config/hn-tools.zsh"
grep -q '^tree()' "$ROOT/config/hn-tools.zsh"
grep -q 'LOG SUMMARY' "$ROOT/config/hn-tools.zsh"
grep -q 'Review it before sharing' "$ROOT/config/hn-tools.zsh"
echo '[PASS] PRISM X 3.4.0 file, log, directory and report intelligence'
grep -q '9%f  System report' "$ROOT/config/hn-tools.zsh"
grep -q '10) print -Pn' "$ROOT/config/hn-tools.zsh"


grep -q '^hnsearch()' "$ROOT/config/hn-tools.zsh"
grep -q '^hnhistory()' "$ROOT/config/hn-tools.zsh"
grep -q 'builtin fc -l -n' "$ROOT/config/hn-tools.zsh"
grep -q 'COMMAND DISCOVERY / CATALOGUE' "$ROOT/config/hn-tools.zsh"
grep -q '11) print -Pn' "$ROOT/config/hn-tools.zsh"
grep -q '12) hnhistory 30' "$ROOT/config/hn-tools.zsh"
grep -q 'matcher-list' "$ROOT/config/hn-tools.zsh"
echo '[PASS] PRISM X 3.5.0 command discovery, history viewer and completion styling'
assert_absent -Eq 'history[[:space:]]+-c|fc[[:space:]].*-p|>[[:space:]]*.*\.zsh_history' "$ROOT/config/hn-tools.zsh"
echo '[PASS] PRISM history helper does not clear or rewrite shell history'


grep -q '^_prism_ip_route_view()' "$ROOT/config/hn-tools.zsh"
grep -q '^_prism_ip_neigh_view()' "$ROOT/config/hn-tools.zsh"
grep -q 'ROUTING TABLE / PATH MATRIX' "$ROOT/config/hn-tools.zsh"
grep -q 'NEIGHBOR / ARP CACHE MATRIX' "$ROOT/config/hn-tools.zsh"
# shellcheck disable=SC2016 # Match literal shell source; expansion is not intended.
grep -q 'command ip "\$@"' "$ROOT/config/hn-tools.zsh"
echo '[PASS] PRISM X 3.6.0 route and neighbor matrix presence / native fallback checks'

# v3.6.x responsive layout behavior remains covered by v3.7.1's revised HUD.
grep -q 'compinit -d' "$ROOT/config/hn-sovereign.zsh"
grep -q '^setopt CORRECT$' "$ROOT/config/hn-sovereign.zsh"
grep -q '^unsetopt CORRECT_ALL$' "$ROOT/config/hn-sovereign.zsh"
echo '[PASS] interactive command correction enabled; argument auto-correction disabled'
[[ "$(grep -c '^_hn_set_title()' "$ROOT/config/hn-terminal.zsh")" -eq 1 ]]
grep -q '_hn_hud_width' "$ROOT/config/hn-terminal.zsh"
echo '[PASS] v3.7.0 completion initialization, single title hook and adaptive HUD width'

grep -q 'path_budget=' "$ROOT/config/hn-terminal.zsh"
grep -q 'abbreviate the path from its left' "$ROOT/config/hn-terminal.zsh"
echo '[PASS] narrow-terminal metadata collapse and responsive info-row accounting'

# v3.7.3 cinematic HUD regression checks
grep -q '_hn_gradient_text' "$ROOT/config/hn-terminal.zsh"
grep -q "_hn_hud_info" "$ROOT/config/hn-terminal.zsh"
grep -q "_hn_hud_bottom" "$ROOT/config/hn-terminal.zsh"
assert_absent -q '_hn_hud_inner_rule' "$ROOT/config/hn-terminal.zsh"
grep -q 'HN//CIT' "$ROOT/config/hn-terminal.zsh"
echo '[PASS] v3.7.3 cinematic gradient HUD and Kali identity'

# v3.7.2/v3.7.3 gradient double-rail and gradient typography checks.
grep -q '_hn_gradient_rail' "$ROOT/config/hn-terminal.zsh"
grep -q '_hn_gradient_text' "$ROOT/config/hn-terminal.zsh"
grep -q 'HN//CIT' "$ROOT/config/hn-terminal.zsh"
assert_absent -q 'KALI LINUX' "$ROOT/config/hn-terminal.zsh"
assert_absent -q 'PRISM X' "$ROOT/config/hn-terminal.zsh"
echo '[PASS] v3.7.3 dual gradient rails, gradient typography and Kali identity'

grep -q 'HN_LAST_COMMAND' "$ROOT/config/hn-terminal.zsh"
grep -q 'strftime -s clock' "$ROOT/config/hn-terminal.zsh"
echo '[PASS] v3.7.4 live command badge and adaptive bracket HUD'

grep -q 'path=' "$ROOT/config/hn-terminal.zsh"
grep -q 'LAST' "$ROOT/config/hn-terminal.zsh"
grep -q 'HN_LAST_DURATION' "$ROOT/config/hn-terminal.zsh"
echo '[PASS] v3.7.5 HUD width accounting and responsive information row'


# v3.8.0 host/runtime intelligence integration and release metadata checks
grep -q '^hnhealth()' "$ROOT/config/hn-tools.zsh"
grep -q '^hnservices()' "$ROOT/config/hn-tools.zsh"
grep -q '^hncontainers()' "$ROOT/config/hn-tools.zsh"
grep -q '13) hnhealth' "$ROOT/config/hn-tools.zsh"
grep -q '14) hnservices' "$ROOT/config/hn-tools.zsh"
grep -q '15) hncontainers' "$ROOT/config/hn-tools.zsh"
grep -q "'hnhealth|" "$ROOT/config/hn-tools.zsh"
grep -q "'hnservices|" "$ROOT/config/hn-tools.zsh"
grep -q "'hncontainers|" "$ROOT/config/hn-tools.zsh"
grep -q 'list-units --type=service --all --no-legend --no-pager' "$ROOT/config/hn-tools.zsh"
grep -q 'ps -a --no-trunc --format' "$ROOT/config/hn-tools.zsh"
assert_absent -Eq 'systemctl[[:space:]]+(start|stop|restart|enable|disable)|docker[[:space:]]+(run|start|stop|rm|rmi)|podman[[:space:]]+(run|start|stop|rm|rmi)' "$ROOT/config/hn-tools.zsh"
[[ "$(cat "$ROOT/VERSION")" == '4.4.2' ]]
grep -q '^unalias ip ls 2>/dev/null || true$' "$ROOT/config/hn-tools.zsh"
grep -q 'Dedicated third row' "$ROOT/config/hn-terminal.zsh"
grep -q '4.4.2' "$ROOT/README.md"
grep -q 'v4.2.2' "$ROOT/docs/CHANGELOG.md"
grep -q 'TERMINAL_BACKGROUND_SOLID' "$ROOT/apply-prism-theme.sh"
grep -q 'padding: 4px 6px' "$ROOT/theme/gtk-3.0/gtk.css"
assert_absent -q "PROMPT=.*❯%f '" "$ROOT/config/hn-terminal.zsh"
# shellcheck disable=SC2016 # Match literal shell source; expansion is not intended.
grep -q '#080D16' "$ROOT/apply-prism-theme.sh"
echo '[PASS] HN//CIT 4.1.0 adaptive graphic HUD, dedicated input row, alias hotfix and release metadata'

# v4.1.0 adaptive graphic prompt checks
# shellcheck disable=SC2016 # Match literal shell source; expansion is not intended.
grep -Fq 'context_icon="${HN_CONTEXT_ICON' "$ROOT/config/hn-terminal.zsh"
grep -q 'path_budget=' "$ROOT/config/hn-terminal.zsh"
grep -q 'path_budget=' "$ROOT/config/hn-terminal.zsh"
grep -q 'Dedicated third row' "$ROOT/config/hn-terminal.zsh"
assert_absent -q 'KALI LINUX' "$ROOT/config/hn-terminal.zsh"
assert_absent -q 'PRISM X' "$ROOT/config/hn-terminal.zsh"
echo '[PASS] v4.1.0 adaptive HN//CIT graphic prompt and responsive context'

# v4.2.0 jewel-spectrum graphic identity checks
grep -q 'JetBrainsMonoNL Nerd Font Mono' "$ROOT/config/hn-terminal.zsh"
grep -q 'FiraCode Nerd Font Mono' "$ROOT/config/hn-terminal.zsh"
grep -q 'HN_PROJECT_ICON' "$ROOT/config/hn-terminal.zsh"
grep -q 'HN_DOCKER_ICON' "$ROOT/config/hn-terminal.zsh"
grep -q 'HN_RAIL_START' "$ROOT/config/hn-terminal.zsh"
grep -q 'Dedicated third row' "$ROOT/config/hn-terminal.zsh"
# shellcheck disable=SC2016 # Match literal shell source; expansion is not intended.
grep -q 'local reset=\$' "$ROOT/config/hn-terminal.zsh"
grep -q 'wordmark its own visual identity' "$ROOT/config/hn-terminal.zsh"
grep -q 'abbreviate the path from its left' "$ROOT/config/hn-terminal.zsh"
echo '[PASS] v4.2.1 ANSI reset, three-row responsive HUD and independent wordmark spectrum'

# Regression: the three HUD rows must be separated by literal newlines
# outside command substitutions (which strip trailing newlines in ZSH).
PROMPT_FILE="$ROOT/config/hn-terminal.zsh"
grep -Fq 'add-zsh-hook precmd _hn_render_prompt' "$PROMPT_FILE" || { echo '[FAIL] HUD render hook missing'; exit 1; }
# shellcheck disable=SC2016 # Match literal shell source; expansion is not intended.
grep -Fq 'PROMPT="${top}"$' "$PROMPT_FILE" || { echo '[FAIL] HUD literal three-row renderer missing'; exit 1; }
grep -Fq 'unsetopt PROMPT_SUBST' "$PROMPT_FILE" || { echo '[FAIL] PROMPT_SUBST should be disabled'; exit 1; }
assert_absent -Fq "PROMPT='\$(_hn_hud_top)\$(_hn_hud_info)\$(_hn_hud_bottom)'" "$PROMPT_FILE" || { echo '[FAIL] Old single-row prompt expression remains'; exit 1; }
echo '[PASS] Three-row prompt newline regression check'

# v4.2.3 alias collision and HUD geometry regression checks
grep -Fq 'unalias ip ls 2>/dev/null || true' "$ROOT/config/hn-tools.zsh"
grep -Fq 'READY' "$ROOT/config/hn-terminal.zsh"
grep -Fq 'ACTIVE DIR' "$ROOT/config/hn-terminal.zsh"
assert_absent -Fq 'PROCESS READY' "$ROOT/config/hn-terminal.zsh"
assert_absent -Fq '⟡' "$ROOT/config/hn-terminal.zsh"
grep -Fq 'HN_LAST_DURATION' "$ROOT/config/hn-terminal.zsh"
# shellcheck disable=SC2016 # Match literal shell source; expansion is not intended.
grep -Fq 'HN-HEXUS' "$ROOT/install.sh"
assert_absent -Fq "rm -f \"\$CONFIG/\$f\"" "$ROOT/install.sh"
[[ "$(cat "$ROOT/VERSION")" == '4.4.2' ]]
grep -q 'v1.0.0' "$ROOT/README.md"
echo '[PASS] v4.2.3 alias safety, three-row geometry and non-destructive installer checks'

# v4.2.4 discreet scrollbar and preserved scrollback
grep -q 'misc-show-scrollbar bool' "$ROOT/apply-prism-theme.sh"
grep -q 'scrolling-lines int 10000' "$ROOT/apply-prism-theme.sh"
grep -q 'opacity: 0' "$ROOT/theme/gtk-3.0/gtk.css"
grep -q 'scrollbar:hover' "$ROOT/theme/gtk-3.0/gtk.css"
echo '[PASS] v4.2.4 auto-hide scrollbar, hover reveal and 10,000-line scrollback'
grep -q 'EMERALD PULSE' "$ROOT/config/hn-terminal.zsh"
grep -q 'POLAR NIGHT' "$ROOT/config/hn-terminal.zsh"
grep -q 'CRIMSON ALERT' "$ROOT/config/hn-terminal.zsh"
grep -q '_hn_render_prompt' "$ROOT/config/hn-terminal.zsh"
echo '[PASS] v4.2.5 adaptive palettes and ZLE-safe HUD renderer'

# Current rounded premium HUD regression checks
PROMPT_FILE="$ROOT/config/hn-terminal.zsh"
# shellcheck disable=SC2016 # Match literal shell source; expansion is not intended.
grep -Fq 'prefix="╭─( HN ${icon} CIT )"' "$PROMPT_FILE"
grep -Fq "_hn_gradient_text '╮'" "$PROMPT_FILE"
grep -Fq "print -rn -- ' %F{141}─╯%f'" "$PROMPT_FILE"
grep -Fq "_hn_gradient_text '╰─'" "$PROMPT_FILE"
# shellcheck disable=SC2016 # Match literal shell source; expansion is not intended.
grep -Fq 'rail+="%{${esc}%}─"' "$PROMPT_FILE"
# shellcheck disable=SC2016 # Match literal shell source; expansion is not intended.
grep -Fq 'icon="${HN_KALI_ICON:-◈}"' "$PROMPT_FILE"
grep -Fq 'TRAPWINCH()' "$PROMPT_FILE"
echo '[PASS] v4.4.0 rounded frame, Kali dragon icon, unified rail glyphs and resize-aware prompt'

grep -q '^hnstyle()' "$ROOT/config/hn-tools.zsh"
grep -q 'ROYAL GOLD' "$ROOT/config/hn-terminal.zsh"
echo '[PASS] v4.4.0 selectable profiles and expanded visual engine'


# v4.4.1 regression: icon declarations must be real separate shell lines,
# not literal backslash-n sequences accidentally embedded in the source.
if grep -nF "\\n  typeset -g HN_CLOCK_ICON" "$ROOT/config/hn-terminal.zsh" >/dev/null; then
  fail "literal \\n found in Nerd Font icon declaration"
fi
grep -Fq "HN_CLOCK_ICON" "$ROOT/config/hn-terminal.zsh" || fail "clock glyph missing"
for profile in emerald sapphire amethyst arctic rose turquoise indigo lilac jade polar royal matrix blood quantum obsidian; do
  grep -Fq "${profile})" "$ROOT/config/hn-terminal.zsh" || fail "palette mapping missing: ${profile}"
  grep -Fq "|${profile}" "$ROOT/config/hn-tools.zsh" || fail "hnstyle profile missing: ${profile}"
done
echo "[PASS] v4.4.1 icon declaration and all 15 selectable palette regression checks"

# v4.4.2 regression: optional metadata must be gated in both width model and renderer.
for gate in '(( show_git ))' '(( show_env ))' '(( show_remote ))'; do
  grep -Fq "$gate" "$ROOT/config/hn-terminal.zsh" || fail "responsive metadata gate missing: $gate"
done
grep -Fq 'show_remote=0; _hn_info_plain' "$ROOT/config/hn-terminal.zsh" || fail "remote metadata collapse missing"
grep -Fq 'show_env=0; _hn_info_plain' "$ROOT/config/hn-terminal.zsh" || fail "runtime metadata collapse missing"
grep -Fq 'show_git=0; _hn_info_plain' "$ROOT/config/hn-terminal.zsh" || fail "Git metadata collapse missing"
echo '[PASS] v4.4.2 width-budget and rendered-metadata collapse stay synchronized'

# v0.3.2: read-only feature diagnostics are discoverable and cover core UX.
grep -q 'hndoctor()' "$ROOT/config/hn-tools.zsh"
grep -q 'Command-name correction' "$ROOT/config/hn-tools.zsh"
grep -q 'Autosuggestions plugin loaded' "$ROOT/config/hn-tools.zsh"
grep -q 'Syntax-highlighting plugin loaded' "$ROOT/config/hn-tools.zsh"
grep -q '16) hndoctor' "$ROOT/config/hn-tools.zsh"
grep -q "_hn_row 'hndoctor'" "$ROOT/config/hn-tools.zsh"
echo '[PASS] v0.3.2 read-only diagnostics cover correction, completion, plugins and optional tools'
