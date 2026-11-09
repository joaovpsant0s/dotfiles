# =============================================================================
# NOCTURNE — ZSH ENVIRONMENT (.zshenv)
# Curated PATH: evita varredura 9P em dezenas de pastas Windows no /mnt/c
# =============================================================================
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export NOCTURNE_ROOT="${NOCTURNE_ROOT:-$HOME/nocturne}"

typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/go/bin"
  "$HOME/.cargo/bin"
  /usr/local/sbin
  /usr/local/bin
  /usr/bin
  /usr/lib/wsl/lib
  /mnt/c/Windows/System32
  /mnt/c/Windows
  /mnt/c/Windows/System32/WindowsPowerShell/v1.0
  /mnt/c/Users/joaovpsantos/AppData/Local/Microsoft/WindowsApps
)
export PATH
