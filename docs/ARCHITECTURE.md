# Arquitetura da Workstation Híbrida — `nocturne`

## 1. Divisão em Duas Camadas

### Camada Visual e de Janelas (Windows 11 Host)
- **WezTerm**: emulador de terminal acelerado por GPU (`WebGpu`) conectado diretamente ao domínio `WSL:archlinux`.
- **GlazeWM + Zebar**: gerenciador de janelas tiling e barra superior minimalista sincronizados com a paleta ativa.
- **Sync-WindowsRice.ps1**: ponte unidirecional segura que lê os artefatos gerados no WSL via UNC (`\\wsl.localhost\archlinux\...`) e atualiza o perfil Windows com backup prévio.

### Camada de Desenvolvimento e CLI (Arch Linux WSL 2 — `arch`)
- **Single Source of Truth**: `identity/persona.toml` + `theme/palette.toml` + `~/.config/rice/state.env`.
- **Theme Engine (`theme/validate.sh` + `theme/generate.sh`)**: compilador determinístico em Python 3 (`tomllib`) que valida tokens e escreve atomicamente as configurações derivadas.
- **Gerenciamento de Dotfiles (`install.sh` + GNU Stow)**: 12 pacotes isolados (`zsh`, `starship`, `tmux`, `atuin`, `yazi`, `nvim`, `git`, `lazygit`, `lazydocker`, `btop`, `fastfetch`, `rice-bin`). Diretórios administrativos jamais são vinculados ao `$HOME`.
