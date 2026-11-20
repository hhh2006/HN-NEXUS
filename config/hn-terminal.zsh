# HN NEXUS — HN//CIT COMMAND CENTER | Adaptive Terminal Engine v4.4.2
# ZSH-native, low overhead. No daemon, polling loop, or external telemetry service.
[[ -o interactive ]] || return 0

autoload -Uz add-zsh-hook vcs_info
zmodload zsh/datetime 2>/dev/null || true
unsetopt PROMPT_SUBST  # HUD is rendered in precmd; ZLE history redraw stays stable

# Truecolor palette: cyan / sapphire / violet / magenta / emerald / rose (no warm yellow/orange).
typeset -g HN_C_CYAN='%F{51}' HN_C_ICE='%F{87}' HN_C_BLUE='%F{39}'
typeset -g HN_C_VIOLET='%F{141}' HN_C_MAGENTA='%F{201}' HN_C_PINK='%F{205}'
typeset -g HN_C_AMBER='%F{87}' HN_C_GREEN='%F{82}' HN_C_RED='%F{196}'
typeset -g HN_C_WHITE='%F{255}' HN_C_MUTED='%F{244}' HN_C_RESET='%f'

typeset -g HN_LAST_STATUS=0 HN_LAST_DURATION='' HN_LAST_COMMAND='SYSTEM ONLINE'
typeset -gF HN_CMD_START=0
typeset -g HN_GIT_SEGMENT='' HN_ENV_SEGMENT='' HN_REMOTE_SEGMENT=''
# Nerd Font identity pack. Probe common Nerd Font families once at shell load.
# This supports JetBrainsMono, JetBrainsMonoNL, FiraCode, Hack and Meslo packs.
typeset -g HN_NERD_FONT_READY=0 HN_NERD_FONT_FAMILY=''
if (( $+commands[fc-match] )); then
  typeset _hn_family _hn_candidate
  for _hn_candidate in 'JetBrainsMono Nerd Font Mono' 'JetBrainsMonoNL Nerd Font Mono' 'FiraCode Nerd Font Mono' 'Hack Nerd Font Mono' 'MesloLGS Nerd Font Mono'; do
    _hn_family=$(fc-match -f '%{family}' "$_hn_candidate" 2>/dev/null)
    if [[ "${_hn_family:l}" == *'nerd font'* ]]; then
      HN_NERD_FONT_READY=1
      HN_NERD_FONT_FAMILY="$_hn_family"
      break
    fi
  done
  unset _hn_family _hn_candidate
fi

if (( HN_NERD_FONT_READY )); then
  # Nerd Font glyphs: Linux/Kali, DevIcons, Font Awesome and Material Design.
  typeset -g HN_KALI_ICON=$'\uf327' HN_USER_ICON=$'\uf007' HN_FOLDER_ICON=$'\uf07b'
  typeset -g HN_CONSOLE_ICON=$'\uf120' HN_GIT_ICON=$'\ue725' HN_PY_ICON=$'\ue73c'
  typeset -g HN_SSH_ICON=$'\uf489' HN_OK_ICON=$'\uf00c' HN_FAIL_ICON=$'\uf00d' HN_ROOT_ICON=$'\uf023'
  typeset -g HN_PROMPT_ICON=$'\uf054' HN_PROJECT_ICON=$'\uf1b2' HN_NETWORK_ICON=$'\uf1eb'
  typeset -g HN_SECURITY_ICON=$'\uf21b' HN_DOCKER_ICON=$'\uf308' HN_CODE_ICON=$'\ue7a8'
  typeset -g HN_DATABASE_ICON=$'\uf1c0' HN_LOG_ICON=$'\uf15c' HN_CLOUD_ICON=$'\uf0c2'
  typeset -g HN_CLOCK_ICON=$'\uf017' HN_BRANCH_ICON=$'\ue0a0' HN_LOCK_ICON=$'\uf023' HN_BOLT_ICON=$'\uf0e7' HN_WARN_ICON=$'\uf071'
else
  typeset -g HN_KALI_ICON='◈' HN_USER_ICON='◉' HN_FOLDER_ICON='⌂'
  typeset -g HN_CONSOLE_ICON='$_' HN_GIT_ICON='⑂' HN_PY_ICON='Py'
  typeset -g HN_SSH_ICON='⇄' HN_OK_ICON='✓' HN_FAIL_ICON='✕' HN_ROOT_ICON='◆'
  typeset -g HN_PROMPT_ICON='❯' HN_PROJECT_ICON='◇' HN_NETWORK_ICON='⌁'
  typeset -g HN_SECURITY_ICON='⌬' HN_DOCKER_ICON='▣' HN_CODE_ICON='⌘'
  typeset -g HN_DATABASE_ICON='▤' HN_LOG_ICON='≡' HN_CLOUD_ICON='☁'
  typeset -g HN_CLOCK_ICON='◷' HN_BRANCH_ICON='⑂' HN_LOCK_ICON='◇' HN_BOLT_ICON='ϟ' HN_WARN_ICON='!'
