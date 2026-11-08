# Troubleshooting & Recuperação (`docs/TROUBLESHOOTING.md`)

## 1. `rice` ou `wb` não encontrado no PATH
Enquanto o pacote `zsh` ainda não foi instalado e o shell padrão for `bash`, certifique-se de que `~/.local/bin` está no `PATH` (adicionado automaticamente ao `~/.bashrc` pelo instalador) ou recarregue com `source ~/.bashrc`.

## 2. Cores do Tmux ou WezTerm não atualizaram após `rice theme`
- Execute `rice status` para verificar o estado gravado em `~/.config/rice/state.env`.
- No Tmux, pressione `Ctrl+a` seguido de `r` para recarregar `~/.config/tmux/tmux.conf`.
- Para sincronizar com o Windows manualmente, execute `rice sync`.

## 3. Restaurar Configurações Originais antes do `brasilia-night`
Liste os backups em `~/.local/state/brasilia-night/backups/` e execute o script `restore.sh` correspondente.
