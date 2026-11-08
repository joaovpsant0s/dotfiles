# Engenharia de Performance e Benchmarks (`docs/PERFORMANCE.md`)

## 1. Estratégias Implementadas

1. **Zsh Startup Cache (`40-init-cache.zsh`)**: `starship init zsh`, `zoxide init zsh` e `atuin init zsh` são pré-gerados em `~/.cache/zsh/init/*.zsh` e regenerados somente quando o binário ou arquivo de configuração possui `mtime` mais recente.
2. **Completion Dump Inteligente (`30-completion.zsh`)**: `compinit -C` reutiliza `~/.cache/zsh/zcompdump` e reconstrói a árvore completa apenas uma vez a cada 20 horas.
3. **Neovim Bytecode Loader & Lazy Loading**: `vim.loader.enable()` ativo no topo do `init.lua`, `defaults.lazy = true` no `lazy.nvim` e plugins built-in desnecessários (`gzip`, `tarPlugin`, `zipPlugin`, `tohtml`, `tutor`, `netrwPlugin`) desativados.
4. **Theme Engine O(1) I/O em No-Op**: comparação de hash SHA-256 em memória evita escritas de disco quando o tema gerado já corresponde ao estado atual.

## 2. Execução do Benchmark Real

```bash
make benchmark
```
O script `scripts/benchmark.sh` mede `cold`, `warm_min`, `mean`, `median` e `p95` reais com `time.perf_counter()` da stdlib do Python 3.14.