fi

typeset -g HN_CONTEXT_ICON='◇' HN_CONTEXT_LABEL='FIELD CONSOLE'
typeset -g HN_ACTION_ICON='⌘'
typeset -g HN_STATUS_ICON="$HN_OK_ICON" HN_STATUS_LABEL='READY'
typeset -gi HN_PALETTE_INDEX=0 HN_COMMAND_COUNT=0
typeset -g HN_PALETTE_NAME='EMERALD PULSE' HN_RAIL_START='24;220;170' HN_RAIL_MID='40;160;235' HN_RAIL_END='155;105;245'

# Git checks run only when vcs_info detects a repository.
# Keep branch detection light; dirty checks are opt-in for large repositories.
zstyle ':vcs_info:git:*' check-for-changes ${HN_GIT_DIRTY:-false}
zstyle ':vcs_info:git:*' stagedstr '●'
zstyle ':vcs_info:git:*' unstagedstr '✚'
zstyle ':vcs_info:git:*' formats '%b%c%u'
zstyle ':vcs_info:git:*' actionformats '%b%c%u|%a'
zstyle ':vcs_info:*' enable git

# Rebuild at each prompt so the spectrum adapts after terminal resizing.
_hn_gradient_rail() {
  emulate -L zsh
  local count=${1:-$(( ${COLUMNS:-80} - 1 ))}
  local i pos seg off r g b esc rail=''
  local -a c1 c2 c3 rr gg bb
  c1=(${(s:;:)HN_RAIL_START}); c2=(${(s:;:)HN_RAIL_MID}); c3=(${(s:;:)HN_RAIL_END})
  rr=($c1[1] $c2[1] $c3[1]); gg=($c1[2] $c2[2] $c3[2]); bb=($c1[3] $c2[3] $c3[3])
  (( count < 1 )) && return 0
  for (( i=0; i<count; i++ )); do
    pos=$(( count == 1 ? 0 : i*1000/(count-1) ))
    seg=$(( pos/500 )); (( seg > 1 )) && seg=1
    off=$(( pos-seg*500 ))
    r=$(( rr[seg+1]+(rr[seg+2]-rr[seg+1])*off/500 ))
    g=$(( gg[seg+1]+(gg[seg+2]-gg[seg+1])*off/500 ))
    b=$(( bb[seg+1]+(bb[seg+2]-bb[seg+1])*off/500 ))
    esc=$'\e[1;38;2;'${r}';'${g}';'${b}'m'
    rail+="%{${esc}%}─"
  done
  local reset=$'\e[0m'
  print -rn -- "${rail}%{${reset}%}"
}

