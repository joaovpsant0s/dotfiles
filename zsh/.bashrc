# =============================================================================
# NOCTURNE — INTERACTIVE BASH CONFIGURATION (.bashrc)
# Cobre sessões Bash com o mesmo prompt Starship, guard NTFS e saudação única
# =============================================================================
[[ $- != *i* ]] && return

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export NOCTURNE_ROOT="${NOCTURNE_ROOT:-$HOME/nocturne}"
export PATH="$HOME/.local/bin:$PATH"

alias ls='eza --group-directories-first --icons=auto 2>/dev/null || ls --color=auto'
alias grep='grep --color=auto'

# NTFS Guard for /mnt/*
__nocturne_bash_guard() {
  case "$PWD" in
    /mnt/[a-zA-Z]|/mnt/[a-zA-Z]/*) export NOCTURNE_ON_WINDOWS_FS=1 ;;
    *) unset NOCTURNE_ON_WINDOWS_FS ;;
  esac
}
PROMPT_COMMAND="__nocturne_bash_guard${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

if command -v starship >/dev/null 2>&1 && [ "${NOCTURNE_ASCII:-0}" != "1" ] && [ "${TERM:-}" != "linux" ]; then
  eval "$(starship init bash)"
else
  PS1='\[\e[1;37m\]\w\[\e[0m\]\n\[\e[1;34m\]>\[\e[0m\] '
fi

# One-time greeting on top-level interactive non-tmux shell
if [ -t 0 ] && [ -t 1 ] && [ -z "${BASH_EXECUTION_STRING:-}" ] && [ -z "${NOCTURNE_GREETING_SHOWN:-}" ] && [ -z "${TMUX:-}" ] && [ "${SHLVL:-1}" -le 1 ]; then
  export NOCTURNE_GREETING_SHOWN=1
  state_file="${RICE_STATE_FILE:-$HOME/.config/rice/state.env}"
  show_greeting="1"
  if [ -f "$state_file" ]; then
    show_greeting="$(awk -F'=' '$1=="RICE_GREETING"{print $2}' "$state_file" 2>/dev/null || echo "1")"
  fi
  if [ "$show_greeting" = "1" ] && command -v fastfetch >/dev/null 2>&1; then
    "$HOME/.local/bin/fastfetch" 2>/dev/null || true
  fi
fi
