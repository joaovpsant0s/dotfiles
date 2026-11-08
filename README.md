# 🏛 `brasilia-night` — Hybrid Developer Workstation (v2.0)

> **Engenharia de Plataforma Pessoal & Dotfiles Declarativos**
> **Arch Linux WSL 2 (`gama`) + Windows 11 Host**
> **Proprietário:** João Victor Pereira Santos (`@joaovpsant0s` / `JVZerinho`) — UnB/FGA (Engenharia de Software & Monitoria de APC)

---

## 1. Visão Geral e Filosofia Visual

O **`brasilia-night`** combina a paleta **Tokyo Night** (`night`, `storm`, `moon`) com a geometria modernista de Brasília: traços retos, espaços negativos intencionais, separadores arquitetônicos (`╭─`, `╰─▸`, ``, ``) e zero poluição visual.

Toda a estação de trabalho opera sob **Single Source of Truth**:
- [`identity/persona.toml`](identity/persona.toml) — Identidade acadêmica e profissional configurável.
- [`theme/palette.toml`](theme/palette.toml) — Definição semântica e ANSI (0–15) para 3 variantes e 6 acentos (`blue`, `purple`, `cyan`, `green`, `orange`, `red`).
- `~/.config/rice/state.env` — Estado ativo de execução com escrita atômica e permissões `0600`.

---

## 2. Arquitetura Híbrida

| Camada | Ambiente | Componentes Principais |
| :--- | :--- | :--- |
| **Visual & Window Layer** | Windows 11 Host | `WezTerm`, `GlazeWM`, `Zebar`, `Windows Fastfetch`, `GeistMono Nerd Font` |
| **Development & CLI Layer** | Arch Linux WSL 2 (`gama`) | `Zsh` + `Starship` + `Atuin`, `Tmux` + `sesh-picker`, `Neovim >= 0.11`, `Yazi`, `Lazygit`, `Lazydocker`, `Btop`, `rice` CLI, `workbench` (`wb`) |

---

## 3. Comandos Principais

### Orquestrador de Temas (`rice`)
```bash
rice theme night            # Variante night + acento atual
rice theme storm purple     # Variante storm + acento purple
rice theme moon cyan        # Variante moon + acento cyan
rice status                 # Exibe estado ativo e integridade
rice doctor                 # Diagnóstico completo do ambiente
rice sync                   # Sincroniza temas com o host Windows 11
rice benchmark              # Executa benchmark estatístico real
```

### Workbench (`wb`) — Engenharia de Software, Dados e Monitoria APC (UnB/FGA)
```bash
wb code [dir]               # Layout de desenvolvimento convencional (editor + shell + git)
wb server [dir]             # Layout Backend Python/Django, Docker Compose e logs
wb db [dir]                 # Layout PostgreSQL, SQLite e análise de dados
wb study [dir]              # Layout de disciplinas UnB/FGA, Markdown e LaTeX
wb algo [dir]               # Layout dedicado à Monitoria de APC (C17 / Python + I/O)

# Utilitários dedicados de Monitoria APC:
wb init-algo [dir]          # Cria main.c, solution.py, input.txt, expected.txt e Makefile
wb algo-check main.c        # Compila com gcc -O2 -Wall -Wextra -std=c17 e valida I/O (timeout 5s)
wb algo-check solution.py   # Executa Python 3 contra input.txt e compara com expected.txt
```

### Interface Declarativa (`Makefile`)
```bash
make validate               # Valida TOML e ausência de hex hardcoded em templates
make test                   # Executa as 4 suítes de testes (theme, shell, stow, integration)
make install                # Cria backup SHA-256 e aplica os 12 pacotes Stow em $HOME
make dry-run-packages       # Simula instalação de pacotes oficiais e AUR
make install-packages       # Instala pacotes Arch Linux (pacman) e AUR (yay)
make benchmark              # Mede cold, warm, média, mediana e P95 reais
```

---

## 4. Documentação Técnica (`docs/`)

- [Auditoria Baseline do Sistema (`docs/AUDIT_BASELINE.md`)](docs/AUDIT_BASELINE.md)
- [Arquitetura da Estação Híbrida (`docs/ARCHITECTURE.md`)](docs/ARCHITECTURE.md)
- [Guia de Instalação e Reversibilidade (`docs/INSTALLATION.md`)](docs/INSTALLATION.md)
- [Motor de Temas Single Source of Truth (`docs/THEMING.md`)](docs/THEMING.md)
- [Camada Visual Windows 11 (`docs/WINDOWS_RICE.md`)](docs/WINDOWS_RICE.md)
- [Manutenção Windows & WSL (`docs/WINDOWS_MAINTENANCE.md`)](docs/WINDOWS_MAINTENANCE.md)
- [Otimização do WSL 2 & Systemd (`docs/WSL_OPTIMIZATION.md`)](docs/WSL_OPTIMIZATION.md)
- [Engenharia de Performance & Benchmarks (`docs/PERFORMANCE.md`)](docs/PERFORMANCE.md)
- [Troubleshooting & Recuperação (`docs/TROUBLESHOOTING.md`)](docs/TROUBLESHOOTING.md)
- [Política de Segurança & Proteção (`docs/SECURITY.md`)](docs/SECURITY.md)