_hn_context() {
  emulate -L zsh
  local full="${PWD:A}" base="${PWD:t:l}" normalized="${PWD:A:l}/"
  [[ "$full" == '/' ]] && base='/'
  HN_CONTEXT_ICON="${HN_CODE_ICON:-◇}"; HN_CONTEXT_LABEL='ACTIVE DIR'

  # Friendly locations. No inference from username or hostname.
  case "$base" in
    /) HN_CONTEXT_ICON='⌂'; HN_CONTEXT_LABEL='ROOT' ;;
    desktop) HN_CONTEXT_ICON='▦'; HN_CONTEXT_LABEL='DESKTOP' ;;
    downloads) HN_CONTEXT_ICON='↓'; HN_CONTEXT_LABEL='DOWNLOADS' ;;
    documents) HN_CONTEXT_ICON='▤'; HN_CONTEXT_LABEL='DOCUMENTS' ;;
    pictures|images|visual_assets|visual-assets) HN_CONTEXT_ICON='▧'; HN_CONTEXT_LABEL='VISUAL ASSETS' ;;
    projects|workspace|work) HN_CONTEXT_ICON="${HN_PROJECT_ICON}"; HN_CONTEXT_LABEL='PROJECT' ;;
    labs|lab|virtual-labs) HN_CONTEXT_ICON="${HN_SECURITY_ICON}"; HN_CONTEXT_LABEL='SECURITY LAB' ;;
    ctf|challenges) HN_CONTEXT_ICON='⚑'; HN_CONTEXT_LABEL='CTF OPS' ;;
    reports|report) HN_CONTEXT_ICON="${HN_DATABASE_ICON}"; HN_CONTEXT_LABEL='REPORTS' ;;
    scripts|tools) HN_CONTEXT_ICON="${HN_CODE_ICON}"; HN_CONTEXT_LABEL='SCRIPTS' ;;
    wordlists|wordlist) HN_CONTEXT_ICON='▦'; HN_CONTEXT_LABEL='WORDLIST REPOSITORY' ;;
    payloads|payload) HN_CONTEXT_ICON='◆'; HN_CONTEXT_LABEL='PAYLOAD WORKSPACE' ;;
    logs|log) HN_CONTEXT_ICON="${HN_LOG_ICON}"; HN_CONTEXT_LABEL='LOG ANALYSIS' ;;
    .ssh|ssh) HN_CONTEXT_ICON="${HN_SSH_ICON}"; HN_CONTEXT_LABEL='SSH' ;;
    .config|config) HN_CONTEXT_ICON='⚙'; HN_CONTEXT_LABEL='CONFIGURATION' ;;
    node_modules) HN_CONTEXT_ICON='◇'; HN_CONTEXT_LABEL='NODE DEPENDENCIES' ;;
    venv|.venv) HN_CONTEXT_ICON='Py'; HN_CONTEXT_LABEL='PYTHON ENVIRONMENT' ;;
    docker) HN_CONTEXT_ICON="${HN_DOCKER_ICON}"; HN_CONTEXT_LABEL='DOCKER' ;;
    kubernetes|k8s) HN_CONTEXT_ICON='⎈'; HN_CONTEXT_LABEL='KUBERNETES' ;;
  esac

  # Recognize named workspaces by complete path components only.
  case "$normalized" in
    */metasploit/*|*/exploitation-lab/*) HN_CONTEXT_ICON='⚑'; HN_CONTEXT_LABEL='EXPLOITATION LAB' ;;
    */burp*/*|*/web-security/*) HN_CONTEXT_ICON='◎'; HN_CONTEXT_LABEL='WEB SECURITY' ;;
    */nmap/*|*/network-recon/*) HN_CONTEXT_ICON="${HN_NETWORK_ICON}"; HN_CONTEXT_LABEL='NETWORK RECON' ;;
    */wireshark/*|*/pcap/*|*/packet-analysis/*) HN_CONTEXT_ICON='≋'; HN_CONTEXT_LABEL='PACKET ANALYSIS' ;;
    */ctf/*|*/challenges/*) HN_CONTEXT_ICON='⚑'; HN_CONTEXT_LABEL='CTF OPS' ;;
    */wordlists/*) HN_CONTEXT_ICON='▦'; HN_CONTEXT_LABEL='WORDLIST REPOSITORY' ;;
    */payloads/*) HN_CONTEXT_ICON='◆'; HN_CONTEXT_LABEL='PAYLOAD WORKSPACE' ;;
    */var/log/*|*/logs/*) HN_CONTEXT_ICON="${HN_LOG_ICON}"; HN_CONTEXT_LABEL='LOG ANALYSIS' ;;
    */docker/*) HN_CONTEXT_ICON="${HN_DOCKER_ICON}"; HN_CONTEXT_LABEL='DOCKER' ;;
    */kubernetes/*|*/k8s/*) HN_CONTEXT_ICON='⎈'; HN_CONTEXT_LABEL='KUBERNETES ENVIRONMENT' ;;
    */reports/*|*/report/*) HN_CONTEXT_ICON="${HN_DATABASE_ICON}"; HN_CONTEXT_LABEL='REPORTS' ;;
  esac

  # Current-directory manifests are stronger evidence than folder labels.
  if [[ -f "$PWD/pyproject.toml" || -f "$PWD/requirements.txt" || -f "$PWD/Pipfile" || -f "$PWD/environment.yml" || -f "$PWD/uv.lock" || -f "$PWD/poetry.lock" ]]; then
    HN_CONTEXT_ICON="${HN_PY_ICON}"; HN_CONTEXT_LABEL='PYTHON'
  elif [[ -f "$PWD/package.json" ]]; then
    HN_CONTEXT_ICON='⬡'; HN_CONTEXT_LABEL='NODE'
  elif [[ -f "$PWD/docker-compose.yml" || -f "$PWD/docker-compose.yaml" || -f "$PWD/compose.yml" || -f "$PWD/compose.yaml" || -f "$PWD/Dockerfile" ]]; then
    HN_CONTEXT_ICON="${HN_DOCKER_ICON}"; HN_CONTEXT_LABEL='DOCKER'
  elif [[ -f "$PWD/Cargo.toml" || -f "$PWD/go.mod" || -f "$PWD/CMakeLists.txt" ]]; then
    HN_CONTEXT_ICON="${HN_CODE_ICON}"; HN_CONTEXT_LABEL='DEVELOPMENT'
  elif [[ -f "$PWD/.git/config" ]]; then
    HN_CONTEXT_ICON='◆'; HN_CONTEXT_LABEL='PROJECT REPOSITORY'
  fi
}

_hn_preexec() {
  HN_CMD_START=${EPOCHREALTIME:-0}
  # Capture only the visible command label; never rewrite or alias the command.
  local raw="${1:-command}"
  raw="${raw//$'\n'/ }"
  raw="${raw//$'\r'/ }"
  HN_LAST_COMMAND="${raw%%[[:space:]]*}"
  [[ -n "$HN_LAST_COMMAND" ]] || HN_LAST_COMMAND='COMMAND'
  (( ${#HN_LAST_COMMAND} > 22 )) && HN_LAST_COMMAND="${HN_LAST_COMMAND[1,19]}…"
  # A small context glyph follows the last command family; no command is wrapped or rewritten.
  case "${HN_LAST_COMMAND:l}" in
    git|gh) HN_ACTION_ICON="${HN_GIT_ICON:-⑂}" ;;
    python|python3|pip|pip3|uv|poetry) HN_ACTION_ICON="${HN_PY_ICON:-Py}" ;;
    docker|podman|kubectl) HN_ACTION_ICON="${HN_DOCKER_ICON:-▣}" ;;
    ssh|scp|sftp) HN_ACTION_ICON="${HN_SSH_ICON:-⇄}" ;;
    ip|ifconfig|ping|traceroute|tracepath|ss|nmap|tcpdump|tshark) HN_ACTION_ICON="${HN_NETWORK_ICON:-⌁}" ;;
    code|vim|nvim|nano|make|gcc|cargo|node|npm) HN_ACTION_ICON="${HN_CODE_ICON:-⌘}" ;;
    *) HN_ACTION_ICON="${HN_CONSOLE_ICON:-⌘}" ;;
  esac
}
add-zsh-hook preexec _hn_preexec

_hn_choose_palette() {
  emulate -L zsh
  # Fifteen jewel palettes; advance only after a completed command.
  local -a names starts mids ends
  names=("EMERALD PULSE" "SAPPHIRE DRIVE" "AMETHYST CORE" "ARCTIC PRISM" "ROSE QUARTZ" "TURQUOISE FLOW" "INDIGO VECTOR" "CYBER LILAC" "JADE CIRCUIT" "POLAR NIGHT" "ROYAL GOLD" "MATRIX GLOW" "BLOOD MOON" "QUANTUM ICE" "OBSIDIAN")
  starts=("20;205;170" "45;105;235" "145;75;225" "75;205;245" "235;105;165" "20;190;190" "80;90;220" "175;115;235" "35;185;125" "115;175;235")
  mids=("40;160;235" "115;85;235" "205;90;190" "70;145;245" "180;100;225" "40;135;230" "145;85;235" "115;125;245" "35;145;210" "100;115;210")
  ends=("155;105;245" "190;90;220" "245;105;165" "145;115;245" "105;125;245" "105;105;225" "205;100;200" "85;190;220" "105;115;220" "165;115;225" "235;190;95" "80;220;110" "245;65;75" "125;220;255" "185;145;225")
  starts+=("185;135;65" "20;150;75" "220;35;65" "45;170;225" "95;85;135")
  mids+=("225;165;90" "45;205;95" "245;75;90" "80;195;245" "145;110;190")
  if (( HN_LAST_STATUS != 0 )); then
    HN_PALETTE_NAME='CRIMSON ALERT'
    HN_RAIL_START='255;55;95'; HN_RAIL_MID='220;45;125'; HN_RAIL_END='170;55;155'
    return
  fi
  HN_PALETTE_INDEX=$(( (HN_PALETTE_INDEX + 1) % ${#names} ))
  HN_PALETTE_NAME="${names[HN_PALETTE_INDEX+1]}"
  HN_RAIL_START="${starts[HN_PALETTE_INDEX+1]}"
  HN_RAIL_MID="${mids[HN_PALETTE_INDEX+1]}"
  HN_RAIL_END="${ends[HN_PALETTE_INDEX+1]}"
  # Optional pinned palette; automatic context-aware cycling remains the default.
  case "${${HN_THEME_PRESET:-auto}:l}" in
    emerald) HN_PALETTE_NAME='EMERALD PULSE'; HN_RAIL_START='20;205;170'; HN_RAIL_MID='40;160;235'; HN_RAIL_END='155;105;245' ;;
    sapphire) HN_PALETTE_NAME='SAPPHIRE DRIVE'; HN_RAIL_START='45;105;235'; HN_RAIL_MID='115;85;235'; HN_RAIL_END='190;90;220' ;;
    amethyst) HN_PALETTE_NAME='AMETHYST CORE'; HN_RAIL_START='145;75;225'; HN_RAIL_MID='205;90;190'; HN_RAIL_END='245;105;165' ;;
    arctic) HN_PALETTE_NAME='ARCTIC PRISM'; HN_RAIL_START='75;205;245'; HN_RAIL_MID='70;145;245'; HN_RAIL_END='145;115;245' ;;
    rose) HN_PALETTE_NAME='ROSE QUARTZ'; HN_RAIL_START='235;105;165'; HN_RAIL_MID='180;100;225'; HN_RAIL_END='105;125;245' ;;
    turquoise) HN_PALETTE_NAME='TURQUOISE FLOW'; HN_RAIL_START='20;190;190'; HN_RAIL_MID='40;135;230'; HN_RAIL_END='105;105;225' ;;
    indigo) HN_PALETTE_NAME='INDIGO VECTOR'; HN_RAIL_START='80;90;220'; HN_RAIL_MID='145;85;235'; HN_RAIL_END='205;100;200' ;;
    lilac) HN_PALETTE_NAME='CYBER LILAC'; HN_RAIL_START='175;115;235'; HN_RAIL_MID='115;125;245'; HN_RAIL_END='85;190;220' ;;
    jade) HN_PALETTE_NAME='JADE CIRCUIT'; HN_RAIL_START='35;185;125'; HN_RAIL_MID='35;145;210'; HN_RAIL_END='105;115;220' ;;
    polar) HN_PALETTE_NAME='POLAR NIGHT'; HN_RAIL_START='115;175;235'; HN_RAIL_MID='100;115;210'; HN_RAIL_END='165;115;225' ;;
    royal) HN_PALETTE_NAME='ROYAL GOLD'; HN_RAIL_START='185;135;65'; HN_RAIL_MID='225;165;90'; HN_RAIL_END='235;190;95' ;;
    matrix) HN_PALETTE_NAME='MATRIX GLOW'; HN_RAIL_START='20;150;75'; HN_RAIL_MID='45;205;95'; HN_RAIL_END='80;220;110' ;;
    blood) HN_PALETTE_NAME='BLOOD MOON'; HN_RAIL_START='220;35;65'; HN_RAIL_MID='245;75;90'; HN_RAIL_END='245;65;75' ;;
    quantum) HN_PALETTE_NAME='QUANTUM ICE'; HN_RAIL_START='45;170;225'; HN_RAIL_MID='80;195;245'; HN_RAIL_END='125;220;255' ;;
    obsidian) HN_PALETTE_NAME='OBSIDIAN'; HN_RAIL_START='95;85;135'; HN_RAIL_MID='145;110;190'; HN_RAIL_END='185;145;225' ;;
  esac
}

_hn_precmd() {
  HN_LAST_STATUS=$?
  local now=${EPOCHREALTIME:-0}
  HN_LAST_DURATION=''
  if (( HN_CMD_START > 0 && now > HN_CMD_START )); then
    local -F elapsed=$(( now - HN_CMD_START ))
    if (( elapsed >= 60 )); then
      HN_LAST_DURATION="$(printf '%.1fm' "$(( elapsed / 60.0 ))")"
    elif (( elapsed >= 1 )); then
      HN_LAST_DURATION="$(printf '%.1fs' "$elapsed")"
    elif (( elapsed > 0.01 )); then
      HN_LAST_DURATION="$(printf '%.0fms' "$(( elapsed * 1000 ))")"
    fi
  fi
  HN_CMD_START=0

  _hn_context
  vcs_info
  HN_GIT_SEGMENT=''
  if [[ -n "$vcs_info_msg_0_" ]]; then
    local git_color="$HN_C_VIOLET"
    [[ "$vcs_info_msg_0_" == *'●'* || "$vcs_info_msg_0_" == *'✚'* ]] && git_color="$HN_C_AMBER"
    HN_GIT_SEGMENT=" ${git_color}${HN_BRANCH_ICON:-⑂} ${vcs_info_msg_0_}${HN_C_RESET}"
  fi

  HN_ENV_SEGMENT=''
  if [[ -n "${VIRTUAL_ENV:-}" ]]; then
    HN_ENV_SEGMENT=" ${HN_C_GREEN}${HN_PY_ICON} ${VIRTUAL_ENV:t}${HN_C_RESET}"
  elif [[ -n "${CONDA_DEFAULT_ENV:-}" ]]; then
    HN_ENV_SEGMENT=" ${HN_C_AMBER}Conda ${CONDA_DEFAULT_ENV}${HN_C_RESET}"
  elif [[ -n "${NODE_VERSION:-}" ]]; then
    HN_ENV_SEGMENT=" ${HN_C_GREEN}Node ${NODE_VERSION}${HN_C_RESET}"
  fi

  HN_REMOTE_SEGMENT=''
  if [[ -n "${SSH_CONNECTION:-}" || -n "${SSH_CLIENT:-}" ]]; then
    local remote_host="${HOST:-REMOTE}"
    [[ -n "${SSH_CONNECTION:-}" ]] && remote_host="${SSH_CONNECTION%% *}"
    HN_REMOTE_SEGMENT=" ${HN_C_PINK}${HN_SSH_ICON} ${HN_C_WHITE}${remote_host}${HN_C_RESET}"
  fi

  (( EUID == 0 )) && HN_USER_ICON="$HN_ROOT_ICON"
  _hn_choose_palette
  if (( HN_LAST_STATUS == 0 )); then
    HN_STATUS_ICON="$HN_OK_ICON"; HN_STATUS_LABEL='READY'
  else
    HN_STATUS_ICON="$HN_FAIL_ICON"; HN_STATUS_LABEL="EXIT ${HN_LAST_STATUS}"
  fi
}
add-zsh-hook precmd _hn_precmd

_hn_status_segment() {
  if (( HN_LAST_STATUS == 0 )); then
    print -Pn "${HN_C_GREEN}${HN_STATUS_ICON} ${HN_STATUS_LABEL}${HN_C_RESET}"
  else
    print -Pn "${HN_C_RED}${HN_STATUS_ICON} ${HN_STATUS_LABEL}${HN_C_RESET}"
  fi
}

_hn_set_title() { print -Pn "\e]0;HN NEXUS // COMMAND CENTER — %~\a"; }
add-zsh-hook precmd _hn_set_title

# HN//CIT — rounded jewel-spectrum operator HUD.
# Three-row geometry: rounded top rail, information rail with lower-right cap,
# and a rounded lower-left command rail. Dedicated third row for status/input.
# Keep the wordmark its own visual identity; abbreviate the path from its left
# only when required to protect the right telemetry cap. Every row fits COLUMNS-1.
_hn_gradient_text() {
  emulate -L zsh
  local text="$1" i n pos seg off r g b esc ch
  local -a chars c1 c2 c3 rr gg bb
  chars=("${(@s::)text}"); n=${#chars}
  (( n == 0 )) && return 0
  c1=(${(s:;:)HN_RAIL_START}); c2=(${(s:;:)HN_RAIL_MID}); c3=(${(s:;:)HN_RAIL_END})
  rr=($c1[1] $c2[1] $c3[1]); gg=($c1[2] $c2[2] $c3[2]); bb=($c1[3] $c2[3] $c3[3])
  for (( i=1; i<=n; i++ )); do
    pos=$(( n == 1 ? 0 : (i-1)*1000/(n-1) ))
    seg=$(( pos/500 )); (( seg > 1 )) && seg=1
    off=$(( pos-seg*500 ))
    r=$(( rr[seg+1]+(rr[seg+2]-rr[seg+1])*off/500 )); (( r+= (255-r)/5 ))
    g=$(( gg[seg+1]+(gg[seg+2]-gg[seg+1])*off/500 )); (( g+= (255-g)/5 ))
    b=$(( bb[seg+1]+(bb[seg+2]-bb[seg+1])*off/500 )); (( b+= (255-b)/5 ))
    esc=$'\e[1;38;2;'${r}';'${g}';'${b}'m'
    ch=${chars[i]}; print -rn -- "%{${esc}%}${ch}"
  done
  local reset=$'\e[0m'
  print -rn -- "%{${reset}%}"
}

_hn_hud_width() {
  emulate -L zsh
  # Reserve the physical last column to avoid delayed-autowrap corner glitches.
  REPLY=${COLUMNS:-80}
  (( REPLY > 1 )) && (( REPLY -= 1 ))
  (( REPLY < 1 )) && REPLY=1
}

_hn_hud_top() {
  emulate -L zsh
  local width prefix icon rail_count
  _hn_hud_width; width=$REPLY
  icon="${HN_KALI_ICON:-◈}"
  prefix="╭─( HN ${icon} CIT )"
  # At extremely narrow widths, use a compact rounded cap rather than
  # emitting a fixed wordmark that can force terminal autowrap.
  if (( width < 19 )); then
    _hn_gradient_text '╭─╮'
    return 0
  fi
  if (( width <= ${#prefix} )); then
    _hn_gradient_text '╭─╮'
    return 0
  fi
  rail_count=$(( width - ${#prefix} - 1 ))
  _hn_gradient_text "${prefix}"
  (( rail_count > 0 )) && _hn_gradient_rail "$rail_count"
  _hn_gradient_text '╮'
}

_hn_hud_info() {
  emulate -L zsh
  local width path identity clock duration='' context='' context_icon context_label
  local left_plain right_plain left_budget gap pad base_plain path_budget
  local show_git=1 show_env=1 show_remote=1
  _hn_hud_width; width=$REPLY
  # Compact information rail for very narrow terminal windows. Keep the
  # left and right frame glyphs visible and never exceed the safe width.
  if (( width < 19 )); then
    _hn_gradient_text '│'
    (( width > 2 )) && _hn_gradient_rail "$((width - 2))"
    _hn_gradient_text '╯'
    return 0
  fi
  path="${PWD/#$HOME/~}"
  identity="${USER:-kali}@${HOST:-kali}"
  (( EUID == 0 )) && identity="root@${HOST:-kali}"
  context_icon="${HN_CONTEXT_ICON:-◎}"
  context_label="${HN_CONTEXT_LABEL:-ACTIVE DIR}"

  if (( width >= 76 )); then
    strftime -s clock '%H:%M:%S' $EPOCHSECONDS 2>/dev/null || clock='--:--:--'
    duration="${HN_LAST_DURATION:-}"
    context=" │ ${context_icon} ${context_label}"
  elif (( width >= 48 )); then
    strftime -s clock '%H:%M' $EPOCHSECONDS 2>/dev/null || clock='--:--'
  else
    clock=''
  fi

  right_plain="${clock}${duration:+ · ${duration}} ─╯"
  left_budget=$(( width - ${#right_plain} - 1 ))
  (( left_budget < 1 )) && left_budget=1

  _hn_info_plain() {
    REPLY="│ ● ${identity} │ ⌂"
    [[ -n "$path" ]] && REPLY+=" ${path}"
    REPLY+="${context}"
    (( show_git )) && [[ -n "$HN_GIT_SEGMENT" ]] && REPLY+=" │ ${HN_BRANCH_ICON:-⑂} ${vcs_info_msg_0_}"
    (( show_env )) && [[ -n "$HN_ENV_SEGMENT" ]] && REPLY+=" │ ${VIRTUAL_ENV:t:-${CONDA_DEFAULT_ENV:-${NODE_VERSION:-runtime}}}"
    (( show_remote )) && [[ -n "$HN_REMOTE_SEGMENT" ]] && REPLY+=" │ ${HN_SSH_ICON:-⇄} ${HOST:-REMOTE}"
  }

  _hn_info_plain
  left_plain=$REPLY
  # Collapse optional metadata in a predictable order before shortening the path.
  if (( ${#left_plain} > left_budget )) && [[ -n "$context" ]]; then
    context=''; _hn_info_plain; left_plain=$REPLY
  fi
  if (( ${#left_plain} > left_budget )) && (( show_remote )); then
    show_remote=0; _hn_info_plain; left_plain=$REPLY
  fi
  if (( ${#left_plain} > left_budget )) && (( show_env )); then
    show_env=0; _hn_info_plain; left_plain=$REPLY
  fi
  if (( ${#left_plain} > left_budget )) && (( show_git )); then
    show_git=0; _hn_info_plain; left_plain=$REPLY
  fi
  if (( ${#left_plain} > left_budget )); then
    base_plain="│ ● ${identity} │ ⌂"
    path_budget=$(( left_budget - ${#base_plain} - 1 ))
    if (( path_budget < 1 )); then path=''
    elif (( ${#path} > path_budget )); then
      (( path_budget == 1 )) && path='…' || path="…${path[-$((path_budget-1)),-1]}"
    fi
    _hn_info_plain; left_plain=$REPLY
  fi
  if (( ${#left_plain} > left_budget )); then
    identity="${USER:-kali}"
    (( EUID == 0 )) && identity='root'
    path=''; context=''; show_git=0; show_env=0; show_remote=0
    _hn_info_plain; left_plain=$REPLY
  fi
  if (( ${#left_plain} > left_budget )); then left_plain='│'; fi
  gap=$(( width - ${#left_plain} - ${#right_plain} ))
  (( gap < 1 )) && gap=1
  printf -v pad '%*s' "$gap" ''

  _hn_gradient_text '│'
  print -rn -- " %F{82}●%f %F{153}${identity//\%/%%}%f %F{141}│%f %F{81}${HN_FOLDER_ICON:-⌂}%f"
  [[ -n "$path" ]] && print -rn -- " %F{81}${path//\%/%%}%f"
  [[ -n "$context" ]] && print -rn -- " %F{141}│%f %F{177}${context_icon}%f %F{183}${context_label}%f"
  (( show_git )) && [[ -n "$HN_GIT_SEGMENT" ]] && print -rn -- " %F{141}│%f${HN_GIT_SEGMENT}"
  (( show_env )) && [[ -n "$HN_ENV_SEGMENT" ]] && print -rn -- " %F{141}│%f${HN_ENV_SEGMENT}"
  (( show_remote )) && [[ -n "$HN_REMOTE_SEGMENT" ]] && print -rn -- " %F{141}│%f${HN_REMOTE_SEGMENT}"
  print -rn -- "$pad"
  [[ -n "$clock" ]] && print -rn -- "%F{153}${clock}%f"
  [[ -n "$duration" ]] && print -rn -- " %F{141}·%f %F{183}${duration}%f"
  print -rn -- ' %F{141}─╯%f'
}

_hn_hud_bottom() {
  emulate -L zsh
  local width
  _hn_hud_width; width=$REPLY
  # The full operator/status label needs room; retain a clean compact prompt
  # on narrow terminals instead of allowing the input row to wrap.
  if (( width < 19 )); then
    _hn_gradient_text '╰›'
    return 0
  elif (( width < 30 )); then
    if (( HN_LAST_STATUS == 0 )); then
      _hn_gradient_text '╰─'
      print -rn -- " %F{82}READY%f %F{141}›%f"
    else
      _hn_gradient_text '╰─'
      print -rn -- " %F{196}ERR ${HN_LAST_STATUS}%f %F{141}›%f"
    fi
    return 0
  fi
  if (( HN_LAST_STATUS == 0 )); then
    _hn_gradient_text '╰─'
    print -rn -- " %F{82}◆%f %F{114}READY%f %F{141}│%f %F{177}${HN_ACTION_ICON:-⌘}%f %F{141}${HN_PROMPT_ICON:-❯}%f %F{87}›%f "
  else
    _hn_gradient_text '╰─'
    print -rn -- " %F{196}◆%f %F{203}FAILED · EXIT ${HN_LAST_STATUS}%f %F{141}│%f %F{177}${HN_ACTION_ICON:-⌘}%f %F{141}${HN_PROMPT_ICON:-❯}%f %F{87}›%f "
  fi
}

# Render once in precmd, not inside PROMPT substitutions. This prevents ZLE
# history navigation (Up/Down) from re-evaluating/erasing portions of the HUD.
_hn_render_prompt() {
  local top info bottom
  top=$(_hn_hud_top)
  info=$(_hn_hud_info)
  bottom=$(_hn_hud_bottom)
  # Assign one authoritative three-row prompt. The renderer is deliberately
  # the final HN precmd hook so stale theme hooks cannot append/overwrite HUD rows.
  typeset -g PROMPT="${top}"$'\n'"${info}"$'\n'"${bottom}"
  typeset -g RPROMPT=''
}
# Remove a previous registration when this file is sourced again, then append
# the renderer after the state/palette hooks to prevent mixed old/new layouts.
add-zsh-hook -d precmd _hn_render_prompt 2>/dev/null || true
add-zsh-hook precmd _hn_render_prompt
RPROMPT=''

# Recompute the HUD geometry whenever the terminal receives SIGWINCH.
# This keeps the rail, telemetry cap and text columns aligned after resize.
TRAPWINCH() {
  [[ -o interactive ]] || return 0
  _hn_render_prompt
  # ZLE redraw is valid only while the line editor is active. The prompt
  # remains cached otherwise and will be rebuilt by the next precmd hook.
  if [[ -o zle ]]; then
    zle reset-prompt 2>/dev/null || true
  fi
}
