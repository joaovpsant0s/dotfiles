#!/usr/bin/env bash
# =============================================================================
# NOCTURNE — IDEMPOTENT DOTFILES INSTALLER (GNU Stow --no-folding)
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
    --target|-t) TARGET_DIR="${2:-}"; shift 2 ;;
    --dry-run|-n) DRY_RUN=1; shift ;;
    --unstow|-D) UNSTOW=1; shift ;;
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

for pkg in "${STOW_PACKAGES[@]}"; do
  for bad in "${FORBIDDEN_PACKAGES[@]}"; do
    if [ "$pkg" = "$bad" ]; then
      echo "[FATAL] Diretório administrativo '$pkg' jamais pode ser um pacote Stow!" >&2
      exit 1
    fi
  done
done

if [ "$UNSTOW" -eq 0 ]; then
  if [ "$DRY_RUN" -eq 1 ]; then
    "$REPO_ROOT/theme/generate.sh" --dry-run --quiet
  else
    "$REPO_ROOT/theme/generate.sh" --quiet
    "$REPO_ROOT/scripts/backup.sh" "$TARGET_DIR"
  fi
fi

if command -v stow >/dev/null 2>&1; then
  echo "[INSTALL] Aplicando 12 pacotes via GNU Stow (--no-folding) em $TARGET_DIR..."
  for pkg in "${STOW_PACKAGES[@]}"; do
    if [ "$UNSTOW" -eq 1 ]; then
      if [ "$DRY_RUN" -eq 1 ]; then
        stow --no --no-folding --verbose --dir="$REPO_ROOT" --target="$TARGET_DIR" -D "$pkg"
      else
        stow --no-folding --dir="$REPO_ROOT" --target="$TARGET_DIR" -D "$pkg"
      fi
    else
      if [ "$DRY_RUN" -eq 1 ]; then
        stow --no --no-folding --verbose --dir="$REPO_ROOT" --target="$TARGET_DIR" --restow "$pkg"
      else
        python3 - "$REPO_ROOT/$pkg" "$TARGET_DIR" << 'PYCLEAN'
import pathlib, sys
pkg_dir = pathlib.Path(sys.argv[1]).resolve()
target_dir = pathlib.Path(sys.argv[2]).resolve()
PROTECTED = {"secret.txt", ".aws", ".azure", "bindmount-apps", "multi-container-app", "welcome-to-docker", "yay"}
for src in pkg_dir.rglob("*"):
    if src.is_dir() and not src.is_symlink():
        continue
    rel = src.relative_to(pkg_dir)
    if rel.parts[0] in PROTECTED:
        continue
    dst = target_dir / rel
    if dst.is_symlink():
        try:
            if dst.resolve() != src.resolve():
                dst.unlink()
        except OSError:
            dst.unlink()
    elif dst.exists() and dst.is_file():
        dst.unlink()
PYCLEAN
        stow --no-folding --dir="$REPO_ROOT" --target="$TARGET_DIR" --restow "$pkg"
      fi
    fi
  done
  echo "[OK] 12 pacotes Stow vinculados com sucesso em $TARGET_DIR."
fi

if [ "$UNSTOW" -eq 0 ] && [ "$DRY_RUN" -eq 0 ] && [ "$TARGET_DIR" = "$HOME" ] && command -v zsh >/dev/null 2>&1; then
  zsh -c '
    for f in "$HOME/.zshenv" "$HOME/.config/zsh/.zshrc" "$HOME/.config/zsh/conf.d/"*.zsh(N); do
      [[ -f "$f" ]] && zcompile "$f" 2>/dev/null || true
    done
  ' || true
fi
