# 30-completion.zsh — Inicialização rápida do compinit com cache de 20h
autoload -Uz compinit
() {
  local zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
  if [[ -f "$zcompdump" && -n "$zcompdump"(#qN.mh-20) ]]; then
    compinit -C -d "$zcompdump"
  else
    compinit -d "$zcompdump"
  fi
}

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
