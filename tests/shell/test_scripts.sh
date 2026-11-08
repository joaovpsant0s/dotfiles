#!/usr/bin/env bash
# =============================================================================
# BRASILIA-NIGHT — SHELL SCRIPTS SYNTAX & QUALITY TEST SUITE
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "=== [TEST] Verificando sintaxe Bash (bash -n) e ausência de CRLF ==="
SCRIPTS=(
  "$REPO_ROOT/install.sh"
  "$REPO_ROOT/theme/validate.sh"
  "$REPO_ROOT/theme/generate.sh"
  "$REPO_ROOT/scripts/backup.sh"
  "$REPO_ROOT/scripts/install-packages.sh"
  "$REPO_ROOT/scripts/validate-environment.sh"
  "$REPO_ROOT/scripts/benchmark.sh"
  "$REPO_ROOT/rice-bin/.local/bin/rice"
  "$REPO_ROOT/rice-bin/.local/bin/workbench"
  "$REPO_ROOT/rice-bin/.local/bin/sesh-picker"
  "$REPO_ROOT/rice-bin/.local/bin/docker"
  "$REPO_ROOT/rice-bin/.local/bin/nvidia-smi"
  "$REPO_ROOT/rice-bin/.local/bin/agy"
  "$REPO_ROOT/tests/theme/test_theme_engine.sh"
  "$REPO_ROOT/tests/shell/test_scripts.sh"
  "$REPO_ROOT/tests/stow/test_stow_layout.sh"
  "$REPO_ROOT/tests/integration/test_rice_cli.sh"
)

for s in "${SCRIPTS[@]}"; do
  if [ ! -f "$s" ]; then
    echo "[FAIL] Script ausente: $s" >&2
    exit 1
  fi
  if grep -q $'\r' "$s"; then
    echo "[FAIL] CRLF detectado em: $s" >&2
    exit 1
  fi
  bash -n "$s"
done

echo "[OK] ${#SCRIPTS[@]} scripts validados com 'bash -n' e 100% LF."

if command -v shellcheck >/dev/null 2>&1; then
  echo "=== [TEST] Executando ShellCheck ==="
  shellcheck -x "${SCRIPTS[@]}"
  echo "[OK] ShellCheck aprovado sem avisos."
else
  echo "[INFO] shellcheck ausente no sistema atual (será instalado via 'make install-packages')."
fi
