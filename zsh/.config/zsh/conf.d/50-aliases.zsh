# 50-aliases.zsh — Aliases para Engenharia de Software, Dados e Monitoria de APC (UnB/FGA)
if (( $+commands[eza] )); then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -lh --group-directories-first --icons=auto --git'
  alias la='eza -lah --group-directories-first --icons=auto --git'
  alias lt='eza --tree --level=2 --icons=auto'
else
  alias ls='ls --color=auto'
  alias ll='ls -lh --color=auto'
  alias la='ls -lah --color=auto'
fi

(( $+commands[bat] )) && alias cat='bat --paging=never'
(( $+commands[lazygit] )) && alias lg='lazygit'
(( $+commands[lazydocker] )) && alias lzd='lazydocker'
(( $+commands[btop] )) && alias top='btop'
(( $+commands[nvim] )) && alias v='nvim'

# Monitoria de Algoritmos e Programação em Computadores (APC - UnB/FGA)
alias gcc17='gcc -O2 -Wall -Wextra -std=c17'
alias gccdbg='gcc -g3 -O0 -Wall -Wextra -fsanitize=address,undefined -std=c17'
alias apcinit='wb init-algo'
alias apccheck='wb algo-check'
alias wbalgo='wb algo'
alias wbstudy='wb study'
alias wbdb='wb db'
alias wbserver='wb server'

# Backend & Data Engineering
alias py='python3'
alias dc='docker compose'
alias gs='git status -sb'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -n 20'
