# Auditoria Baseline do Ambiente — `brasilia-night`

Data da auditoria (somente leitura): `2026-11-08`

## 1. Inventário do Sistema (Arch Linux WSL 2 + Windows 11 Host)

| Categoria | Estado Encontrado (`[FATO]`) |
| :--- | :--- |
| **Distribuição WSL** | Arch Linux (`BUILD_ID=rolling`), arquitetura `x86_64` |
| **Kernel** | `Linux DESKTOP-B07SU8E 6.18.33.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC` |
| **Versão WSL / WSLg** | WSL `2.7.14.0` · WSLg `1.0.73.2` · Windows `10.0.26200.8037` |
| **Hardware Host** | 13th Gen Intel Core i5-13420H (8 núcleos físicos / 12 threads), `15.71 GB` RAM |
| **GPU Host / WSL** | NVIDIA GeForce RTX 3050 6GB Laptop GPU + Intel UHD Graphics (`/dev/dxg` presente no WSL) |
| **Usuário Linux** | `uid=1000(JVZerinho) gid=1000(JVZerinho) groups=1000(JVZerinho),998(wheel),1001(docker)` |
| **Shell Padrão** | `/bin/bash` (`GNU bash 5.3.20`) |
| **Home & Filesystem** | `/home/JVZerinho` em `/dev/sdd` (`ext4`), `2.4 GB` usados de `1007 GB` virtuais (`ext4.vhdx` = `2.83 GB` no host) |
| **Init / Systemd** | `PID 1 = /init` (`init(archlinux)`), `systemd` **offline**. `/etc/wsl.conf` continha apenas `[user]\ndefault=JVZerinho` |
| **Pacman & AUR** | `185` pacotes totais; explícitos: `base base-devel fastfetch git nano sudo vim wget yay yay-debug`. `yay v13.0.1` funcional |
| **Toolchains Presentes** | `gcc 16.2.1`, `python3 3.14.9`, `go`, `git 2.56.0`, `vim 9.2`, `fastfetch 2.71.0`, `gpg 2.4.9` |
| **Ferramentas Ausentes (WSL)** | `nvim`, `zsh`, `tmux`, `stow`, `starship`, `yazi`, `lazygit`, `lazydocker`, `lazysql`, `btop`, `fzf`, `bat`, `delta`, `eza`, `zoxide`, `atuin`, `rg`, `fd`, `jq`, `uv`, `shellcheck`, `shfmt`, `stylua` |
| **Fontes Windows** | `GeistMono-*.ttf` (18 arquivos base) e `JetBrainsMono-*.ttf` (32 arquivos base/NL) em `C:\Windows\Fonts`; variantes Nerd Font ausentes |
| **Apps Windows** | `pwsh.exe`, `git.exe`, Docker Desktop e VS Code presentes; `WezTerm`, `GlazeWM`, `Zebar` e `fastfetch` Windows ausentes |

## 2. Auditoria de Neovim

- Nenhum binário `nvim` encontrado em `/usr/bin`, `/usr/local/bin`, `~/.local/bin` ou AppImage.
- Nenhum diretório `~/.config/nvim` preexistente (`~/.config` continha apenas `go/`).
- **Decisão**: implementar a estrutura modular completa para Neovim `>= 0.11` sem risco de sobrescrever configurações anteriores.

## 3. Anomalias e Arquivos Protegidos

1. `/home/JVZerinho/secret.txt` (`-rw-r--r-- 1 root root 164 Oct 2 11:37`): preservado integralmente sem leitura ou modificação.
2. Symlinks `.aws -> /mnt/c/Users/joaovpsantos/.aws` e `.azure -> /mnt/c/Users/joaovpsantos/.azure`: preservados.
3. Diretórios `bindmount-apps`, `multi-container-app`, `welcome-to-docker` e `yay`: preservados fora do escopo do Stow.
4. Repositório Git na raiz do perfil Windows (`C:\Users\joaovpsantos\.git`): preservado sem alterações; o repositório `brasilia-night` foi isolado em `/home/JVZerinho/brasilia-night` (`ext4`).
