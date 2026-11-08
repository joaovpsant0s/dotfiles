SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

VARIANT ?= night
ACCENT  ?= purple

.PHONY: help validate theme install unstow backup install-packages dry-run-packages doctor benchmark test sync-windows

help: ## Exibe os alvos disponíveis no brasilia-night
	@echo "╭──────────────────────────────────────────────────────────────────╮"
	@echo "│  BRASILIA-NIGHT v2.0 — Makefile Platform Interface               │"
	@echo "╰──────────────────────────────────────────────────────────────────╯"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[35m%-18s\033[0m %s\n", $$1, $$2}'

validate: ## Valida palette.toml, persona.toml e templates
	@./theme/validate.sh

theme: ## Gera temas para todos os destinos (ex: make theme VARIANT=moon ACCENT=cyan)
	@./rice-bin/.local/bin/rice theme $(VARIANT) $(ACCENT) --no-sync

install: ## Faz backup e aplica os 12 pacotes Stow em $$HOME (idempotente)
	@./install.sh

unstow: ## Remove os symlinks dos pacotes Stow de $$HOME
	@./install.sh --unstow

backup: ## Cria snapshot reversível com manifesto SHA-256 e restore.sh
	@./scripts/backup.sh

dry-run-packages: ## Simula a instalação de pacotes Arch Linux e AUR sem sudo
	@./scripts/install-packages.sh --dry-run

install-packages: ## Instala pacotes oficiais (pacman) e AUR (yay) com autenticação interativa
	@./scripts/install-packages.sh

doctor: ## Executa verificação completa de integridade do ambiente
	@./scripts/validate-environment.sh

benchmark: ## Executa bateria estatística real de performance (cold, warm, mean, median, P95)
	@./scripts/benchmark.sh

test: ## Executa toda a suíte automatizada de testes (theme, shell, stow, integration)
	@./tests/theme/test_theme_engine.sh
	@./tests/shell/test_scripts.sh
	@./tests/stow/test_stow_layout.sh
	@./tests/integration/test_rice_cli.sh

sync-windows: ## Sincroniza configurações com o host Windows 11 via PowerShell 7
	@./rice-bin/.local/bin/rice sync
