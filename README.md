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

**`nocturne`** é uma configuração de terminal e ferramentas para **Arch Linux no WSL 2** integrada ao **Windows 11**, construída com foco em desempenho, reprodutibilidade e consistência visual:

- **Ecossistema `glibc` completo do Arch Linux (`pacman` + `yay`)**: compiladores, Language Servers, formatadores e ferramentas TUI nativas sem gambiarras de compatibilidade.
- **Single Source of Truth Theme Engine (`theme/palette.toml` + `theme/generate.sh`)**: 3 variantes (`night`, `storm`, `moon`) × 6 acentos (`blue`, `purple`, `cyan`, `green`, `orange`, `red`) = **18 temas gerados atomicamente** para 18 destinos (Windows Terminal, WezTerm, PowerShell, Zsh, Bash, Starship, Tmux, Neovim, Yazi, Btop, Lazygit, Lazydocker, Delta, Fastfetch, GlazeWM e Zebar).
- **Fastfetch responsivo** — assinatura bicolor, painel com sistema, shell, pacotes, CPU, GPU dedicada, RAM, disco raiz e uptime. Em painéis estreitos, exibe uma versão curta. Use `fastfetch --full` para diagnóstico.
- **Prompt Starship Unificado (Zsh, Bash e PowerShell)**: layout minimalista de 2 linhas com símbolo `❯` em azul no Arch, lilás no PowerShell, vermelho em erro e proteção de I/O para volumes NTFS (`/mnt/*`).
- **Aceleração GPU CUDA no WSL 2**: wrapper `~/.local/bin/docker` com injeção automática de `/dev/dxg` e `/usr/lib/wsl` ao detectar `--gpus`.

---

## 2. Identidade Visual no Terminal

### Nocturne Night

A paleta Night usa azul quase preto, texto claro e lavanda como acento. O Arch e o PowerShell têm marcas próprias em azul e lilás. O Windows Terminal prefere **GeistMono Nerd Font Mono**, com JetBrainsMono Nerd Font Mono e Cascadia Mono como alternativas.

No Neovim, abra `nvim` para ver o painel do Snacks. Use **f** para arquivos, **n** para novo arquivo, **g** para buscar texto, **r** para recentes e **c** para a configuração. Durante a edição, use **Espaço → e** para abrir o explorador. O seletor alterna entre prévia lateral e empilhada conforme a largura.

### Fastfetch

- `fastfetch` — painel responsivo. Logo grande a partir de 100 colunas, médio a partir de 80 e resumo em splits.
- `fastfetch --compact` — sistema, shell, memória e uptime.
- `fastfetch --full` — diagnóstico com kernel, terminal, GPUs e outros dados.
- No Windows, a marca em quatro painéis identifica o host. A RAM e o build são os do Windows.
- Copie `Sync-WindowsRice.ps1` para uma pasta local do Windows e execute com `-AppearanceOnly -WhatIf` para prever a sincronização da aparência, incluindo Starship, WezTerm e Zebar. Remova `-WhatIf` para aplicar.

### Fluxo diário no Arch

Use `~/dev` ou `~/projects` para projetos no filesystem do Arch. O seletor de sessões reúne sessões abertas, destinos recentes do Zoxide e diretórios locais. Deixe os volumes `/mnt/*` para trocar arquivos com o host.

1. Abra **Arch · WSL** no Windows Terminal e rode `wb code ~/dev/meu-projeto`. A primeira janela abre o Neovim, a segunda é o shell e a terceira abre o Lazygit quando o diretório está em um repositório Git.
2. No tmux, use `Ctrl+a` seguido de `s` para trocar de sessão, `y` para Yazi, `g` para Lazygit ou `b` para btop. Fora do tmux, a função `y` acompanha o último diretório escolhido no Yazi.
3. Use `wb study` para notas com Neovim. Use `explorer.exe .` quando quiser abrir a pasta atual no Windows.

### Prompt Unificado (Arch WSL & Windows PowerShell)
```text
▲  ~/nocturne  ↳ main *
❯ 

C:\Users\joaovpsantos\projects  ↳ main *
❯ 
```

---

## 3. Comandos Principais

```bash
# Troca de tema em tempo real (Linux + Windows Terminal/PowerShell/WezTerm):
rice theme night blue
rice theme storm purple
rice theme moon cyan

# Fastfetch (painel responsivo vs diagnóstico completo):
fastfetch               # Resumo responsivo (120 / 80 / 60 colunas)
fastfetch --full        # Ficha técnica completa (CPU, GPUs, Kernel, Disk, Packages)

# Diagnóstico, Manutenção e Benchmarks:
devdoctor               # Verifica integridade de symlinks, pacotes e segurança
arch-maint              # Compila bytecode Zsh (.zwc), limpa caches e audita órfãos
rice benchmark          # Mede cold, warm, média, mediana e P95 reais

# Workbench (Tmux + C17/Python Algorithms Runner):
wb code                 # Layout de desenvolvimento (editor + shell + git)
wb server               # Layout Backend/Containers
wb db                   # Layout SQL
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
