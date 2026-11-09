# Changelog — `nocturne`

Todas as mudanças relevantes deste projeto são documentadas neste arquivo.

## [2.0.0] — 2026-11-08

### Adicionado
- **Single Source of Truth (`identity/persona.toml` & `theme/palette.toml`)**: variantes `night`, `storm`, `moon` e acentos `blue`, `purple`, `cyan`, `green`, `orange`, `red`.
- **Theme Engine (`theme/validate.sh` & `theme/generate.sh`)**: validação via `tomllib` (Python 3.14 stdlib), proibição de cores hexadecimais literais em templates e renderização atômica por hash SHA-256 para 16 ferramentas.
- **CLI `rice` e `workbench` (`wb`)**: suporte completo a troca de temas, sincronização Windows e layouts `code`, `server`, `db`, `study` e `algo` (com `wb init-algo` e `wb algo-check` usando `gcc -O2 -Wall -Wextra -std=c17` para monitoria de APC na Engenharia).
- **Engenharia de Shell (`zsh`)**: arquitetura modular em `conf.d/`, guard de filesystem NTFS (`/mnt/*`) e cache de inicialização invalidado por `mtime`.
- **Neovim >= 0.11**: configuração modular com API nativa `vim.lsp.config()` / `vim.lsp.enable()`, `lazy.nvim` estrito, dashboard `nocturne` e comandos `:ApcInit` / `:ApcCheck`.
- **Camada Windows 11**: configurações para `WezTerm`, `GlazeWM`, `Zebar` e `Fastfetch`, acompanhadas dos scripts PowerShell 7 `Install-Fonts.ps1`, `Sync-WindowsRice.ps1` e `Invoke-WorkstationMaintenance.ps1` com suporte a `-WhatIf`.
- **Testes e Benchmarks**: suítes automatizadas em `tests/` e benchmark estatístico real em `scripts/benchmark.sh`.
