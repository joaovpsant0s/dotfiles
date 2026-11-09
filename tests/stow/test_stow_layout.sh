#!/usr/bin/env bash
# =============================================================================
# NOCTURNE — STOW LAYOUT, ISOLATION & IDEMPOTENCY TEST SUITE
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

TMP_HOME="$(mktemp -d "${TMPDIR:-/tmp}/bn_stow_home.XXXXXX")"
trap 'rm -rf "$TMP_HOME"' EXIT

echo "=== [TEST] 1/4 Simulando anomalias protegidas no diretório home temporário ==="
echo "TOP_SECRET_DO_NOT_TOUCH" > "$TMP_HOME/secret.txt"
ln -s "/mnt/c/Users/joaovpsantos/.aws" "$TMP_HOME/.aws"
ln -s "/mnt/c/Users/joaovpsantos/.azure" "$TMP_HOME/.azure"
mkdir -p "$TMP_HOME/bindmount-apps"
echo "existing_bashrc" > "$TMP_HOME/.bashrc"

echo "=== [TEST] 2/4 Executando install.sh em $TMP_HOME ==="
"$REPO_ROOT/install.sh" --target "$TMP_HOME"

echo "=== [TEST] 3/4 Verificando symlinks criados e ausência de diretórios administrativos ==="
for expected_link in \
  ".zshenv" \
  ".config/zsh/.zshrc" \
  ".config/starship.toml" \
  ".config/tmux/tmux.conf" \
  ".config/tmux/theme-generated.conf" \
  ".config/atuin/config.toml" \
  ".config/yazi/yazi.toml" \
  ".config/yazi/theme.toml" \
  ".config/nvim/init.lua" \
  ".config/nvim/lua/config/theme_generated.lua" \
  ".config/git/config" \
  ".config/git/delta-theme.gitconfig" \
  ".config/lazygit/config.yml" \
  ".config/lazygit/theme.yml" \
  ".config/lazydocker/config.yml" \
  ".config/btop/btop.conf" \
  ".config/btop/themes/nocturne.theme" \
  ".config/fastfetch/config.jsonc" \
  ".local/bin/rice" \
  ".local/bin/wb" \
  ".local/bin/workbench" \
  ".local/bin/sesh-picker"; do
  if [ ! -L "$TMP_HOME/$expected_link" ]; then
    echo "[FAIL] Symlink esperado não foi criado: $TMP_HOME/$expected_link" >&2
    exit 1
  fi
  if [ ! -e "$TMP_HOME/$expected_link" ]; then
    echo "[FAIL] Symlink quebrado (dangling): $TMP_HOME/$expected_link" >&2
    exit 1
  fi
done

for forbidden in docs packages windows theme wsl-system tests scripts identity; do
  if [ -e "$TMP_HOME/$forbidden" ] || [ -L "$TMP_HOME/$forbidden" ]; then
    echo "[FAIL] Diretório administrativo '$forbidden' foi vinculado ao HOME!" >&2
    exit 1
  fi
done

# Verify protected anomalies were untouched
grep -q "^TOP_SECRET_DO_NOT_TOUCH$" "$TMP_HOME/secret.txt"
[ -L "$TMP_HOME/.aws" ]
[ -L "$TMP_HOME/.azure" ]
[ -d "$TMP_HOME/bindmount-apps" ]
echo "[OK] Todos os 22 caminhos principais vinculados sem symlinks órfãos e anomalias preservadas."

echo "=== [TEST] 4/4 Verificando idempotência da segunda execução de install.sh ==="
OUT="$("$REPO_ROOT/install.sh" --target "$TMP_HOME")"
echo "$OUT"
if command -v stow >/dev/null 2>&1; then
  echo "[OK] Re-execução com GNU Stow concluída."
else
  grep -q "(0 novos links atualizados)" <<< "$OUT"
  echo "[OK] Idempotência comprovada (0 novos links na segunda execução)."
fi
