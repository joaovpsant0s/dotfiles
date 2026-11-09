# =============================================================================
# NOCTURNE — INTERACTIVE ZSHRC
# =============================================================================
[[ -o interactive ]] || return 0

[[ -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/init" ]] || mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/init"
[[ -d "${XDG_STATE_HOME:-$HOME/.local/state}/zsh" ]] || mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh"

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP
setopt AUTO_CD

for mod in "$ZDOTDIR"/conf.d/*.zsh(N); do
  source "$mod"
done
