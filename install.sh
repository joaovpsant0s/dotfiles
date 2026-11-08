#!/usr/bin/env bash
# =============================================================================
# BRASILIA-NIGHT — IDEMPOTENT DOTFILES INSTALLER
# Vincula exclusivamente os 12 pacotes Stow ao diretório alvo ($HOME por padrão)
# Nunca vincula diretórios administrativos (docs, packages, windows, theme, etc.)
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

STOW_PACKAGES=(
  zsh
  starship
  tmux
  atuin
  yazi
  nvim
  git
  lazygit
  lazydocker
  btop
  fastfetch
  rice-bin
)

FORBIDDEN_PACKAGES=(
  docs
  packages
  windows
  theme
  wsl-system
  tests
  scripts
  identity
  .github
)

TARGET_DIR="$HOME"
DRY_RUN=0
UNSTOW=0

while [ $# -gt 0 ]; do
  case "$1" in
    --target|-t)
      TARGET_DIR="${2:-}"
      shift 2
      ;;
    --dry-run|-n)
      DRY_RUN=1
      shift
      ;;
    --unstow|-D)
      UNSTOW=1
      shift
      ;;
    -h|--help)
      echo "Uso: ./install.sh [--target <dir>] [--dry-run] [--unstow]"
      exit 0
      ;;
    *)
      echo "[ERROR] Opção desconhecida: $1" >&2
      exit 2
      ;;
  esac
done

mkdir -p "$TARGET_DIR"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

# Safety check: verify no forbidden package is ever in STOW_PACKAGES
for pkg in "${STOW_PACKAGES[@]}"; do
  for bad in "${FORBIDDEN_PACKAGES[@]}"; do
    if [ "$pkg" = "$bad" ]; then
      echo "[FATAL] Diretório administrativo '$pkg' jamais pode ser um pacote Stow!" >&2
      exit 1
    fi
  done
done

# 1. Generate all theme artifacts first so no application ever sees a missing file
if [ "$UNSTOW" -eq 0 ]; then
  if [ "$DRY_RUN" -eq 1 ]; then
    "$REPO_ROOT/theme/generate.sh" --dry-run --quiet
  else
    "$REPO_ROOT/theme/generate.sh" --quiet
    "$REPO_ROOT/scripts/backup.sh" "$TARGET_DIR"
  fi
fi

# 2. Link packages using GNU Stow (if available) or deterministic Python Stow-compatible linker
if command -v stow >/dev/null 2>&1; then
  echo "[INSTALL] Utilizando GNU Stow para gerenciar pacotes em $TARGET_DIR..."
  for pkg in "${STOW_PACKAGES[@]}"; do
    if [ "$UNSTOW" -eq 1 ]; then
      if [ "$DRY_RUN" -eq 1 ]; then
        stow --no --verbose --dir="$REPO_ROOT" --target="$TARGET_DIR" -D "$pkg"
      else
        stow --dir="$REPO_ROOT" --target="$TARGET_DIR" -D "$pkg"
      fi
    else
      if [ "$DRY_RUN" -eq 1 ]; then
        stow --no --verbose --dir="$REPO_ROOT" --target="$TARGET_DIR" --restow "$pkg"
      else
        # Remove conflicting non-symlink regular files already backed up by backup.sh
        python3 - "$REPO_ROOT/$pkg" "$TARGET_DIR" << 'PYCLEAN'
import pathlib, sys
pkg_dir = pathlib.Path(sys.argv[1])
target_dir = pathlib.Path(sys.argv[2])
for src in pkg_dir.rglob("*"):
    if src.is_file() or src.is_symlink():
        rel = src.relative_to(pkg_dir)
        dst = target_dir / rel
        if dst.exists() and not dst.is_symlink() and dst.is_file():
            dst.unlink()
PYCLEAN
        stow --dir="$REPO_ROOT" --target="$TARGET_DIR" --restow "$pkg"
      fi
    fi
  done
else
  echo "[INSTALL] GNU Stow ainda não instalado; aplicando symlinks compatíveis com Stow via Python stdlib..."
  python3 - "$REPO_ROOT" "$TARGET_DIR" "$DRY_RUN" "$UNSTOW" "${STOW_PACKAGES[@]}" << 'PYSTOW'
import os
import pathlib
import sys

repo_root = pathlib.Path(sys.argv[1])
target_dir = pathlib.Path(sys.argv[2])
dry_run = sys.argv[3] == "1"
unstow = sys.argv[4] == "1"
packages = sys.argv[5:]

PROTECTED_NAMES = {"secret.txt", ".aws", ".azure", "bindmount-apps", "multi-container-app", "welcome-to-docker", "yay"}

linked = 0
removed = 0

for pkg in packages:
    pkg_dir = repo_root / pkg
    if not pkg_dir.is_dir():
        sys.exit(f"[ERROR] Pacote ausente: {pkg_dir}")

    for src in sorted(pkg_dir.rglob("*")):
        if src.is_dir() and not src.is_symlink():
            continue
        rel = src.relative_to(pkg_dir)
        if rel.parts[0] in PROTECTED_NAMES:
            sys.exit(f"[FATAL] Tentativa bloqueada de tocar em caminho protegido: {rel}")

        dst = target_dir / rel
        if unstow:
            if dst.is_symlink() and dst.resolve() == src.resolve():
                if not dry_run:
                    dst.unlink()
                removed += 1
            continue

        if dst.is_symlink():
            try:
                if dst.resolve() == src.resolve():
                    continue
            except OSError:
                pass
            if not dry_run:
                dst.unlink()
        elif dst.exists():
            if not dry_run:
                dst.unlink()

        if not dry_run:
            dst.parent.mkdir(parents=True, exist_ok=True)
            rel_target = os.path.relpath(src, dst.parent)
            dst.symlink_to(rel_target)
        linked += 1

if unstow:
    print(f"[OK] Unstow concluído ({removed} links removidos).")
else:
    mode = "DRY-RUN" if dry_run else "APPLIED"
    print(f"[OK] ({mode}) {len(packages)} pacotes vinculados em {target_dir} ({linked} novos links atualizados).")
PYSTOW
fi
