# HN NEXUS — PRISM X 2.4.0 | Color intelligence & operator utilities
[[ -o interactive ]] || return 0

# ZSH expands aliases while reading function declarations. Kali commonly
# defines `ls` (and some setups define `ip`) as aliases, which collides with
# the matching function declarations below. Remove only these two conflicting
# aliases; their wrappers preserve the native commands and all arguments.
unalias ip ls 2>/dev/null || true

# Native GNU ls remains untouched. Optional tools are detected, never required.
if (( $+commands[eza] )); then
  alias l='eza --icons=auto --group-directories-first'
  alias ll='eza -lah --icons=auto --group-directories-first'
  alias la='eza -a --icons=auto --group-directories-first'
  alias lt='eza --tree --icons=auto'
fi
(( $+commands[batcat] )) && alias bat='batcat'
(( $+commands[btop] )) && alias topx='btop'
if (( $+commands[zoxide] )); then eval "$(zoxide init zsh)"; fi

# Semantic palette: every label/value in COMMAND CENTER reports is deliberately colored.
_hn_head() { print -P "\n%F{51}╭─%f %F{87}◈ HN%F{255}//%F{201}CIT%f %F{244}│%f %F{141}"; print -r -- "$1"; print -P "%f"; }
_hn_rule() { print -P "%F{51}├$(printf '─%.0s' {1..62})%f"; }
_hn_row() { local label="$1" value="$2" color="${3:-255}"; print -P "%F{51}│%f %F{244}${label}%f  %F{${color}}"; print -rn -- "$value"; print -P "%f"; }
_hn_foot() { print -P "%F{51}╰$(printf '─%.0s' {1..62})%f\n"; }

mkcd() {
  (( $# == 1 )) || { print -P "%F{196}✖ Usage:%f %F{87}mkcd <directory>%f" >&2; return 2; }
  command mkdir -p -- "$1" && builtin cd -- "$1"
}

extract() {
  (( $# == 1 )) && [[ -f "$1" ]] || { print -P "%F{196}✖ Usage:%f %F{87}extract <archive>%f" >&2; return 2; }
  case "$1" in
    *.tar.gz|*.tgz) command tar -xzf "$1" ;;
    *.tar.xz|*.txz) command tar -xJf "$1" ;;
    *.tar.bz2|*.tbz2) command tar -xjf "$1" ;;
    *.tar) command tar -xf "$1" ;;
    *.zip) command unzip "$1" ;;
    *.7z) (( $+commands[7z] )) && command 7z x "$1" || { print -P "%F{196}✖ Missing dependency:%f %F{220}7z%f"; return 127; } ;;
    *) print -P "%F{196}✖ Unsupported archive:%f %F{220}${1##*.}%f"; return 2 ;;
  esac
}


# HN NEXUS v4.4.1 — operator-selectable jewel palettes.
# Palette selection changes only prompt rails; it never changes terminal-wide colors.
hnstyle() {
  emulate -L zsh
  local choice="${1:-show}"
  case "${choice:l}" in
    show)
      print -P "%F{87}HN NEXUS VISUAL PROFILE%f"
      print -P "%F{244}Current: %F{141}${HN_PALETTE_NAME:-AUTO}%f  %F{244}Mode: ${HN_THEME_PRESET:-auto}%f"
      print -P "%F{244}Profiles: auto emerald sapphire amethyst arctic rose turquoise indigo lilac jade polar royal matrix blood quantum obsidian%f"
      ;;
    auto|emerald|sapphire|amethyst|arctic|rose|turquoise|indigo|lilac|jade|polar|royal|matrix|blood|quantum|obsidian)
      if [[ "$choice" == auto ]]; then
        unset HN_THEME_PRESET
      else
        typeset -g HN_THEME_PRESET="$choice"
      fi
      _hn_choose_palette
      _hn_render_prompt
      print -P "%F{82}✓%f %F{87}HN visual profile:%f %F{141}${HN_PALETTE_NAME}%f"
      ;;
    *)
      print -P "%F{196}Usage:%f hnstyle [show|auto|emerald|sapphire|amethyst|arctic|rose|turquoise|indigo|lilac|jade|polar|royal|matrix|blood|quantum|obsidian]"
      return 2
      ;;
  esac
}

hnstatus() {
  emulate -L zsh
  _hn_head 'SYSTEM SNAPSHOT'
  _hn_rule
  _hn_row 'Operator' "${USER:-operator}@${HOST:-localhost}" 87
  _hn_row 'Workspace' "${PWD/#$HOME/~}" 39
  _hn_row 'Context' "${HN_CONTEXT_ICON:-◇} ${HN_CONTEXT_LABEL:-FIELD CONSOLE}" 141
  _hn_row 'Shell' "ZSH ${ZSH_VERSION}" 51
  _hn_row 'Terminal' "${TERM:-unknown} / ${COLORTERM:-unknown}" 205
  _hn_row 'Identity' "$([[ $EUID == 0 ]] && print ROOT || print USER)" "$([[ $EUID == 0 ]] && print 196 || print 82)"
  (( $+commands[uptime] )) && _hn_row 'Uptime' "$(command uptime -p 2>/dev/null || command uptime)" 220
  (( $+commands[free] )) && _hn_row 'Memory' "$(command free -h | awk '/^Mem:/ {print $3 " used / " $2 " total"}')" 87
  _hn_foot
}

hnprism() {
  emulate -L zsh
  _hn_head 'LIVE SESSION INTELLIGENCE'
  _hn_rule
  _hn_row 'Operator' "${USER:-operator}@${HOST:-localhost}" 87
  _hn_row 'Directory' "${PWD/#$HOME/~}" 39
  _hn_row 'Context' "${HN_CONTEXT_ICON:-◇} ${HN_CONTEXT_LABEL:-FIELD CONSOLE}" 141
  _hn_row 'Git' "${vcs_info_msg_0_:-not in repository}" "${vcs_info_msg_0_:+220}" 
  local runtime='none'
  [[ -n "${VIRTUAL_ENV:-}" ]] && runtime="${VIRTUAL_ENV:t}"
  [[ -n "${CONDA_DEFAULT_ENV:-}" ]] && runtime="Conda ${CONDA_DEFAULT_ENV}"
  [[ -n "${NODE_VERSION:-}" ]] && runtime="Node ${NODE_VERSION}"
  _hn_row 'Runtime' "$runtime" 82
  if [[ -n "${SSH_CONNECTION:-}${SSH_CLIENT:-}" ]]; then
    _hn_row 'Connection' "REMOTE · ${SSH_CONNECTION%% *}" 205
  else
    _hn_row 'Connection' 'LOCAL SESSION' 51
  fi
  _hn_row 'Last command' "${HN_LAST_STATUS:-0} · ${HN_LAST_DURATION:-<1s}" "$([[ ${HN_LAST_STATUS:-0} == 0 ]] && print 82 || print 196)"
  _hn_foot
}

hnhelp() {
  emulate -L zsh
  _hn_head 'OPERATOR QUICK REFERENCE'
  _hn_rule
  _hn_row 'hnstyle [PROFILE]' 'Switch automatic / royal / matrix / blood / arctic / obsidian palette' 201
  _hn_row 'hnprism' 'Live session / Git / runtime overview' 87
  _hn_row 'hnstatus' 'Compact system snapshot' 51
  _hn_row 'hnicons' 'Preview supported symbol set' 201
  _hn_row 'hnvisual' 'Check Nerd Font, glyphs and terminal capabilities' 39
  _hn_row 'hndoctor' 'Diagnose core, completion, correction and optional plugins' 82
  _hn_row 'hnmenu' 'Interactive COMMAND CENTER launcher' 201
  _hn_row 'hnsearch [TEXT]' 'Search the native-command and PRISM tool catalogue' 39
  _hn_row 'hnhistory [COUNT]' 'Read-only, numbered view of recent ZSH history' 220
  _hn_row 'hnhistory-search [TEXT]' 'Search history with FZF; selected command is inserted, never executed' 87
  _hn_row 'hnsuggest [TEXT]' 'Context-aware command ideas based on workspace files and tools' 51
  _hn_row 'hnexplain [ERROR]' 'Explain common error text; accepts arguments or piped input' 220
  _hn_row 'hnwhy' 'Explain the last command exit status' 141
  _hn_row 'hnlog FILE' 'Read logs with severity-aware colors and line numbers' 220
  _hn_row 'hnreport [FILE]' 'Create a local, read-only system/network snapshot report' 87
  _hn_row 'hnyaml FILE' 'Format YAML when yq is available' 39
  _hn_row 'hnoutput [FILE]' 'Smart output triage; accepts stdin or a saved output file' 87
  _hn_row 'hnnet [FILE|-]' 'Network output highlighter: IPs, ports, protocols, firewall events' 51
  _hn_row 'hnanalyze [FILE|-]' 'Nmap / SSH / DNS / HTTP / firewall text intelligence' 201
  _hn_row 'hnjson FILE' 'Pretty-print JSON with syntax colors (jq)' 39
  _hn_row 'hnfind TEXT [PATH]' 'Search with colored matches (rg/grep)' 141
  _hn_row 'hnops' 'Operations center / tool availability' 87
  _hn_row 'hnports' 'Read-only listening socket overview' 39
  _hn_row 'hnproc' 'Top processes by CPU usage' 220
  _hn_row 'hninspect FILE' 'File metadata and SHA-256 report' 141
  _hn_row 'hndiff OLD NEW' 'Side-by-side semantic diff colors' 201
  _hn_row 'hnfiles [DIR]' 'Cyber file browser with semantic icons' 87
  _hn_row 'hnicon PATH' 'Identify a file or directory by type' 141
  _hn_row 'hncat FILE' 'Numbered, framed text viewer with syntax colors' 87
  _hn_row 'ip a / ip route / ip neigh' 'Native IP command with interface, route and neighbor matrices' 51
  _hn_row 'ip route' 'Read-only routing matrix; other ip arguments remain native' 39
  _hn_row 'ip neigh' 'Local ARP/neighbor cache with state colors' 141
  _hn_row 'ps / df / free / ss / du' 'Native output with numbered semantic color emphasis in interactive terminals' 39
  _hn_row 'cat FILE' 'Native command with numbered syntax-aware viewing in interactive terminals' 87
  _hn_row 'hnipa / hncat' 'Explicit COMMAND CENTER viewers; native cat and ip remain available' 141
  _hn_row 'hncolors' 'Preview PRISM color spectrum' 141
  _hn_row 'cat / ip / ps / df / free / ss' 'Original command names; interactive color layer only' 87
  _hn_row 'mkcd DIR' 'Create directory and enter it' 82
  _hn_row 'extract FILE' 'Extract supported archive formats' 220
  _hn_row 'ls / tree' 'Native directory tools with interactive color presentation' 39
  _hn_row 'l / ll / la / lt' 'Eza shortcuts (only if installed)' 39
  _hn_rule
  print -P '%F{244}Native commands remain native; COMMAND CENTER does not replace ls, cd, ssh or git.%f'
  _hn_foot
}

