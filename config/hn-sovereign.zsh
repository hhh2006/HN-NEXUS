# HN NEXUS — COMMAND CENTER managed entry point
[[ -o interactive ]] || return 0

HN_NEXUS_CONFIG="${HOME}/HN-NEXUS/CORE/CONFIG"

# Correct misspelled command names interactively. ZSH asks before replacing
# a command; never auto-correct arguments or execute a changed command silently.
setopt CORRECT
unsetopt CORRECT_ALL

# Ensure completion is actually initialized before applying completion styles.
# Respect a compinit already loaded by the user's/global ZSH configuration.
if (( ! ${+_comps} )); then
  autoload -Uz compinit
  compinit -d "${ZDOTDIR:-$HOME}/.zcompdump"
fi

# Load optional plugins conservatively; user configuration remains user-owned.
if [[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

[[ -r "${HN_NEXUS_CONFIG}/hn-terminal.zsh" ]] && source "${HN_NEXUS_CONFIG}/hn-terminal.zsh"
[[ -r "${HN_NEXUS_CONFIG}/hn-tools.zsh" ]] && source "${HN_NEXUS_CONFIG}/hn-tools.zsh"

if [[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
