# Guia de Instalação e Reversibilidade — `brasilia-night`

## 1. Aplicação User-Space (Sem Sudo)

```bash
cd ~/brasilia-night
make validate
make test
make install
```

O comando `make install` executa automaticamente:
1. `theme/generate.sh` para garantir que todos os arquivos derivados existam.
2. `scripts/backup.sh` para salvar qualquer arquivo preexistente conflitante em `~/.local/state/brasilia-night/backups/<timestamp>/` com manifesto `SHA256SUMS` e script `restore.sh`.
3. Vinculação dos 12 pacotes Stow em `$HOME`.

## 2. Instalação de Pacotes Arch Linux & AUR (Com Autenticação Interativa)

```bash
# Simulação sem sudo:
make dry-run-packages

# Instalação real (solicita senha sudo para pacman; executa yay como usuário normal):
make install-packages

# Ou por categoria específica:
./scripts/install-packages.sh --category base
./scripts/install-packages.sh --category dev
./scripts/install-packages.sh --category academic
```

## 3. Reversão Completa (Rollback)

```bash
# Remover todos os symlinks gerenciados:
make unstow

# Restaurar snapshot específico:
~/.local/state/brasilia-night/backups/<timestamp>/restore.sh
```