hncolors() {
  emulate -L zsh
  _hn_head 'COMMAND CENTER SPECTRUM / TRUECOLOR CHECK'
  local -a names=(ICE CYAN ELECTRIC_BLUE VIOLET MAGENTA PINK AMBER LIME ALERT WHITE MUTED)
  local -a codes=(87 51 39 141 201 205 220 82 196 255 244)
  local i
  for (( i=1; i<=${#names}; i++ )); do
    print -P "%F{${codes[i]}}● ${names[i]}%f %F{244}sample text · 0123456789 · Aa-Zz%f"
  done
  print -P '%F{244}If colors look limited, check COLORTERM=truecolor and terminal color settings.%f'
  _hn_foot
}

hnicons() {
  emulate -L zsh
  _hn_head 'ICONOGRAPHY / FALLBACK GLYPHS'
  _hn_row 'Identity' '◈ HN//CIT' 201
  _hn_row 'Home' '⌂  Desktop ▣' 87
  _hn_row 'Files' '▤ Documents  ▧ Assets' 39
  _hn_row 'Projects' '◆ Workspace  ⌬ Laboratory' 141
  _hn_row 'Security' '⚑ CTF  ⌁ Network  ≋ Packets' 220
  _hn_row 'Runtime' 'Py Python  ⎈ Kubernetes  ▣ Docker' 82
  _hn_row 'Status' '✓ Ready  ! Warning  × Error' 196
  print -P '%F{244}These are fallback Unicode glyphs; Nerd Font is optional, not assumed.%f'
  _hn_foot
}



# Visual asset diagnostics. Read-only: never installs packages or changes terminal settings.
hnvisual() {
  emulate -L zsh
  _hn_head 'COMMAND CENTER VISUAL ASSET DIAGNOSTICS'
  local family='' font_ok=0 candidate
  if (( $+commands[fc-match] )); then
    for candidate in 'JetBrainsMono Nerd Font Mono' 'JetBrainsMonoNL Nerd Font Mono' 'FiraCode Nerd Font Mono' 'Hack Nerd Font Mono' 'MesloLGS Nerd Font Mono'; do
      family=$(fc-match -f '%{family}' "$candidate" 2>/dev/null)
      if [[ "${family:l}" == *'nerd font'* ]]; then font_ok=1; break; fi
    done
  fi
  if (( font_ok )); then
    print -P "%F{82}● Nerd Font detected%f %F{244}(${family})%f"
    print -P '%F{39}   Operator   Workspace   Console   Git   Python%f'
    print -P '%F{141} SSH   Branch   Docker   Data   Pass   Fail   Input%f'
  else
    print -P '%F{220}● Nerd Font not detected; safe Unicode fallbacks remain active.%f'
    print -P '%F{244}Recommended: JetBrainsMono Nerd Font Mono, then reopen the terminal.%f'
  fi
  _hn_row 'Font match' "${family:-not available}" 87
  _hn_row 'Truecolor' "${COLORTERM:-not advertised}" 51
  _hn_row 'Terminal width' "${COLUMNS:-unknown} columns" 39
  _hn_row 'Kali mark' ' (Nerd Font required)' 201
  _hn_foot
}

# Read-only diagnostics for the features users expect to work after installation.
# Optional tools are reported as optional; no package manager or settings are changed.
hndoctor() {
  emulate -L zsh
  local pass=0 warn=0 fail=0 config_root="$HOME/HN-NEXUS/CORE/CONFIG" item state detail font_family=''
  [[ -d "$config_root" ]] || config_root="$HOME/HN-HEXUS/CORE/CONFIG"
  _hn_section 'HN NEXUS / SYSTEM DIAGNOSTICS'
  _hn_kv 'Shell' "ZSH ${ZSH_VERSION}"
  _hn_kv 'Terminal' "${TERM:-unknown} · ${COLORTERM:-no truecolor flag}"

  for item in hn-sovereign.zsh hn-terminal.zsh hn-tools.zsh; do
    if [[ -s "$config_root/$item" ]]; then state=PASS; (( pass++ )); detail='installed'
    else state=FAIL; (( fail++ )); detail='missing or empty'; fi
    if [[ "$state" == PASS ]]; then print -P "%F{82}● PASS%f  ${item} · ${detail}"
    else print -P "%F{196}● FAIL%f  ${item} · ${detail}"; fi
  done

  if [[ -o correct ]] && [[ ! -o correctall ]]; then
    print -P '%F{82}● PASS%f  Command-name correction · asks before correcting command names'
    (( pass++ ))
  else
    print -P '%F{196}● FAIL%f  Command correction should be enabled (CORRECT) and CORRECT_ALL disabled'
    (( fail++ ))
  fi

  if (( ${+_comps} )); then
    print -P '%F{82}● PASS%f  ZSH completion system initialized'
    (( pass++ ))
  else
    print -P '%F{220}● WARN%f  ZSH completion map not detected in this session'
    (( warn++ ))
  fi

  if (( $+functions[_zsh_autosuggest_start] )); then
    print -P '%F{82}● PASS%f  Autosuggestions plugin loaded'
    (( pass++ ))
  elif [[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    print -P '%F{220}● WARN%f  Autosuggestions file exists but plugin is not active in this shell'
    (( warn++ ))
  else
    print -P '%F{220}● WARN%f  Autosuggestions plugin unavailable (optional)'
    (( warn++ ))
  fi

  if (( ${+ZSH_HIGHLIGHT_VERSION} )) || (( $+functions[_zsh_highlight] )); then
    print -P '%F{82}● PASS%f  Syntax-highlighting plugin loaded'
    (( pass++ ))
  elif [[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    print -P '%F{220}● WARN%f  Syntax-highlighting file exists but plugin is not active in this shell'
    (( warn++ ))
  else
    print -P '%F{220}● WARN%f  Syntax-highlighting plugin unavailable (optional)'
    (( warn++ ))
  fi

  for item in hnsuggest hnhistory-search hnexplain hnwhy; do
    if (( $+functions[$item] )); then
      print -P "%F{82}● PASS%f  Operator intelligence helper loaded: ${item}"
      (( pass++ ))
    else
      print -P "%F{196}● FAIL%f  Operator intelligence helper missing: ${item}"
      (( fail++ ))
    fi
  done

  for item in fzf eza batcat jq yq rg zoxide btop; do
    if (( $+commands[$item] )); then
      print -P "%F{82}● PASS%f  Optional tool available: ${item}"
      (( pass++ ))
    else
      print -P "%F{244}○ INFO%f  Optional tool not installed: ${item}"
      (( warn++ ))
    fi
  done

  if (( $+commands[fc-match] )); then
    font_family=$(command fc-match -f '%{family}' 'JetBrainsMono Nerd Font Mono' 2>/dev/null)
    if [[ "${font_family:l}" == *'nerd font'* ]]; then
      print -P "%F{82}● PASS%f  Nerd Font detected · ${font_family}"
      (( pass++ ))
    else
      print -P '%F{220}● WARN%f  Nerd Font not detected; Unicode fallback icons remain available'
      (( warn++ ))
    fi
  else
    print -P '%F{220}● WARN%f  Fontconfig fc-match unavailable; font detection skipped'
    (( warn++ ))
  fi

  if [[ "${COLORTERM:-}" == *truecolor* || "${TERM:-}" == *-direct ]]; then
    print -P '%F{82}● PASS%f  Truecolor terminal capability advertised'
    (( pass++ ))
  else
    print -P '%F{220}● WARN%f  Truecolor not advertised by terminal environment'
    (( warn++ ))
  fi

  _hn_section 'DIAGNOSTIC SUMMARY'
  _hn_kv 'Passed' "$pass"
  _hn_kv 'Warnings / optional' "$warn"
  _hn_kv 'Required failures' "$fail"
  print -P '%F{244}Read-only diagnostic: no packages, shell settings or desktop settings were changed.%f\n'
  (( fail == 0 ))
}


# HN NEXUS v0.3.3 — context-aware operator assistance.
# All helpers are advisory/read-only. Selected history is inserted into the
# ZLE edit buffer with print -z; it is never executed automatically.
hnsuggest() {
  emulate -L zsh
  local query="$*" qlow item
  qlow="${(L)query}"
  local -a hints=()
  _hn_section 'CONTEXT-AWARE COMMAND SUGGESTIONS'
  _hn_kv 'Workspace' "${PWD/#$HOME/~}"

  if [[ -d .git || -f .git ]]; then
    hints+=("git status --short --branch|Review repository state")
    hints+=("git diff --stat|Summarize working-tree changes")
    hints+=("git log -5 --oneline|Review recent commits")
    (( $+commands[git] )) && hints+=("git branch --show-current|Show current branch")
  fi
  if [[ -f pyproject.toml || -f requirements.txt || -f Pipfile || -f uv.lock || -f poetry.lock || -f environment.yml ]]; then
    hints+=("python3 --version|Check Python runtime")
    hints+=("python3 -m venv .venv|Create an isolated virtual environment")
    [[ -f requirements.txt ]] && hints+=("python3 -m pip install -r requirements.txt|Install project requirements")
    [[ -f pyproject.toml ]] && hints+=("python3 -m pip install -e .|Install this Python project in editable mode")
    (( $+commands[pytest] )) && hints+=("pytest -q|Run Python tests")
  fi
  if [[ -f package.json ]]; then
    hints+=("node --version|Check Node.js runtime")
    hints+=("npm run|List project scripts")
    [[ -d node_modules ]] && hints+=("npm test|Run the project's configured tests") || hints+=("npm install|Install dependencies from package-lock metadata")
  fi
  if [[ -f Dockerfile || -f compose.yaml || -f compose.yml || -f docker-compose.yml || -f docker-compose.yaml ]]; then
    hints+=("docker compose config|Validate Compose configuration")
    hints+=("docker compose ps|List project containers")
  fi
  if [[ -d tests || -d test ]]; then
    hints+=("find tests -maxdepth 2 -type f -print|List test files")
  fi
  if [[ -d .git ]]; then
    hints+=("git diff --check|Check whitespace errors in changes")
  fi
  if [[ -d logs ]]; then
    hints+=("hnlog <log-file>|Inspect a log with severity highlighting")
  fi
  if (( ${#hints} == 0 )); then
    hints+=("hnstatus|Inspect the current system snapshot")
    hints+=("hnops|Review available operator tools")
    hints+=("hnsearch <keyword>|Search the local command catalogue")
    hints+=("hnfiles .|Browse this workspace")
  fi

  local shown=0
  for item in "${hints[@]}"; do
    local cmd="${item%%|*}" desc="${item#*|}"
    if [[ -z "$query" || "${(L)item}" == *"$qlow"* || "${(L)cmd}" == *"$qlow"* || "${(L)desc}" == *"$qlow"* ]]; then
      (( shown++ ))
      print -P "%F{87}${shown}.%f %F{51}${cmd}%f"
      print -P "   %F{244}${desc}%f"
    fi
  done
  (( shown )) || print -P '%F{220}No context suggestion matched that filter.%f'
  print -P '%F{244}Suggestions are based on local filenames and installed tools; nothing is executed.%f\n'
}

hnhistory-search() {
  emulate -L zsh
  local query="$*" history_text selected
  history_text="$(builtin fc -l -n -2000 2>/dev/null)"
  if [[ -z "$history_text" ]]; then
    print -P '%F{220}No in-session ZSH history is available.%f'
    return 1
  fi
  if (( $+commands[fzf] )); then
    selected="$(print -r -- "$history_text" | command fzf --no-sort --tac --query "$query" --prompt='HN HISTORY > ' --height=70% --layout=reverse)" || return 0
    if [[ -n "$selected" ]]; then
      print -z -- "$selected"
      print -P '%F{82}✓ Selected command inserted into the prompt. Review it, then press Enter yourself.%f'
    fi
  else
    if [[ -n "$query" ]]; then
      print -r -- "$history_text" | command grep -i -- "$query" | tail -n 50
    else
      print -r -- "$history_text" | tail -n 50
    fi
    print -P '%F{244}Install fzf for interactive filtering. History remains read-only.%f'
  fi
}

hnexplain() {
  emulate -L zsh
  local input="$*" low
  if [[ -z "$input" && ! -t 0 ]]; then input="$(command cat)"; fi
  if [[ -z "$input" ]]; then
    print -P '%F{220}Usage: hnexplain <error text>  |  command 2>&1 | hnexplain%f'
    return 2
  fi
  low="${(L)input}"
  _hn_section 'ERROR INTELLIGENCE / ADVISORY ANALYSIS'
  print -P '%F{244}Input:%f'
  print -r -- "$input" | command head -n 8
  if [[ "$low" == *'command not found'* || "$low" == *'not found'* ]]; then
    print -P '%F{220}Likely cause:%f command or executable is missing, misspelled, or not on PATH.'
    print -P '%F{87}Try:%f command -v <name> · type -a <name> · check spelling and PATH.'
  elif [[ "$low" == *'permission denied'* || "$low" == *'operation not permitted'* ]]; then
    print -P '%F{220}Likely cause:%f current user lacks permission, or the filesystem/security policy blocks the action.'
    print -P '%F{87}Try:%f ls -l <path> · namei -l <path> · inspect ownership before changing permissions.'
  elif [[ "$low" == *'no such file or directory'* ]]; then
    print -P '%F{220}Likely cause:%f a path component does not exist or the current directory is different than expected.'
    print -P '%F{87}Try:%f pwd · ls -la <parent> · use an absolute path and check capitalization.'
  elif [[ "$low" == *'address already in use'* || "$low" == *'eaddrinuse'* ]]; then
    print -P '%F{220}Likely cause:%f another process is already listening on the requested address/port.'
    print -P '%F{87}Try:%f ss -ltnp · identify the owning process before stopping anything.'
  elif [[ "$low" == *'connection refused'* ]]; then
    print -P '%F{220}Likely cause:%f the destination is reachable but no service accepted the connection, or a firewall rejected it.'
    print -P '%F{87}Try:%f verify host/port, service state and firewall rules on systems you administer.'
  elif [[ "$low" == *'timed out'* || "$low" == *'timeout'* ]]; then
    print -P '%F{220}Likely cause:%f the operation did not receive a response before its timeout.'
    print -P '%F{87}Try:%f check connectivity, DNS, route, service health and whether the timeout is appropriate.'
  elif [[ "$low" == *'syntax error'* || "$low" == *'parse error'* || "$low" == *'unexpected token'* ]]; then
    print -P '%F{220}Likely cause:%f malformed syntax, unmatched quotes/brackets, or an unsupported language/runtime version.'
    print -P '%F{87}Try:%f inspect the indicated line, balance quotes and delimiters, then run the relevant parser/linter.'
  elif [[ "$low" == *'no space left on device'* ]]; then
    print -P '%F{220}Likely cause:%f a filesystem or inode pool is exhausted.'
    print -P '%F{87}Try:%f df -h · df -i · inspect large files before removing anything.'
  elif [[ "$low" == *'could not resolve host'* || "$low" == *'temporary failure in name resolution'* ]]; then
    print -P '%F{220}Likely cause:%f DNS resolution failed.'
    print -P '%F{87}Try:%f check the hostname, resolver configuration and network connectivity.'
  else
    print -P '%F{220}No exact rule matched.%f This helper does not guess a definitive cause.'
    print -P '%F{87}Next steps:%f capture the full error, identify the failing command and inspect its --help/man page.'
  fi
  print -P '%F{244}Advisory only: no command was executed and no system setting was changed.%f\n'
}

hnwhy() {
  emulate -L zsh
  local status="${HN_LAST_STATUS:-0}" command_name="${HN_LAST_COMMAND:-unknown command}"
  _hn_section 'LAST COMMAND / EXIT STATUS ANALYSIS'
  _hn_kv 'Command label' "$command_name"
  _hn_kv 'Exit status' "$status"
  if [[ "$status" == 0 ]]; then
    print -P '%F{82}The last command reported success (exit status 0).%f'
  else
    print -P '%F{220}The last command failed or reported a non-zero status.%f'
    case "$status" in
      1) print -P '%F{244}Status 1 commonly means a general failure or a negative/no-match result; inspect the command output.%f' ;;
      2) print -P '%F{244}Status 2 commonly indicates incorrect usage, invalid options or a syntax/argument error.%f' ;;
      126) print -P '%F{244}Status 126: command was found but could not be executed (permissions or executable format).%f' ;;
      127) print -P '%F{244}Status 127: command was not found; check spelling, installation and PATH.%f' ;;
      130) print -P '%F{244}Status 130: command was interrupted with Ctrl+C.%f' ;;
      137) print -P '%F{244}Status 137: process received SIGKILL; inspect memory pressure or external termination.%f' ;;
      139) print -P '%F{244}Status 139: process likely terminated after SIGSEGV; inspect its logs/debug symbols.%f' ;;
      143) print -P '%F{244}Status 143: process received SIGTERM.%f' ;;
      *) print -P '%F{244}Exit statuses are command-specific; pass the actual error text to hnexplain for a more useful hint.%f' ;;
    esac
  fi
  print -P '%F{244}For error text: hnexplain "paste the error here"%f\n'
}

# Native ZSH completion with task-specific choices; file arguments use _files.
if (( $+functions[compdef] )); then
  compdef '_arguments "1:profile:(auto emerald sapphire amethyst arctic rose turquoise indigo lilac jade polar royal matrix blood quantum obsidian)"' hnstyle
  compdef _files hncat hnlog hnjson hnyaml hninspect hnicon
fi

# Small interactive launcher. Only invokes explicitly selected PRISM read-only helpers.
hnmenu() {
  emulate -L zsh
  local choice target
  print -P '\n%F{51}╭─%f %F{141}HN//CIT · COMMAND CENTER%f'
  print -P '%F{51}│%f %F{87}1%f  Session intelligence   %F{51}│%f %F{87}2%f  System snapshot'
  print -P '%F{51}│%f %F{87}3%f  Visual diagnostics     %F{51}│%f %F{87}4%f  File browser'
  print -P '%F{51}│%f %F{87}5%f  Network listeners      %F{51}│%f %F{87}6%f  Help'
  print -P '%F{51}│%f %F{87}7%f  IP address matrix      %F{51}│%f %F{87}8%f  Structured CAT viewer'
  print -P '%F{51}│%f %F{87}9%f  System report           %F{51}│%f %F{87}10%f Log viewer'
  print -P '%F{51}│%f %F{87}11%f Command finder          %F{51}│%f %F{87}12%f Recent history'
  print -P '%F{51}│%f %F{87}13%f System health           %F{51}│%f %F{87}14%f Services'
  print -P '%F{51}│%f %F{87}15%f Containers              %F{51}│%f %F{87}16%f HN diagnostics'
  print -P '%F{51}│%f %F{87}17%f Context suggestions     %F{51}│%f %F{87}18%f Search history'
  print -P '%F{51}│%f %F{87}19%f Explain last failure'
  print -P '%F{51}╰─%f %F{244}q to close%f'
  print -Pn '%F{51}COMMAND ❯ %f'
  read -r choice
  case "$choice" in
    1) hnprism ;; 2) hnstatus ;; 3) hnvisual ;; 4) hnfiles ;; 5) hnports ;; 6) hnhelp ;;
    7) hnipa ;;
    8) print -Pn '%F{51}FILE PATH ❯ %f'; read -r target; [[ -n "$target" ]] && hncat "$target" ;;
    9) hnreport ;;
    10) print -Pn '%F{51}LOG FILE ❯ %f'; read -r target; [[ -n "$target" ]] && hnlog "$target" ;;
    11) print -Pn '%F{51}SEARCH COMMANDS ❯ %f'; read -r target; hnsearch "$target" ;;
    12) hnhistory 30 ;;
    13) hnhealth ;;
    14) hnservices ;;
    15) hncontainers ;;
    16) hndoctor ;;
    17) hnsuggest ;;
    18) print -Pn '%F{51}HISTORY FILTER ❯ %f'; read -r target; hnhistory-search "$target" ;;
    19) hnwhy ;;
    q|Q|'') return 0 ;;
    *) print -P '%F{196}Unknown selection.%f'; return 2 ;;
  esac
}


