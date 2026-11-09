#!/usr/bin/env bash
# =============================================================================
# NOCTURNE — REVERSIBLE DOTFILES BACKUP & RESTORE GENERATOR
# Cria snapshot com manifesto SHA-256 e script restore.sh antes de alterações
# =============================================================================
set -euo pipefail

TARGET_HOME="${1:-$HOME}"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_BASE="${XDG_STATE_HOME:-$TARGET_HOME/.local/state}/nocturne/backups"
BACKUP_DIR="$BACKUP_BASE/$TIMESTAMP"

PATHS_TO_CHECK=(
  ".zshenv"
  ".bashrc"
  ".bash_profile"
  ".gitconfig"
  ".config/zsh"
  ".config/starship.toml"
  ".config/tmux"
  ".config/atuin"
  ".config/yazi"
  ".config/nvim"
  ".config/git"
  ".config/lazygit"
  ".config/lazydocker"
  ".config/btop"
  ".config/fastfetch"
  ".config/rice"
)

mkdir -p "$BACKUP_DIR/files"
MANIFEST="$BACKUP_DIR/SHA256SUMS"
: > "$MANIFEST"

backed_up=0
for rel in "${PATHS_TO_CHECK[@]}"; do
  src="$TARGET_HOME/$rel"
  # Never touch protected anomalies (secret.txt, .aws, .azure)
  if [ -e "$src" ] && [ ! -L "$src" ]; then
    dest="$BACKUP_DIR/files/$rel"
    mkdir -p "$(dirname "$dest")"
    cp -a "$src" "$dest"
    if [ -f "$dest" ]; then
      (cd "$BACKUP_DIR/files" && sha256sum "$rel" >> "$MANIFEST")
    fi
    backed_up=$((backed_up + 1))
  fi
done

cat > "$BACKUP_DIR/restore.sh" << RESTORE_EOF
#!/usr/bin/env bash
set -euo pipefail
echo "Restaurando backup nocturne ($TIMESTAMP) para $TARGET_HOME..."
if [ -d "$BACKUP_DIR/files" ]; then
  cp -a "$BACKUP_DIR/files/." "$TARGET_HOME/"
fi
echo "[OK] Restauração concluída."
RESTORE_EOF
chmod +x "$BACKUP_DIR/restore.sh"

echo "[BACKUP] Snapshot criado em: $BACKUP_DIR ($backed_up itens regulares salvos)"
