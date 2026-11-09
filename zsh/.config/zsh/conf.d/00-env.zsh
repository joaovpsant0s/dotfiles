# 00-env.zsh — Variáveis de ambiente e integração de cores geradas
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

if command -v nvim >/dev/null 2>&1; then
  export EDITOR="nvim"
  export VISUAL="nvim"
else
  export EDITOR="vim"
  export VISUAL="vim"
fi

export PAGER="less -FRX"
export BAT_CONFIG_PATH="$NOCTURNE_ROOT/theme/generated/bat/config"

if [ -f "$NOCTURNE_ROOT/theme/generated/fzf/fzf-theme.sh" ]; then
  source "$NOCTURNE_ROOT/theme/generated/fzf/fzf-theme.sh"
fi
export FZF_DEFAULT_OPTS="--height=45% --layout=reverse --border=rounded ${FZF_DEFAULT_OPTS_THEME:-}"

if [ -f "$NOCTURNE_ROOT/theme/generated/eza/eza-colors.sh" ]; then
  source "$NOCTURNE_ROOT/theme/generated/eza/eza-colors.sh"
fi