# PRISM X 2.6 operator utilities — read-only, explicit, dependency-aware.
# These helpers format information; they never replace native commands.
_hn_section() { print -P "\n%F{51}╭─%f %F{141}$1%f"; }
_hn_kv() { print -P "%F{51}│%f %F{244}$1%f  %F{87}$2%f"; }

hnops() {
  emulate -L zsh
  _hn_section 'COMMAND OPERATIONS CENTER'
  _hn_kv 'Identity' "${USER:-operator}@${HOST:-localhost}"
  _hn_kv 'Workspace' "${PWD/#$HOME/~}"
  _hn_kv 'Context' "${HN_CONTEXT_ICON:-◇} ${HN_CONTEXT_LABEL:-FIELD CONSOLE}"
  _hn_kv 'Shell' "ZSH ${ZSH_VERSION} · ${TERM:-unknown}"
  _hn_section 'AVAILABLE CAPABILITIES'
  local c; local -a tools=(git python3 python pip3 docker podman kubectl nmap wireshark tshark tcpdump jq yq rg fzf eza batcat btop tmux)
  for c in $tools; do
    if (( $+commands[$c] )); then print -P "%F{82}●%f %F{255}${c}%f %F{244}available%f"; else print -P "%F{240}○%f %F{244}${c} · not detected%f"; fi
  done
  _hn_section 'SESSION STATE'
  (( EUID == 0 )) && print -P '%F{196}◆ ROOT SESSION%f' || print -P '%F{82}● STANDARD USER%f'
  [[ -n ${SSH_CONNECTION:-} ]] && print -P "%F{205}⌁ REMOTE SESSION%f %F{255}${SSH_CONNECTION%% *}%f" || print -P '%F{51}⌂ LOCAL SESSION%f'
  [[ -n ${VIRTUAL_ENV:-}${CONDA_DEFAULT_ENV:-} ]] && print -P '%F{82}Py ENVIRONMENT ACTIVE%f' || print -P '%F{244}Python environment inactive%f'
  print -P '%F{51}╰─ COMMAND CENTER · READ-ONLY SNAPSHOT%f\n'
}

