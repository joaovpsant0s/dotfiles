# 70-keybindings.zsh — Keybindings ergonômicas
bindkey -e

__nocturne_sesh_widget() {
  BUFFER="sesh-picker"
  zle accept-line
}
zle -N __nocturne_sesh_widget
bindkey '^f' __nocturne_sesh_widget
