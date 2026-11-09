<div align="center">

<img src="docs/assets/arch-logo.svg" height="72" alt="Arch Linux Official Logo" />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="docs/assets/tokyonight-logo.svg" height="72" alt="Tokyo Night Theme Engine" />

# `nocturne` — Arch Linux WSL 2 & Windows 11 Workstation

### Arch Linux (`glibc`) &bull; WSL 2 &bull; Tokyo Night Dynamic Engine &bull; `i use arch, btw`

[![CI Pipeline](https://img.shields.io/github/actions/workflow/status/joaovpsant0s/dotfiles/ci.yml?branch=main&label=CI%20Pipeline&logo=githubactions&logoColor=white&style=flat-square)](https://github.com/joaovpsant0s/dotfiles/actions/workflows/ci.yml)
[![Arch Linux](https://img.shields.io/badge/Arch_Linux-Rolling_glibc-1793D1?logo=archlinux&logoColor=white&style=flat-square)](https://archlinux.org/)
[![WSL 2](https://img.shields.io/badge/WSL_2-Kernel_6.18-0078D4?logo=windowsterminal&logoColor=white&style=flat-square)](https://learn.microsoft.com/windows/wsl/)
[![Neovim](https://img.shields.io/badge/Neovim-0.11_Native_LSP-57A143?logo=neovim&logoColor=white&style=flat-square)](https://neovim.io/)
[![Theme Engine](https://img.shields.io/badge/Theme_Engine-Tokyo_Night_(18_Combos)-7aa2f7?style=flat-square)](docs/THEMING.md)
[![License](https://img.shields.io/badge/License-MIT-9ece6a?style=flat-square)](LICENSE)

</div>

---

## 1. Visão Geral

**`nocturne`** é uma plataforma de engenharia de ambiente de desenvolvimento para **Arch Linux no WSL 2** integrada ao **Windows 11**, construída com foco em desempenho, reprodutibilidade e consistência visual:

- **Ecossistema `glibc` completo do Arch Linux (`pacman` + `yay`)**: compiladores, Language Servers, formatadores e ferramentas TUI nativas sem gambiarras de compatibilidade.
- **Single Source of Truth Theme Engine (`theme/palette.toml` + `theme/generate.sh`)**: 3 variantes (`night`, `storm`, `moon`) × 6 acentos (`blue`, `purple`, `cyan`, `green`, `orange`, `red`) = **18 temas gerados atomicamente** para 18 destinos (Windows Terminal, WezTerm, PowerShell, Zsh, Bash, Starship, Tmux, Neovim, Yazi, Btop, Lazygit, Lazydocker, Delta, Fastfetch, GlazeWM e Zebar).
- **Fastfetch Responsivo (`arch, btw`)**: arte compacta do `A` do Arch em azul (`#7aa2f7`), resumo enxuto de 4 linhas (`os`, `shell`, `mem`, `up`), adaptação automática para 120, 80 e 60 colunas e modo diagnóstico completo sob demanda (`fastfetch --full`).
- **Prompt Starship Unificado (Zsh, Bash e PowerShell)**: layout minimalista de 2 linhas com símbolo `❯` em azul no Arch, lilás no PowerShell, vermelho em erro e proteção de I/O para volumes NTFS (`/mnt/*`).
- **Aceleração GPU CUDA no WSL 2**: wrapper `~/.local/bin/docker` com injeção automática de `/dev/dxg` e `/usr/lib/wsl` ao detectar `--gpus`.

---

## 2. Identidade Visual no Terminal

### Fastfetch (`arch / i use arch, btw`)
```text
      /\        arch
     /  \       ────────────────
    / /\ \      os       Arch Linux · WSL 2
   / /  \ \     shell    zsh
  / /____\ \    mem      1.1 GiB / 7.6 GiB
 /_/      \_\   up       42 mins

                i use arch, btw
```

### Prompt Unificado (Arch WSL & Windows PowerShell)
```text
~/nocturne  on main *
❯ 

C:\Users\joaovpsantos\projects  on main *
❯ 
```

---

## 3. Comandos Principais

```bash
# Troca de tema em tempo real (Linux + Windows Terminal/PowerShell/WezTerm):
rice theme night blue
rice theme storm purple
rice theme moon cyan

# Fastfetch (resumo 4 linhas vs diagnóstico completo):
fastfetch               # Resumo responsivo (120 / 80 / 60 colunas)
fastfetch --full        # Ficha técnica completa (CPU, GPUs, Kernel, Disk, Packages)

# Diagnóstico, Manutenção e Benchmarks:
devdoctor               # Verifica integridade de symlinks, pacotes e segurança
arch-maint              # Compila bytecode Zsh (.zwc), limpa caches e audita órfãos
rice benchmark          # Mede cold, warm, média, mediana e P95 reais

# Workbench (Tmux + C17/Python Algorithms Runner):
wb code                 # Layout de desenvolvimento (editor + shell + git)
wb server               # Layout Backend/Containers
wb db                   # Layout SQL/Data Engineering
wb algo                 # Layout de algoritmos + compilador C17/Python
wb init-algo ./ex1      # Gera main.c, solution.py, input.txt, expected.txt, Makefile
wb algo-check main.c    # Compila com gcc -O2 -Wall -Wextra -std=c17 e valida I/O
```

---

## 4. Pacotes GNU Stow Gerenciados (12 Módulos)

| Pacote | Conteúdo | Destino em `$HOME` |
| :--- | :--- | :--- |
| **`zsh`** | `.zshenv`, `.bashrc`, `.config/zsh/{.zshrc,conf.d/*.zsh}` | Shell principal com `zcompile` e cache de hooks |
| **`starship`** | `.config/starship.toml` | Prompt minimalista de 2 linhas |
| **`tmux`** | `.config/tmux/{tmux.conf,theme-generated.conf}` | Prefix `Ctrl+a`, `smart-splits` e popups TUI a 92% |
| **`atuin`** | `.config/atuin/config.toml` | Histórico de comandos local estruturado |
| **`nvim`** | `.config/nvim/{init.lua,lua/**,snippets/**}` | Neovim 0.11 com API nativa `vim.lsp.config` |
| **`yazi`** | `.config/yazi/{yazi.toml,keymap.toml,theme.toml}` | File manager TUI com wrapper `y` (cd-on-exit) |
| **`git`** | `.config/git/{config,ignore,delta-theme.gitconfig}` | Configuração Git modular + Delta |
| **`lazygit`** | `.config/lazygit/{config.yml,theme.yml}` | TUI Git integrada ao Delta |
| **`lazydocker`**| `.config/lazydocker/config.yml` | TUI Docker & Compose |
| **`btop`** | `.config/btop/{btop.conf,themes/nocturne.theme}` | Monitor de recursos e processos |
| **`fastfetch`** | `.config/fastfetch/{logo-arch.txt,config.jsonc,compact.jsonc,diagnostic.jsonc}` | Dashboard responsivo `arch, btw` |
| **`rice-bin`** | `.local/bin/{rice,wb,workbench,devdoctor,arch-maint,sesh-picker,fastfetch,docker,nvidia-smi,agy}` | CLIs de plataforma e wrappers WSL |
