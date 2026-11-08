# 80-prompt.zsh — Inicialização do Starship (com fallback) e saudação controlada
if (( $+commands[starship] )); then
  __bn_cached_eval "starship" "$commands[starship]" "$XDG_CONFIG_HOME/starship.toml" starship init zsh
else
  PROMPT='%F{magenta}╭─%f %B%F{blue}%~%f%b
%F{magenta}╰─▸%f '
fi

# Saudação opcional apenas em sessões interativas de nível superior
() {
  if [[ -z "${BN_GREETING_SHOWN:-}" && -o interactive && "${SHLVL:-1}" -le 2 ]]; then
    export BN_GREETING_SHOWN=1
    local state_file="${RICE_STATE_FILE:-$HOME/.config/rice/state.env}"
    local show_greeting="0"
    if [[ -f "$state_file" ]]; then
      show_greeting="$(awk -F'=' '$1=="RICE_GREETING"{print $2}' "$state_file" 2>/dev/null || echo "0")"
    fi
    if [[ "$show_greeting" == "1" ]] && (( $+commands[fastfetch] )); then
      fastfetch --config "$BRASILIA_NIGHT_ROOT/fastfetch/.config/fastfetch/config.jsonc" 2>/dev/null || true
    fi
  fi
}
