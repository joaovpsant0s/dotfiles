# 20-plugins.zsh — Carregamento estático em cache via Antidote (ou fallback limpo)
() {
  local plugins_txt="$ZDOTDIR/.zsh_plugins.txt"
  local static_bundle="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/plugins.bundle.zsh"

  if [[ -f /usr/share/zsh-antidote/antidote.zsh ]]; then
    if [[ ! -f "$static_bundle" || "$plugins_txt" -nt "$static_bundle" ]]; then
      source /usr/share/zsh-antidote/antidote.zsh
      antidote bundle <"$plugins_txt" >|"$static_bundle"
    fi
    source "$static_bundle"
  else
    # Fallback para pacotes do sistema Arch caso antidote não esteja instalado
    [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
      source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
      source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  fi
}
