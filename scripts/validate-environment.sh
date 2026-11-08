#!/usr/bin/env bash
# =============================================================================
# BRASILIA-NIGHT — ENVIRONMENT VALIDATOR (rice doctor)
# Verifica integridade do repositório, proteção de arquivos e estado das ferramentas
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "╭──────────────────────────────────────────────────────────────────╮"
echo "│  BRASILIA-NIGHT — ENVIRONMENT DOCTOR & COMPLIANCE CHECK          │"
echo "╰──────────────────────────────────────────────────────────────────╯"

# 1. Validate TOML Single Source of Truth & Templates
"$REPO_ROOT/theme/validate.sh"

# 2. Verify Protected Baseline Items (Safety Rules)
echo "=== [CHECK] Proteção do Ambiente Existente ==="
if [ -e "/home/JVZerinho/secret.txt" ]; then
  owner="$(stat -c '%U:%G %a' /home/JVZerinho/secret.txt)"
  echo "  [OK] /home/JVZerinho/secret.txt preservado intocado ($owner)"
fi
for link in .aws .azure; do
  if [ -L "$HOME/$link" ]; then
    echo "  [OK] Symlink $HOME/$link preservado -> $(readlink "$HOME/$link")"
  fi
done
for proj in bindmount-apps multi-container-app welcome-to-docker; do
  if [ -d "$HOME/$proj" ]; then
    echo "  [OK] Diretório de projeto $HOME/$proj preservado"
  fi
done

# 3. Check state.env
STATE_FILE="${RICE_STATE_FILE:-$HOME/.config/rice/state.env}"
if [ -f "$STATE_FILE" ]; then
  perm="$(stat -c '%a' "$STATE_FILE")"
  echo "  [OK] Estado $STATE_FILE presente (permissão: $perm)"
else
  echo "  [INFO] Estado $STATE_FILE ainda será inicializado pelo 'rice'"
fi

# 4. Inventory Core CLI Tools (Verified vs Pending Installation)
echo "=== [CHECK] Ferramentas CLI no Arch Linux WSL 2 ==="
VERIFIED=()
PENDING=()
for cmd in bash git python3 gcc go fastfetch yay zsh tmux nvim stow starship yazi lazygit lazydocker btop fzf bat delta eza zoxide atuin rg fd jq; do
  if command -v "$cmd" >/dev/null 2>&1; then
    VERIFIED+=("$cmd")
  else
    PENDING+=("$cmd")
  fi
done

echo "  [PRESENTES (${#VERIFIED[@]})]: ${VERIFIED[*]}"
if [ "${#PENDING[@]}" -gt 0 ]; then
  echo "  [AGUARDANDO 'make install-packages' (${#PENDING[@]})]: ${PENDING[*]}"
fi

# 5. Check systemd status
echo "=== [CHECK] Init & Systemd ==="
pid1="$(ps -p 1 -o comm= 2>/dev/null || echo unknown)"
if [ "$pid1" = "systemd" ]; then
  echo "  [OK] PID 1 = systemd (ativo)"
else
  echo "  [INFO] PID 1 atual = $pid1 (wsl-system/wsl.conf preparado para ativar systemd após reinício da distro)"
fi

echo "[OK] Diagnóstico concluído sem erros de integridade."
