# 70-keybindings.zsh — Keybindings ergonômicas
bindkey -e

# Ctrl+f abre sesh-picker
__bn_sesh_widget() {
  BUFFER="sesh-picker"
  zle accept-line
}
zle -N __bn_sesh_widget
bindkey '^f' __bn_sesh_widget
