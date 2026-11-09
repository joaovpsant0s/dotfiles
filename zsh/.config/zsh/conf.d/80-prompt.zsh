# 80-prompt.zsh — Inicialização única do Starship (com fallback ASCII) e saudação controlada
if (( $+commands[starship] )) && [[ "${NOCTURNE_ASCII:-0}" != "1" && "${TERM:-}" != "linux" ]]; then
  __nocturne_cached_eval "starship" "$commands[starship]" "$XDG_CONFIG_HOME/starship.toml" starship init zsh
else
  PROMPT='%B%F{white}%~%f%b
%(?.%B%F{blue}>%f%b.%B%F{red}>%f%b) '
fi

# Saudação única por sessão interativa principal (silenciosa em subshells, -c, pipes e tmux)
() {
  if [[ -o interactive && -t 0 && -t 1 && -z "${ZSH_EXECUTION_STRING:-}" && -z "${NOCTURNE_GREETING_SHOWN:-}" && -z "${TMUX:-}" && "${SHLVL:-1}" -le 1 ]]; then
    export NOCTURNE_GREETING_SHOWN=1
    local state_file="${RICE_STATE_FILE:-$HOME/.config/rice/state.env}"
    local show_greeting="1"
    if [[ -f "$state_file" ]]; then
      show_greeting="$(awk -F'=' '$1=="RICE_GREETING"{print $2}' "$state_file" 2>/dev/null || echo "1")"
    fi
    if [[ "$show_greeting" == "1" ]] && [[ -x "$HOME/.local/bin/fastfetch" ]]; then
      "$HOME/.local/bin/fastfetch" 2>/dev/null || true
    fi
  fi
}