hnports() {
  emulate -L zsh
  if (( ! $+commands[ss] )); then print -P '%F{196}✖ ss is unavailable%f' >&2; return 127; fi
  _hn_section 'NETWORK LISTENING SOCKETS'
  command ss -H -lntu 2>/dev/null | while IFS= read -r line; do
    if [[ "$line" == *'127.0.0.1:'* || "$line" == *'[::1]:'* ]]; then
      print -P "%F{82}${line}%f"
    elif [[ "$line" == *'0.0.0.0:'* || "$line" == *'[*]:'* || "$line" == *':::'* ]]; then
      print -P "%F{220}${line}%f"
    else
      print -P "%F{87}${line}%f"
    fi
  done
  print -P '%F{244}Green: loopback · Amber: wildcard bind · Cyan: other listener%f\n'
}

hnproc() {
  emulate -L zsh
  _hn_section 'PROCESS ACTIVITY · TOP 15 BY CPU'
  command ps -eo pid,pcpu,pmem,comm --sort=-pcpu 2>/dev/null | head -n 16 | while IFS= read -r line; do
    if [[ "$line" == PID* ]]; then print -P "%F{51}${line}%f"; else print -P "%F{87}${line}%f"; fi
  done
  print -P '%F{244}Read-only process snapshot; use native ps/top for full control.%f\n'
}

hninspect() {
  emulate -L zsh
  (( $# == 1 )) || { print -P '%F{196}✖ Usage:%f %F{87}hninspect <file>%f' >&2; return 2; }
  [[ -e "$1" ]] || { print -P "%F{196}✖ Not found:%f %F{220}$1%f" >&2; return 2; }
  _hn_section 'FILE INTELLIGENCE'
  _hn_kv 'Name' "${1:t}"
  _hn_kv 'Path' "${1:A}"
  _hn_kv 'Type' "$(command file -b -- "$1" 2>/dev/null || print unknown)"
  _hn_kv 'Size' "$(command stat -c '%s bytes' -- "$1" 2>/dev/null || print unknown)"
  _hn_kv 'Modified' "$(command stat -c '%y' -- "$1" 2>/dev/null || print unknown)"
  if [[ -f "$1" ]]; then
    _hn_kv 'SHA-256' "$(command sha256sum -- "$1" 2>/dev/null | awk '{print $1}')"
  fi
  print -P '%F{51}╰─ END FILE REPORT%f\n'
}

hndiff() {
  emulate -L zsh
  (( $# == 2 )) || { print -P '%F{196}✖ Usage:%f %F{87}hndiff <old-file> <new-file>%f' >&2; return 2; }
  [[ -f "$1" && -f "$2" ]] || { print -P '%F{196}✖ Both inputs must be files%f' >&2; return 2; }
  if (( $+commands[colordiff] )); then command colordiff -u -- "$1" "$2"
  else command diff --color=always -u -- "$1" "$2"; fi
}



# PRISM X 2.7 — semantic file icon engine and read-only directory browser.
# Uses Zsh globbing only; no ls replacement, indexing, background process, or daemon.
_hn_file_visual() {
  local path="$1" ext="${1:e:l}"
  REPLY_ICON='▤'; REPLY_COLOR=255; REPLY_KIND='FILE'
  if [[ -L "$path" ]]; then
    REPLY_ICON='↗'; REPLY_COLOR=51; REPLY_KIND='SYMLINK'
  elif [[ -d "$path" ]]; then
    REPLY_ICON='▣'; REPLY_COLOR=39; REPLY_KIND='DIRECTORY'
  elif [[ -x "$path" ]]; then
    REPLY_ICON='⚙'; REPLY_COLOR=82; REPLY_KIND='EXECUTABLE'
  else
    case "$ext" in
      py|pyw) REPLY_ICON='Py'; REPLY_COLOR=220; REPLY_KIND='PYTHON' ;;
      sh|zsh|bash) REPLY_ICON='⌘'; REPLY_COLOR=82; REPLY_KIND='SHELL SCRIPT' ;;
      js|jsx|ts|tsx|json|html|css|xml|yml|yaml|toml) REPLY_ICON='◇'; REPLY_COLOR=220; REPLY_KIND='SOURCE / CONFIG' ;;
      c|h|cpp|hpp|rs|go|java|kt) REPLY_ICON='⌘'; REPLY_COLOR=87; REPLY_KIND='CODE' ;;
      md|txt|rst|pdf|doc|docx|odt) REPLY_ICON='▤'; REPLY_COLOR=255; REPLY_KIND='DOCUMENT' ;;
      png|jpg|jpeg|gif|webp|svg|ico) REPLY_ICON='▧'; REPLY_COLOR=201; REPLY_KIND='IMAGE' ;;
      mp3|wav|ogg|flac) REPLY_ICON='♫'; REPLY_COLOR=141; REPLY_KIND='AUDIO' ;;
      mp4|mkv|mov|webm) REPLY_ICON='▶'; REPLY_COLOR=205; REPLY_KIND='VIDEO' ;;
      zip|7z|rar|gz|xz|bz2|tar) REPLY_ICON='▦'; REPLY_COLOR=220; REPLY_KIND='ARCHIVE' ;;
      log) REPLY_ICON='≡'; REPLY_COLOR=51; REPLY_KIND='LOG' ;;
      pem|crt|cer|key|pub|p12|pfx) REPLY_ICON='⚿'; REPLY_COLOR=196; REPLY_KIND='CERTIFICATE / KEY' ;;
      db|sqlite|sqlite3|sql) REPLY_ICON='▥'; REPLY_COLOR=39; REPLY_KIND='DATABASE' ;;
      conf|cfg|ini|env) REPLY_ICON='⚙'; REPLY_COLOR=87; REPLY_KIND='CONFIGURATION' ;;
    esac
  fi
}

