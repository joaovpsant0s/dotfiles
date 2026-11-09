#!/usr/bin/env bash
# =============================================================================
# NOCTURNE — DECLARATIVE ARCH LINUX & AUR PACKAGE INSTALLER
# Regras:
# - Nunca executa builds AUR como root
# - Usa --needed (idempotente, nunca remove pacotes existentes)
# - Suporta --dry-run e seleção por categoria
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PKG_DIR="$REPO_ROOT/packages/arch"

DRY_RUN=0
CATEGORY="all"

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run|-n)
      DRY_RUN=1
      shift
      ;;
    --category|-c)
      CATEGORY="${2:-all}"
      shift 2
      ;;
    -h|--help)
      echo "Uso: install-packages.sh [--dry-run] [--category base|dev|tui|security|academic|aur|all]"
      exit 0
      ;;
    *)
      echo "[ERROR] Argumento desconhecido: $1" >&2
      exit 2
      ;;
  esac
done

if [ "$(id -u)" -eq 0 ]; then
  echo "[ERROR] Segurança: Não execute install-packages.sh diretamente como root (builds AUR são proibidos como root)." >&2
  exit 1
fi

read_pkg_file() {
  local file="$1"
  if [ -f "$file" ]; then
    awk '!/^[[:space:]]*#/ && NF {print $1}' "$file"
  fi
}

OFFICIAL_CATS=()
RUN_AUR=0

case "$CATEGORY" in
  all)
    OFFICIAL_CATS=(base dev tui security academic)
    RUN_AUR=1
    ;;
  base|dev|tui|security|academic)
    OFFICIAL_CATS=("$CATEGORY")
    ;;
  aur)
    RUN_AUR=1
    ;;
  *)
    echo "[ERROR] Categoria inválida: $CATEGORY" >&2
    exit 2
    ;;
esac

OFFICIAL_PKGS=()
for cat_name in "${OFFICIAL_CATS[@]}"; do
  while IFS= read -r pkg; do
    [ -n "$pkg" ] && OFFICIAL_PKGS+=("$pkg")
  done < <(read_pkg_file "$PKG_DIR/${cat_name}.txt")
done

AUR_PKGS=()
if [ "$RUN_AUR" -eq 1 ]; then
  while IFS= read -r pkg; do
    [ -n "$pkg" ] && AUR_PKGS+=("$pkg")
  done < <(read_pkg_file "$PKG_DIR/aur.txt")
fi

echo "╭──────────────────────────────────────────────────────────────────╮"
echo "│  NOCTURNE — GERENCIADOR DE PACOTES ARCH LINUX & AUR        │"
echo "╰──────────────────────────────────────────────────────────────────╯"

if [ "${#OFFICIAL_PKGS[@]}" -gt 0 ]; then
  MISSING_OFFICIAL=()
  for p in "${OFFICIAL_PKGS[@]}"; do
    if ! pacman -Qi "$p" >/dev/null 2>&1; then
      MISSING_OFFICIAL+=("$p")
    fi
  done
  echo "[PACMAN] Total declarados: ${#OFFICIAL_PKGS[@]} | Ausentes: ${#MISSING_OFFICIAL[@]}"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[DRY-RUN] Executaria: sudo pacman -S --needed ${OFFICIAL_PKGS[*]}"
  elif [ "${#MISSING_OFFICIAL[@]}" -gt 0 ]; then
    sudo pacman -S --needed "${OFFICIAL_PKGS[@]}"
  else
    echo "[OK] Todos os pacotes oficiais selecionados já estão instalados."
  fi
fi

if [ "${#AUR_PKGS[@]}" -gt 0 ]; then
  MISSING_AUR=()
  for p in "${AUR_PKGS[@]}"; do
    if ! pacman -Qi "$p" >/dev/null 2>&1; then
      MISSING_AUR+=("$p")
    fi
  done
  echo "[AUR] Total declarados: ${#AUR_PKGS[@]} | Ausentes: ${#MISSING_AUR[@]}"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[DRY-RUN] Executaria: yay -S --needed ${AUR_PKGS[*]}"
  elif [ "${#MISSING_AUR[@]}" -gt 0 ]; then
    if ! command -v yay >/dev/null 2>&1; then
      echo "[ERROR] yay não encontrado no PATH." >&2
      exit 1
    fi
    yay -S --needed "${AUR_PKGS[@]}"
  else
    echo "[OK] Todos os pacotes AUR selecionados já estão instalados."
  fi
fi