hnicon() {
  emulate -L zsh
  (( $# == 1 )) || { print -P '%F{196}✖ Usage:%f %F{87}hnicon <path>%f' >&2; return 2; }
  [[ -e "$1" || -L "$1" ]] || { print -P "%F{196}✖ Not found:%f %F{220}$1%f" >&2; return 2; }
  _hn_file_visual "$1"
  print -P "%F{${REPLY_COLOR}}${REPLY_ICON}%f %F{255}${1:t}%f %F{244}│ ${REPLY_KIND}%f"
}

hnfiles() {
  emulate -L zsh
  local dir="${1:-.}" item count=0
  (( $# <= 1 )) || { print -P '%F{196}✖ Usage:%f %F{87}hnfiles [directory]%f' >&2; return 2; }
  [[ -d "$dir" ]] || { print -P "%F{196}✖ Directory not found:%f %F{220}$dir%f" >&2; return 2; }
  _hn_section "CYBER FILE VIEW · ${dir:A}"
  for item in "$dir"/*(DN); do
    [[ -e "$item" || -L "$item" ]] || continue
    _hn_file_visual "$item"
    print -P "%F{${REPLY_COLOR}}${REPLY_ICON}%f %F{255}${item:t}%f %F{244}│ ${REPLY_KIND}%f"
    count=$(( count + 1 ))
  done
  (( count )) || print -P '%F{244}No entries in this directory.%f'
  print -P "%F{51}╰─ ${count} entries · hidden files included · read-only%f\n"
}

# Optional fzf integration, loaded only when its packaged scripts exist.
if (( $+commands[fzf] )); then
  [[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
  [[ -r /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
fi


# Smart, opt-in output viewers. They never replace cat/grep/tail or alter pipes.
_hn_need_file() {
  [[ -n "${1:-}" && -f "$1" ]] || {
    print -P "%F{196}✖ File not found:%f %F{220}${1:-<missing>}%f" >&2
    return 2
  }
}

hnlog() {
  emulate -L zsh
  (( $# == 1 )) || { print -P '%F{196}✖ Usage:%f %F{87}hnlog <log-file>%f' >&2; return 2; }
  _hn_need_file "$1" || return
  awk '
    BEGIN { c="\033[0m"; n=0 }
    {
      n++; low=tolower($0); color="\033[37m"; mark="  "; severity="other"
      if (low ~ /fatal|critical|panic/) { color="\033[1;31m"; mark="✖ "; severity="critical" }
      else if (low ~ /error|failed|failure/) { color="\033[31m"; mark="! "; severity="error" }
      else if (low ~ /warn|deprecated/) { color="\033[1;33m"; mark="▲ "; severity="warning" }
      else if (low ~ /success|passed|ready|connected/) { color="\033[1;32m"; mark="✓ "; severity="success" }
      else if (low ~ /debug|trace/) { color="\033[90m"; severity="debug" }
      else if (low ~ /info|notice/) { color="\033[36m"; severity="info" }
      count[severity]++
      printf "\033[90m%05d\033[0m %s%s%s%s\n", n, color, mark, $0, c
    }
    END { printf "\n\033[1;36mLOG SUMMARY\033[0m  lines %d  \033[1;31mcritical %d\033[0m  \033[31merrors %d\033[0m  \033[1;33mwarnings %d\033[0m  \033[1;32msuccess %d\033[0m\n", n, count["critical"], count["error"], count["warning"], count["success"] }
  ' "$1"
}

hnjson() {
  emulate -L zsh
  (( $# == 1 )) || { print -P '%F{196}✖ Usage:%f %F{87}hnjson <json-file>%f' >&2; return 2; }
  _hn_need_file "$1" || return
  if (( $+commands[jq] )); then command jq -C . -- "$1"
  else print -P '%F{196}✖ jq is not installed.%f %F{244}Install it only if you need colored JSON viewing.%f' >&2; return 127
  fi
}

hnyaml() {
  emulate -L zsh
  (( $# == 1 )) || { print -P '%F{196}✖ Usage:%f %F{87}hnyaml <yaml-file>%f' >&2; return 2; }
  _hn_need_file "$1" || return
  if (( $+commands[yq] )); then command yq -P '.' "$1"
  else print -P '%F{196}✖ yq is not installed.%f %F{244}YAML viewer is optional; no package was installed.%f' >&2; return 127
  fi
}

# Structured CAT viewer: numbered rows, framed title, syntax colors when bat exists.
# Native cat remains untouched for scripts, pipes and binary-safe use.
hncat() {
  emulate -L zsh
  (( $# == 1 )) || { print -P '%F{196}✖ Usage:%f %F{87}hncat <text-file>%f' >&2; return 2; }
  _hn_need_file "$1" || return
  [[ -r "$1" ]] || { print -P '%F{196}✖ File is not readable.%f' >&2; return 1; }
  local kind
  kind=$(command file -b -- "$1" 2>/dev/null)
  if [[ "$kind" == *text* || "$kind" == *script* || "$kind" == *JSON* || "$kind" == *XML* || "$kind" == *empty* ]]; then
    _hn_section "CAT / STRUCTURED VIEW · ${1:t}"
    if (( $+commands[batcat] )); then
      command batcat --color=always --paging=never --style=header,grid,numbers -- "$1"
    elif (( $+commands[bat] )); then
      command bat --color=always --paging=never --style=header,grid,numbers -- "$1"
    else
      command awk '
        BEGIN { reset="\033[0m"; cyan="\033[1;36m"; muted="\033[90m"; white="\033[37m" }
        { printf "%s%4d%s %s%s%s\n", muted, NR, reset, white, $0, reset }
        END { printf "\n%s──── %d lines · numbered fallback view ────%s\n", cyan, NR, reset }
      ' "$1"
    fi
    print -P '%F{51}╰─%f %F{244}Read-only · native cat is unchanged%f
'
  else
    print -P '%F{220}⚠ Non-text file detected; showing safe file metadata instead of raw bytes.%f'
    _hn_kv 'Type' "$kind"
    _hn_kv 'Size' "$(command stat -c '%s bytes' -- "$1" 2>/dev/null)"
    print -P '%F{244}Use xxd or hexdump when a byte-level view is intended.%f'
  fi
}

# Compact, colored interface table for the familiar `ip a` view.
# Read-only wrapper; the system ip command and its arguments are never replaced.
hnipa() {
  emulate -L zsh
  (( $# <= 1 )) || { print -P '%F{196}✖ Usage:%f %F{87}hnipa [-4|-6]%f' >&2; return 2; }
  local family="${1:-}"; [[ "$family" == -4 || "$family" == -6 || -z "$family" ]] || { print -P '%F{196}✖ Use -4, -6, or no option.%f' >&2; return 2; }
  (( $+commands[ip] )) || { print -P '%F{196}✖ ip command is unavailable.%f' >&2; return 127; }
  local -a args
  args=( -br addr show )
  [[ -n "$family" ]] && args+=( "$family" )
  _hn_section 'NETWORK INTERFACES / ADDRESS MATRIX'
  print -P '%F{51}┌────┬────────────────────┬────────────┬──────────────────────────────────────────────┐%f'
  print -P '%F{51}│%f %F{87}NO%f  %F{51}│%f %F{87}INTERFACE%f            %F{51}│%f %F{87}STATE%f       %F{51}│%f %F{87}IP ADDRESS / PREFIX%f                         %F{51}│%f'
  print -P '%F{51}├────┼────────────────────┼────────────┼──────────────────────────────────────────────┤%f'
  command ip "${args[@]}" 2>/dev/null | command awk '
    BEGIN { reset="\033[0m"; cyan="\033[96m"; green="\033[92m"; amber="\033[93m"; red="\033[91m"; blue="\033[94m"; n=0 }
    {
      iface=$1; state=$2; addr="";
      for (i=3; i<=NF; i++) addr=addr (addr=="" ? "" : "  ") $i;
      if (state=="UP" || state=="UNKNOWN") sc=green; else if (state=="DOWN") sc=red; else sc=amber;
      if (iface ~ /^lo$/) ic=blue; else ic=cyan;
      if (addr=="") addr="— no address —";
      printf "%s│%s %s%02d%s %s│%s %-20.20s %s│%s %s%-10s%s %s│%s %-44.44s %s│%s\n", cyan,reset,cyan,++n,reset,cyan,reset,iface,cyan,reset,sc,state,reset,cyan,reset,addr,cyan,reset
    }
    END { printf "%s├────┴────────────────────┴────────────┴──────────────────────────────────────────────┤%s\n",cyan,reset; printf "%s│%s %sInterfaces: %d%s\n",cyan,reset,green,n,reset }
  '
  local rc=$?
  print -P '%F{51}╰─%f %F{244}Green: UP · Red: DOWN · Blue: loopback · addresses are read-only%f
'
  return $rc
}

# Local snapshot report. Read-only collection; writes only the requested report file.
hnreport() {
  emulate -L zsh
  (( $# <= 1 )) || { print -P '%F{196}✖ Usage:%f %F{87}hnreport [output-file]%f' >&2; return 2; }
  local stamp outfile
  stamp=$(command date +%Y%m%d-%H%M%S)
  outfile="${1:-$HOME/HN-NEXUS/REPORTS/PRISM-SYSTEM-$stamp.txt}"
  command mkdir -p -- "${outfile:h}" 2>/dev/null || { print -P '%F{196}✖ Cannot create report directory.%f' >&2; return 1; }
  : >| "$outfile" || { print -P '%F{196}✖ Cannot write report file.%f' >&2; return 1; }
  {
    print 'HN//CIT COMMAND CENTER — SYSTEM INTELLIGENCE REPORT'
    print '============================================'
    print "Generated: $(command date '+%Y-%m-%d %H:%M:%S %Z')"
    print "Host: $(command hostname 2>/dev/null)"
    print "Kernel: $(command uname -srmo 2>/dev/null)"
    print '
[ OPERATING SYSTEM ]'
    if [[ -r /etc/os-release ]]; then command sed -n '1,8p' /etc/os-release; else print 'OS release information unavailable'; fi
    print '
[ UPTIME ]'
    command uptime 2>&1
    print '
[ MEMORY ]'
    if (( $+commands[free] )); then command free -h; else print 'free command unavailable'; fi
    print '
[ FILESYSTEMS ]'
    command df -hT 2>&1
    print '
[ NETWORK INTERFACES ]'
    if (( $+commands[ip] )); then command ip -br addr 2>&1; else print 'ip command unavailable'; fi
    print '
[ ROUTES ]'
    if (( $+commands[ip] )); then command ip route 2>&1; else print 'ip command unavailable'; fi
    print '
[ SOCKET SUMMARY ]'
    if (( $+commands[ss] )); then command ss -s 2>&1; else print 'ss command unavailable'; fi
    print '
[ END OF REPORT ]'
    print 'This report is a local snapshot. Review it before sharing; it may contain host and network details.'
  } >> "$outfile"
  local rc=$?
  (( rc == 0 )) || { print -P '%F{196}✖ Report generation failed.%f' >&2; return $rc; }
  print -P "%F{82}✓ Report created:%f %F{87}${outfile}%f"
  print -P '%F{244}Local, read-only collection · inspect before sharing.%f'
}

hnfind() {
  emulate -L zsh
  (( $# >= 1 && $# <= 2 )) || { print -P '%F{196}✖ Usage:%f %F{87}hnfind <text> [path]%f' >&2; return 2; }
  local target="${2:-.}"
  if (( $+commands[rg] )); then command rg --color=always --line-number --smart-case -- "$1" "$target"
  else command grep --color=always -RInE --exclude-dir=.git -- "$1" "$target"
  fi
}


# PRISM X 2.8 — Smart Output Intelligence.
# Explicit, read-only classifier for saved command output or a pipe; no command hooks.
hnoutput() {
  emulate -L zsh
  (( $# <= 1 )) || { print -P '%F{196}✖ Usage:%f %F{87}hnoutput [file|-]%f' >&2; return 2; }
  local source="${1:--}"
  if [[ "$source" != '-' && ! -f "$source" ]]; then
    print -P "%F{196}✖ File not found:%f %F{220}${source}%f" >&2
    return 2
  fi
  if [[ "$source" == '-' && -t 0 ]]; then
    print -P '%F{196}✖ No piped input.%f %F{244}Use: command 2>&1 | hnoutput -%f' >&2
    return 2
  fi
  local awk_program='
    function paint(code, text) { printf "\033[%sm%s\033[0m\n", code, text }
    {
      line=$0; low=tolower(line)
      if (low ~ /(^|[^a-z])(fatal|critical|panic|segmentation fault|permission denied|access denied|authentication failed)([^a-z]|$)/) { paint("1;31", "✖ " line); critical++; next }
      if (low ~ /(error:|(^|[^[:alpha:]])error([^[:alpha:]]|$)|failed|failure|not found|no such file|connection refused|timed out|traceback)/) { paint("31", "! " line); errors++; next }
      if (low ~ /(warning|deprecated|insecure|untrusted|weak cipher|certificate verify)/) { paint("1;33", "▲ " line); warnings++; next }
      if (low ~ /(success|passed|ready|connected|listening|completed|active \(running\))/) { paint("1;32", "✓ " line); success++; next }
      if (low ~ /(debug|trace|verbose)/) { paint("90", "· " line); debug++; next }
      if (low ~ /(info:|(^|[^[:alpha:]])info([^[:alpha:]]|$)|notice|starting|initializing|processing)/) { paint("36", "◆ " line); info++; next }
      paint("37", "  " line); other++
    }
    END {
      printf "\n\\033[1;36mCOMMAND CENTER OUTPUT TRIAGE\\033[0m  "
      printf "\\033[1;31mcritical %d\\033[0m  ", critical
      printf "\\033[31merrors %d\\033[0m  ", errors
      printf "\\033[1;33mwarnings %d\\033[0m  ", warnings
      printf "\\033[1;32msuccess %d\\033[0m  ", success
      printf "\\033[36minfo %d\\033[0m  ", info
      printf "\\033[90mdebug %d\\033[0m  ", debug
      printf "\\033[37mother %d\\033[0m\n", other
    }
  '
  if [[ "$source" == '-' ]]; then command awk "$awk_program"
  else command awk "$awk_program" -- "$source"; fi
}


# PRISM X 2.9 — network-output intelligence (passive text analysis only).
# Highlights indicators already present in a file/pipe; performs no scans or connections.
hnnet() {
  emulate -L zsh
  (( $# <= 1 )) || { print -P '%F{196}✖ Usage:%f %F{87}hnnet [file|-]%f' >&2; return 2; }
  local source="${1:--}"
  if [[ "$source" != '-' && ! -f "$source" ]]; then
    print -P "%F{196}✖ File not found:%f %F{220}${source}%f" >&2
    return 2
  fi
  if [[ "$source" == '-' && -t 0 ]]; then
    print -P '%F{196}✖ No piped input.%f %F{244}Use: command 2>&1 | hnnet -%f' >&2
    return 2
  fi
  local awk_program='
    function paint(code, marker, text) { printf "\033[%sm%s%s\033[0m\n", code, marker, text }
    {
      line=$0; low=tolower(line); kind="other"; code="37"; marker="  "
      if (low ~ /(denied|blocked|drop(ped)?|reject(ed)?|firewall|acl deny)/) { kind="security"; code="1;31"; marker="! " }
      else if (low ~ /[0-9][0-9]?[0-9]?[0-9]?[.][0-9][0-9]?[0-9]?[0-9]?[.][0-9][0-9]?[0-9]?[0-9]?[.][0-9][0-9]?[0-9]?[0-9]?/) { kind="address"; code="1;96"; marker="⌁ " }
      else if (low ~ /(port[ =:]|:[0-9][0-9]?[0-9]?[0-9]?[0-9]?([^0-9]|$)|listening)/) { kind="port"; code="35"; marker="◉ " }
      else if (low ~ /(tcp|udp|icmp|http\/|https|ssh|dns|ftp|smtp|tls|ssl|quic)/) { kind="protocol"; code="36"; marker="◆ " }
      else if (low ~ /(route|gateway|interface|vlan|subnet|netmask|neighbor|mac address|arp)/) { kind="network"; code="1;34"; marker="◇ " }
      if (kind=="security") security++
      else if (kind=="protocol") protocol++
      else if (kind=="address") address++
      else if (kind=="port") port++
      else if (kind=="network") network++
      else other++
      paint(code, marker, line)
    }
    END {
      printf "\n\033[1;36mCOMMAND CENTER NETWORK INTELLIGENCE\033[0m  "
      printf "\033[1;31msecurity %d\033[0m  ", security
      printf "\033[36mprotocol %d\033[0m  ", protocol
      printf "\033[1;96maddress %d\033[0m  ", address
      printf "\033[35mport %d\033[0m  ", port
      printf "\033[1;34mnetwork %d\033[0m  ", network
      printf "\033[37mother %d\033[0m\n", other
    }
  '
  if [[ "$source" == '-' ]]; then command awk "$awk_program"
  else command awk "$awk_program" -- "$source"; fi
}

# PRISM X 3.0 — protocol-aware operator report for existing text output.
# Heuristic, read-only analysis; never launches Nmap/TShark or opens sockets.
hnanalyze() {
  emulate -L zsh
  (( $# <= 1 )) || { print -P '%F{196}✖ Usage:%f %F{87}hnanalyze [file|-]%f' >&2; return 2; }
  local source="${1:--}"
  if [[ "$source" != '-' && ! -f "$source" ]]; then
    print -P "%F{196}✖ File not found:%f %F{220}${source}%f" >&2
    return 2
  fi
  if [[ "$source" == '-' && -t 0 ]]; then
    print -P '%F{196}✖ No piped input.%f %F{244}Use: nmap -oN - TARGET | hnanalyze -%f' >&2
    return 2
  fi
  local awk_program='
    function paint(code, mark, text) { printf "\033[%sm%s%s\033[0m\n", code, mark, text }
    {
      line=$0; low=tolower(line); kind="other"; code="37"; mark="  "
      if (low ~ /(authentication failure|failed password|invalid user|accepted (password|publickey)|session opened|session closed|sshd\[)/) {
        kind="ssh"; code=(low ~ /(failed|invalid|failure)/ ? "1;31" : "1;32"); mark="SSH "
      }
      else if (low ~ /(nmap scan report|host is up|not shown:|open\|filtered|^[[:space:]]*[0-9]+\/(tcp|udp)[[:space:]]+(open|closed|filtered)|service info:|os details:)/) {
        kind="nmap"; code=(low ~ /(filtered|closed)/ ? "1;33" : "1;96"); mark="NMAP "
      }
      else if (low ~ /(dns query|dns response|standard query|standard query response| qtype=| qclass=|domain name system)/) {
        kind="dns"; code="1;35"; mark="DNS "
      }
      else if (low ~ /(http\/1\.[01]|http\/2|"(get|post|put|delete|head|patch) |(^|[^[:alpha:]])(status|method|host|user-agent)=|(^|[[:space:]])[1-5][0-9][0-9]([[:space:]]|$))/) {
        kind="http"; code="36"; mark="HTTP "
      }
      else if (low ~ /(iptables|nftables|ufw|firewalld|firewall|packet dropped|drop IN=|reject IN=|blocked by|acl deny)/) {
        kind="firewall"; code="1;31"; mark="FW "
      }
      else if (low ~ /(tcp|udp|icmp|tls|ssl|quic|arp|vlan|gateway|interface)/) {
        kind="network"; code="1;34"; mark="NET "
      }
      count[kind]++; paint(code, mark, line)
    }
    END {
      printf "\n\033[1;36mHN//CIT COMMAND CENTER · OPERATOR INTELLIGENCE\033[0m\n"
      printf "\033[1;96mNmap %d\033[0m  ", count["nmap"]
      printf "\033[1;32mSSH %d\033[0m  ", count["ssh"]
      printf "\033[1;35mDNS %d\033[0m  ", count["dns"]
      printf "\033[36mHTTP %d\033[0m  ", count["http"]
      printf "\033[1;31mFirewall %d\033[0m  ", count["firewall"]
      printf "\033[1;34mNetwork %d\033[0m  ", count["network"]
      printf "\033[37mOther %d\033[0m\n", count["other"]
      printf "\033[90mClassification is heuristic; counts are matching lines, not unique events.\033[0m\n"
    }
  '
  if [[ "$source" == '-' ]]; then command awk "$awk_program"
  else command awk "$awk_program" -- "$source"; fi
}



# PRISM X 3.1 — Native-command presentation layer.
# Only interactive ZSH sessions load this file. Non-terminal output, pipes,
# redirections, command options and all unrelated subcommands use native tools.

# Terminal-friendly defaults for programs that already support color/pagers.
# Respect user-defined values; never force color into redirected output.
if [[ -z "${GREP_COLORS:-}" ]]; then
  export GREP_COLORS='mt=1;38;5;87:sl=38;5;244:cx=38;5;244:fn=38;5;141:ln=38;5;220:bn=38;5;39:se=38;5;244'
fi
if [[ -z "${LESS:-}" ]]; then export LESS='-R'; fi
if [[ -z "${SYSTEMD_PAGER:-}" ]]; then export SYSTEMD_PAGER='less -R'; fi
if [[ -z "${GIT_PAGER:-}" ]]; then export GIT_PAGER='less -R'; fi

# `cat FILE`: bat/batcat provides numbered, syntax-aware display only when
# the user is viewing files directly in a terminal. Pipes and options retain
# the exact native cat behavior.
cat() {
  emulate -L zsh
  if [[ -t 1 && -t 0 && $# -gt 0 ]]; then
    local arg
    local safe=1
    for arg in "$@"; do
      [[ "$arg" == -* || ! -f "$arg" ]] && { safe=0; break; }
    done
    if (( safe )); then
      if (( $+commands[batcat] )); then
        command batcat --color=always --paging=never --style=header,grid,numbers,changes -- "$@"
        return $?
      elif (( $+commands[bat] )); then
        command bat --color=always --paging=never --style=header,grid,numbers,changes -- "$@"
        return $?
      fi
    fi
  fi
  command cat "$@"
}

# Compact interface matrix behind the familiar `ip a` spelling.
# Every other `ip` invocation is passed unchanged to the system binary.
_prism_ip_address_view() {
  emulate -L zsh
  local family="${1:-}"
  (( $+commands[ip] )) || { print -P '%F{196}ip: command not found%f' >&2; return 127; }
  local raw
  raw=$(command ip -br ${family:+$family} addr show 2>&1) || { print -r -- "$raw"; return 1; }
  print -P '\n%F{51}╭─%f %F{141}NETWORK INTERFACE MATRIX%f'
  print -P '%F{51}│%f %F{244}NO.  INTERFACE             STATE       ADDRESS%f'
  print -P '%F{51}├────┼───────────────────────┼───────────┼──────────────────────────────────────────────%f'
  print -r -- "$raw" | command awk '
    BEGIN { FS="[[:space:]]+"; reset="\033[0m"; cyan="\033[96m"; green="\033[92m"; amber="\033[93m"; red="\033[91m"; blue="\033[94m"; n=0 }
    NF {
      iface=$1; state=$2; addr=""
      for (i=3;i<=NF;i++) addr=addr (addr=="" ? "" : "  ") $i
      if (state=="UP" || state=="UNKNOWN") sc=green; else if (state=="DOWN") sc=red; else sc=amber
      if (iface=="lo") ic=blue; else ic=cyan
      if (addr=="") addr="— no address —"
      printf "%s│%s %s%02d%s  %s%-21.21s%s %s│%s %s%-9s%s %s│%s %-44.44s %s│%s\n",cyan,reset,cyan,++n,reset,ic,iface,reset,cyan,reset,sc,state,reset,cyan,reset,addr,cyan,reset
    }
    END { printf "%s├────┴───────────────────────┴───────────┴──────────────────────────────────────────────┤%s\n",cyan,reset; printf "%s│%s %s%d interface(s)%s\n",cyan,reset,green,n,reset; printf "%s╰─────────────────────────────────────────────────────────────────────────────────────────╯%s\n",cyan,reset }
  '
}

# Compact route matrix for the exact, read-only `ip route` display forms.
# More complex arguments and all mutating ip commands always use native ip.
_prism_ip_route_view() {
  emulate -L zsh
  local family="${1:-}"
  (( $+commands[ip] )) || { print -P '%F{196}ip: command not found%f' >&2; return 127; }
  local raw
  if [[ -n "$family" ]]; then raw=$(command ip "$family" route show 2>&1)
  else raw=$(command ip route show 2>&1); fi
  local rc=$?
  (( rc == 0 )) || { print -r -- "$raw"; return $rc; }
  print -P '\n%F{51}╭─%f %F{141}ROUTING TABLE / PATH MATRIX%f'
  print -P '%F{51}│%f %F{244}NO.  DESTINATION          GATEWAY             DEVICE       SOURCE / DETAILS%f'
  print -P '%F{51}├────┼───────────────────────┼─────────────────────┼──────────────┼────────────────────────%f'
  print -r -- "$raw" | command awk '
    BEGIN { FS="[[:space:]]+"; c="\033[96m"; g="\033[92m"; a="\033[93m"; r="\033[0m"; n=0 }
    NF {
      dest=$1; via="—"; dev="—"; details=""
      for(i=2;i<=NF;i++) {
        if($i=="via" && i<NF) via=$(i+1)
        else if($i=="dev" && i<NF) dev=$(i+1)
        else if($i=="src" && i<NF) details=details (details?" ":"") "src " $(i+1)
        else if($i=="proto" && i<NF) details=details (details?" ":"") "proto " $(i+1)
        else if($i=="metric" && i<NF) details=details (details?" ":"") "metric " $(i+1)
      }
      if(dest=="default") dc=a; else dc=g
      printf "%s│%s %s%02d%s  %s%-21.21s%s %-19.19s %-12.12s %-24.24s %s│%s\n",c,r,c,++n,r,dc,dest,r,via,dev,details,c,r
    }
    END { printf "%s├────┴───────────────────────┴─────────────────────┴──────────────┴────────────────────────┤%s\n",c,r; printf "%s│%s %s%d route(s)%s\n",c,r,g,n,r; printf "%s╰──────────────────────────────────────────────────────────────────────────────────────────╯%s\n",c,r }
  '
}

# Neighbor/ARP cache view. This only reads the local kernel neighbor table.
_prism_ip_neigh_view() {
  emulate -L zsh
  local family="${1:-}"
  (( $+commands[ip] )) || { print -P '%F{196}ip: command not found%f' >&2; return 127; }
  local raw
  if [[ -n "$family" ]]; then raw=$(command ip "$family" neigh show 2>&1)
  else raw=$(command ip neigh show 2>&1); fi
  local rc=$?
  (( rc == 0 )) || { print -r -- "$raw"; return $rc; }
  print -P '\n%F{51}╭─%f %F{141}NEIGHBOR / ARP CACHE MATRIX%f'
  print -P '%F{51}│%f %F{244}NO.  ADDRESS                 DEVICE       LINK ADDRESS          STATE%f'
  print -P '%F{51}├────┼─────────────────────────┼──────────────┼───────────────────────┼────────────%f'
  print -r -- "$raw" | command awk '
    BEGIN { FS="[[:space:]]+"; c="\033[96m"; g="\033[92m"; a="\033[93m"; red="\033[91m"; r="\033[0m"; n=0 }
    NF {
      addr=$1; dev="—"; mac="—"; state=$NF
      for(i=2;i<=NF;i++) { if($i=="dev" && i<NF) dev=$(i+1); if($i=="lladdr" && i<NF) mac=$(i+1) }
      sc=g; if(state ~ /FAILED|INCOMPLETE|NOARP/) sc=red; else if(state ~ /STALE|DELAY|PROBE/) sc=a
      printf "%s│%s %s%02d%s  %-23.23s %-12.12s %-21.21s %s%-10s%s %s│%s\n",c,r,c,++n,r,addr,dev,mac,sc,state,r,c,r
    }
    END { printf "%s├────┴─────────────────────────┴──────────────┴───────────────────────┴────────────┤%s\n",c,r; printf "%s│%s %s%d neighbor(s)%s\n",c,r,g,n,r; printf "%s╰───────────────────────────────────────────────────────────────────────────────────╯%s\n",c,r }
  '
}

ip() {
  emulate -L zsh
  if (( $# == 1 )) && [[ "$1" == a || "$1" == addr || "$1" == address ]]; then
    _prism_ip_address_view; return $?
  fi
  if (( $# == 2 )) && [[ "$1" == -4 || "$1" == -6 ]] && [[ "$2" == a || "$2" == addr || "$2" == address ]]; then
    _prism_ip_address_view "$1"; return $?
  fi
  if (( $# == 1 )) && [[ "$1" == route || "$1" == r ]]; then
    _prism_ip_route_view; return $?
  fi
  if (( $# == 2 )) && [[ "$1" == -4 || "$1" == -6 ]] && [[ "$2" == route || "$2" == r ]]; then
    _prism_ip_route_view "$1"; return $?
  fi
  if (( $# == 1 )) && [[ "$1" == neigh || "$1" == neighbor ]]; then
    _prism_ip_neigh_view; return $?
  fi
  if (( $# == 2 )) && [[ "$1" == -4 || "$1" == -6 ]] && [[ "$2" == neigh || "$2" == neighbor ]]; then
    _prism_ip_neigh_view "$1"; return $?
  fi
  if (( $# == 2 )) && [[ "$1" == route || "$1" == r ]] && [[ "$2" == show ]]; then
    _prism_ip_route_view; return $?
  fi
  if (( $# == 2 )) && [[ "$1" == neigh || "$1" == neighbor ]] && [[ "$2" == show ]]; then
    _prism_ip_neigh_view; return $?
  fi
  command ip "$@"
}


# PRISM X 3.2 — native system-output presentation.
# These wrappers keep the original command and arguments. They only add ANSI
# emphasis for direct interactive output; pipes/redirections stay byte-for-byte
# with the native command output. No aliases or replacements for command names.

_prism_color_stream() {
  emulate -L zsh
  local mode="$1"
  command awk -v mode="$mode" '
    BEGIN {
      r="\033[0m"; cyan="\033[1;36m"; green="\033[1;32m";
      amber="\033[1;33m"; red="\033[1;31m"; blue="\033[1;34m";
      muted="\033[90m"; white="\033[1;37m"; n=0
    }
    {
      line=$0; low=tolower(line)
      if (NR==1 && mode!="du") {
        printf "%s%s%s\n", cyan, line, r
        printf "%s%s%s\n", muted, "────────────────────────────────────────────────────────────────────────", r
        next
      }
      n++
      if (mode=="ps") {
        if (line ~ /(^|[[:space:]])(Z|Z\+|D)([[:space:]]|$)/) c=red
        else if (low ~ /root/) c=amber
        else c=green
      } else if (mode=="df") {
        pct=""
        for (i=1;i<=NF;i++) if ($i ~ /^[0-9]+%$/) pct=$i
        v=pct; sub(/%/,"",v)
        if (v+0 >= 90) c=red; else if (v+0 >= 75) c=amber; else c=green
      } else if (mode=="free") {
        if (low ~ /^mem:/) c=cyan
        else if (low ~ /^swap:/) c=amber
        else c=blue
      } else if (mode=="ss") {
        if (low ~ /listen/) c=amber
        else if (low ~ /estab/) c=green
        else if (low ~ /time-wait|close-wait|syn-sent|syn-recv/) c=red
        else c=blue
      } else if (mode=="du") {
        # du -h: compare the leading human-readable size conservatively.
        size=$1; num=size; unit=substr(size,length(size),1); sub(/[A-Za-z]$/, "", num)
        if (unit=="G" || unit=="T") c=amber; else c=green
      } else c=white
      printf "%s%02d%s %s%s%s\n", muted, n, r, c, line, r
    }
    END {
      printf "%s────────────────────────────────────────────────────────────────────────%s\n", muted, r
      printf "%sCOMMAND CENTER VIEW%s  %s%d data row(s)%s\n", cyan, r, white, n, r
    }
  '
}

ps() {
  emulate -L zsh
  if [[ -t 1 && -t 0 ]]; then
    command ps "$@" | _prism_color_stream ps
    return ${pipestatus[1]}
  fi
  command ps "$@"
}

df() {
  emulate -L zsh
  if [[ -t 1 && -t 0 ]]; then
    command df "$@" | _prism_color_stream df
    return ${pipestatus[1]}
  fi
  command df "$@"
}

free() {
  emulate -L zsh
  if [[ -t 1 && -t 0 ]]; then
    command free "$@" | _prism_color_stream free
    return ${pipestatus[1]}
  fi
  command free "$@"
}

ss() {
  emulate -L zsh
  if [[ -t 1 && -t 0 ]]; then
    command ss "$@" | _prism_color_stream ss
    return ${pipestatus[1]}
  fi
  command ss "$@"
}

# `du` receives a compact severity color pass only for direct terminal output.
# Arguments remain untouched; pipes and redirected output stay native.
du() {
  emulate -L zsh
  if [[ -t 1 && -t 0 ]]; then
    command du "$@" | _prism_color_stream du
    return ${pipestatus[1]}
  fi
  command du "$@"
}

# Directory listing presentation. The system binaries and all arguments remain intact.
# Color is added only for a real interactive terminal; pipes/redirections stay native.
ls() {
  emulate -L zsh
  if [[ -t 1 && -t 0 ]]; then command ls --color=auto --group-directories-first "$@"
  else command ls "$@"
  fi
}

tree() {
  emulate -L zsh
  if (( ! $+commands[tree] )); then
    print -P '%F{196}✖ tree is not installed.%f %F{244}Use find, or install tree separately if desired.%f' >&2
    return 127
  fi
  if [[ -t 1 && -t 0 ]]; then command tree -C "$@"
  else command tree "$@"
  fi
}

# PRISM X 3.5 — command discovery and safe history inspection.
# Both helpers are read-only. They never rewrite ~/.zsh_history or execute results.
# PRISM X 3.8 — one-shot host and service intelligence.
# These commands are explicitly invoked, read-only snapshots: no daemon, polling,
# service changes, container starts/stops, or network discovery.
hnhealth() {
  emulate -L zsh
  local hostname kernel uptime_line cpu_model mem_total mem_available mem_used root_usage load
  hostname="$(command hostname 2>/dev/null || print unknown)"
  kernel="$(command uname -sr 2>/dev/null || print unknown)"
  uptime_line="$(command uptime -p 2>/dev/null || command uptime 2>/dev/null || print unknown)"
  cpu_model="$(command awk -F: '/^model name[[:space:]]*:/ {sub(/^[[:space:]]+/, "", $2); print $2; exit}' /proc/cpuinfo 2>/dev/null)"
  [[ -n "$cpu_model" ]] || cpu_model="$(command uname -m 2>/dev/null || print unknown)"
  mem_total="$(command awk '/^MemTotal:/ {printf "%.1f GiB", $2/1048576}' /proc/meminfo 2>/dev/null)"
  mem_available="$(command awk '/^MemAvailable:/ {printf "%.1f GiB", $2/1048576}' /proc/meminfo 2>/dev/null)"
  mem_used="$(command awk '/^MemTotal:/ {t=$2} /^MemAvailable:/ {a=$2} END {if(t>0) printf "%.1f%%", (t-a)*100/t}' /proc/meminfo 2>/dev/null)"
  root_usage="$(command df -P -h / 2>/dev/null | command awk 'NR==2 {print $5 " used · " $4 " free"}')"
  load="$(command awk '{print $1 " / " $2 " / " $3}' /proc/loadavg 2>/dev/null)"
  _hn_section 'SYSTEM HEALTH / ONE-SHOT SNAPSHOT'
  _hn_kv 'Host' "$hostname"
  _hn_kv 'Kernel' "$kernel"
  _hn_kv 'Uptime' "$uptime_line"
  _hn_kv 'CPU' "$cpu_model"
  _hn_kv 'Load 1/5/15' "${load:-unavailable}"
  _hn_kv 'Memory' "${mem_used:-unavailable} used · ${mem_total:-unknown} total · ${mem_available:-unknown} available"
  _hn_kv 'Root filesystem' "${root_usage:-unavailable}"
  print -P '%F{244}Read-only snapshot · refreshed only when this command is run.%f\n'
}

hnservices() {
  emulate -L zsh
  local filter="${(j: :)@}" output rc
  (( $+commands[systemctl] )) || { print -P '%F{196}systemctl is unavailable on this system.%f' >&2; return 127; }
  output="$(command systemctl list-units --type=service --all --no-legend --no-pager 2>&1)"
  rc=$?
  (( rc == 0 )) || { print -r -- "$output"; return $rc; }
  _hn_section 'SYSTEM SERVICES / READ-ONLY INVENTORY'
  if [[ -n "$filter" ]]; then
    output="$(print -r -- "$output" | command grep -F -i -- "$filter")"
    rc=$?
    if (( rc > 1 )); then print -P '%F{196}Unable to filter service inventory.%f' >&2; return $rc; fi
  fi
  if [[ -z "$output" ]]; then
    print -P '%F{220}No matching services found.%f'
    return 0
  fi
  print -r -- "$output" | command awk '
    BEGIN {r="\033[0m"; c="\033[96m"; g="\033[92m"; a="\033[93m"; red="\033[91m"; n=0}
    { n++; low=tolower($0); color=g; if(low ~ /failed/) color=red; else if(low ~ /activating|deactivating|maintenance/) color=a; printf "%s%03d%s  %s%s%s\n", c,n,r,color,$0,r }
    END {printf "\033[96mSERVICE INVENTORY\033[0m  %d row(s)\n",n}
  '
}

hncontainers() {
  emulate -L zsh
  local engine found=0 output rc
  for engine in docker podman; do
    if (( $+commands[$engine] )); then
      found=1
      _hn_section "CONTAINERS / ${engine:u} · READ-ONLY"
      output="$(command "$engine" ps -a --no-trunc --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' 2>&1)"
      rc=$?
      if (( rc == 0 )); then
        print -r -- "$output" | command awk '
          BEGIN {r="\033[0m"; c="\033[96m"; g="\033[92m"; a="\033[93m"; red="\033[91m"; n=0}
          NR==1 {printf "%s%s%s\n",c,$0,r; next}
          {n++; low=tolower($0); color=g; if(low ~ /exited|dead|created/) color=red; else if(low ~ /restarting|paused/) color=a; printf "%s%03d%s  %s%s%s\n",c,n,r,color,$0,r}
          END {printf "\033[96mCONTAINER INVENTORY\033[0m  %d container(s)\n",n}
        '
      else
        print -P "%F{220}${engine} is installed but its service/context is unavailable:%f"
        print -r -- "$output"
      fi
    fi
  done
  if (( ! found )); then
    print -P '%F{220}Neither Docker nor Podman is installed. No packages were installed.%f'
    return 127
  fi
}

hnsearch() {
  emulate -L zsh
  local query="$*" entry name description qlow shown=0
  qlow="${query:l}"
  local -a catalogue
  catalogue=(
    'ls|List files and directories'
    'cat|Display file contents (PRISM syntax view in interactive terminal)'
    'ip a|Show network interfaces and addresses'
    'ps|List running processes'
    'df -h|Show filesystem capacity'
    'free -h|Show memory and swap usage'
    'ss -tuln|Show listening network sockets'
    'du -sh *|Summarize directory sizes'
    'grep|Search text using patterns'
    'find|Locate files and directories'
    'journalctl|Inspect systemd journal logs'
    'systemctl|Inspect and manage system services'
    'nmap|Network discovery and service enumeration'
    'tcpdump|Capture and inspect network packets'
    'ssh|Connect to remote systems securely'
    'git|Version control and project history'
    'docker|Manage containers and images'
    'python3|Run Python programs'
    'hnprism|Show current operator session context'
    'hnstatus|Show compact system snapshot'
    'hnops|Show detected tools and session state'
    'hnports|Show listening socket overview'
    'hnproc|Show top processes by CPU'
    'hnfiles|Browse files with semantic indicators'
    'hncat|Open a numbered structured file view'
    'hnlog|Read and classify a log file'
    'hnjson|Format JSON using optional jq'
    'hnyaml|Format YAML using optional yq'
    'hnreport|Generate a local system/network report'
    'hnoutput|Classify command output from stdin or file'
    'hnnet|Highlight network-related output'
    'hnanalyze|Classify common security/network text'
    'hnhistory|Read recent shell history'
    'hnhistory-search|Search recent commands with FZF; selection is not executed'
    'hnsuggest|Suggest commands based on current project context'
    'hnexplain|Explain common error messages without executing commands'
    'hnwhy|Explain the last command exit status'
    'hnhealth|Show a one-shot system health snapshot'
    'hnservices|List systemd services, optionally filtered'
    'hncontainers|List Docker or Podman containers (read-only)'
  )
  _hn_section 'COMMAND DISCOVERY / CATALOGUE'
  [[ -n "$query" ]] && print -P "%F{244}Filter:%f %F{87}${query}%f" || print -P '%F{244}Showing available native commands and COMMAND CENTER utilities.%f'
  for entry in "${catalogue[@]}"; do
    name="${entry%%|*}"; description="${entry#*|}"
    if [[ -z "$query" || "${entry:l}" == *"$qlow"* ]]; then
      (( shown++ ))
      printf '\033[90m%02d\033[0m  \033[1;36m%-16s\033[0m  \033[37m%s\033[0m\n' "$shown" "$name" "$description"
    fi
  done
  (( shown )) || print -P '%F{220}No matching command in the local catalogue.%f'
  print -P "\n%F{51}╰─%f %F{244}${shown} matching entr(y/ies) · search only, nothing is executed%f\n"
}

hnhistory() {
  emulate -L zsh
  local limit="${1:-30}"
  [[ "$limit" == <-> ]] && (( limit >= 1 && limit <= 200 )) || {
    print -P '%F{196}Usage:%f %F{87}hnhistory [1..200]%f' >&2; return 2
  }
  _hn_section "RECENT SHELL HISTORY / LAST ${limit} COMMANDS"
  # `fc` reads the current ZSH history list; no history file is edited or cleared.
  builtin fc -l -n -"$limit" 2>/dev/null | command awk '
    BEGIN { reset="\033[0m"; muted="\033[90m"; cyan="\033[96m"; white="\033[37m"; n=0 }
    NF { n++; printf "%s%03d%s  %s%s%s\n", muted,n,reset,cyan,$0,reset }
    END { printf "\n%sHISTORY VIEW%s  %s%d command(s)%s\n",cyan,reset,white,n,reset }
  '
}

# Readability defaults for man/systemd output. Existing user choices win.
if [[ -z "${MANPAGER:-}" ]] && (( $+commands[less] )); then
  export MANPAGER='less -R'
fi
if [[ -z "${SYSTEMD_COLORS:-}" ]]; then export SYSTEMD_COLORS=1; fi

# Zsh completion menu uses the same PRISM semantic palette; no plugin needed.
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:descriptions' format '%F{141}── %d ──%f'
zstyle ':completion:*:messages' format '%F{220}── %d ──%f'
zstyle ':completion:*:warnings' format '%F{196}No matches for: %d%f'
zstyle ':completion:*' list-prompt '%F{51}Completion %p%f'
zstyle ':completion:*' select-prompt '%F{51}Select: %p%f'
