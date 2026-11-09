#!/usr/bin/env bash
# =============================================================================
# NOCTURNE — ATOMIC THEME ENGINE GENERATOR
# Renderiza temas a partir de palette.toml + persona.toml + state.env
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PALETTE_FILE="$REPO_ROOT/theme/palette.toml"
PERSONA_FILE="$REPO_ROOT/identity/persona.toml"
STATE_FILE="${RICE_STATE_FILE:-$HOME/.config/rice/state.env}"

VARIANT=""
ACCENT=""
DRY_RUN=0
QUIET=0

while [ $# -gt 0 ]; do
  case "$1" in
    -v|--variant) VARIANT="${2:-}"; shift 2 ;;
    -a|--accent)  ACCENT="${2:-}"; shift 2 ;;
    -n|--dry-run) DRY_RUN=1; shift ;;
    -q|--quiet)   QUIET=1; shift ;;
    -h|--help)
      echo "Uso: generate.sh [--variant night|storm|moon] [--accent blue|purple|cyan|green|orange|red] [--dry-run] [--quiet]"
      exit 0
      ;;
    *)
      echo "[ERROR] Argumento desconhecido: $1" >&2
      exit 2
      ;;
  esac
done

read_state_key() {
  local key="$1"
  local file="$2"
  if [ -f "$file" ]; then
    awk -F'=' -v k="$key" '
      $0 !~ /^[[:space:]]*#/ && $1 == k {
        val = substr($0, index($0, "=") + 1)
        gsub(/^[[:space:]]*["'\'']?|["'\'']?[[:space:]]*$/, "", val)
        print val
        exit
      }
    ' "$file"
  fi
}

if [ -z "$VARIANT" ]; then
  VARIANT="$(read_state_key "RICE_THEME" "$STATE_FILE" || true)"
  VARIANT="${VARIANT:-night}"
fi

if [ -z "$ACCENT" ]; then
  ACCENT="$(read_state_key "RICE_ACCENT" "$STATE_FILE" || true)"
  ACCENT="${ACCENT:-purple}"
fi

"$SCRIPT_DIR/validate.sh" "$PALETTE_FILE" "$PERSONA_FILE" >/dev/null

python3 - "$REPO_ROOT" "$PALETTE_FILE" "$PERSONA_FILE" "$VARIANT" "$ACCENT" "$DRY_RUN" "$QUIET" << 'PYEOF'
import hashlib
import os
import pathlib
import re
import sys
import tempfile
import tomllib

repo_root = pathlib.Path(sys.argv[1])
palette_path = pathlib.Path(sys.argv[2])
persona_path = pathlib.Path(sys.argv[3])
variant = sys.argv[4]
accent_name = sys.argv[5]
dry_run = sys.argv[6] == "1"
quiet = sys.argv[7] == "1"

with palette_path.open("rb") as f:
    palette = tomllib.load(f)
with persona_path.open("rb") as f:
    persona = tomllib.load(f)

variants = palette["variants"]
accents = palette["accents"]

if variant not in variants:
    sys.exit(f"[ERROR] Variante inválida '{variant}'. Opções: {', '.join(variants.keys())}")
if accent_name not in accents:
    sys.exit(f"[ERROR] Acento inválido '{accent_name}'. Opções: {', '.join(accents.keys())}")

v = variants[variant]
accent_hex = accents[accent_name]

tokens = {
    "VARIANT": variant,
    "ACCENT_NAME": accent_name,
    "ACCENT": accent_hex,
    "ACCENT_BLUE": accents["blue"],
    "ACCENT_PURPLE": accents["purple"],
    "ACCENT_CYAN": accents["cyan"],
    "BACKGROUND": v["background"],
    "BACKGROUND_ALT": v["background_alt"],
    "SURFACE": v["surface"],
    "SURFACE_ALT": v["surface_alt"],
    "FOREGROUND": v["foreground"],
    "FOREGROUND_MUTED": v["foreground_muted"],
    "FOREGROUND_SUBTLE": v["foreground_subtle"],
    "ACCENT_SECONDARY": v["accent_secondary"],
    "BORDER": v["border"],
    "SELECTION": v["selection"],
    "CURSOR": v["cursor"],
    "SUCCESS": v["success"],
    "WARNING": v["warning"],
    "ERROR": v["error"],
    "INFO": v["info"],
    "OWNER_NAME": persona["owner_name"],
    "DISPLAY_NAME": persona["display_name"],
    "USERNAME": persona["username"],
    "GITHUB_USERNAME": persona["github_username"],
    "HOSTNAME": persona["hostname"],
    "SIGNATURE": persona["signature"],
    "TAGLINE": persona["tagline"],
    "PROFESSIONAL_ROLE": persona["professional_role"],
}

for i in range(16):
    tokens[f"ANSI_{i}"] = v[f"ansi_{i}"]

targets = [
    ("wezterm/nocturne.toml.tpl", [
        "theme/generated/wezterm/nocturne.toml",
        "windows/config/wezterm/colors/nocturne.toml",
    ]),
    ("windows-terminal/scheme.json.tpl", [
        "theme/generated/windows-terminal/scheme.json",
        "windows/config/windows-terminal/scheme.json",
    ]),
    ("tmux/theme.conf.tpl", [
        "theme/generated/tmux/theme-generated.conf",
        "tmux/.config/tmux/theme-generated.conf",
    ]),
    ("starship/starship.toml.tpl", [
        "theme/generated/starship/starship.toml",
        "starship/.config/starship.toml",
    ]),
    ("starship/starship-pwsh.toml.tpl", [
        "theme/generated/starship/starship-pwsh.toml",
        "windows/config/starship/starship.toml",
    ]),
    ("nvim/theme_generated.lua.tpl", [
        "theme/generated/nvim/theme_generated.lua",
        "nvim/.config/nvim/lua/config/theme_generated.lua",
    ]),
    ("yazi/theme.toml.tpl", [
        "theme/generated/yazi/theme.toml",
        "yazi/.config/yazi/theme.toml",
    ]),
    ("btop/nocturne.theme.tpl", [
        "theme/generated/btop/nocturne.theme",
        "btop/.config/btop/themes/nocturne.theme",
    ]),
    ("lazygit/theme.yml.tpl", [
        "theme/generated/lazygit/theme.yml",
        "lazygit/.config/lazygit/theme.yml",
    ]),
    ("lazydocker/config.yml.tpl", [
        "theme/generated/lazydocker/config.yml",
        "lazydocker/.config/lazydocker/config.yml",
    ]),
    ("lazysql/theme.toml.tpl", [
        "theme/generated/lazysql/theme.toml",
    ]),
    ("fzf/fzf-theme.sh.tpl", [
        "theme/generated/fzf/fzf-theme.sh",
    ]),
    ("bat/config.tpl", [
        "theme/generated/bat/config",
    ]),
    ("delta/delta-theme.gitconfig.tpl", [
        "theme/generated/delta/delta-theme.gitconfig",
        "git/.config/git/delta-theme.gitconfig",
    ]),
    ("eza/eza-colors.sh.tpl", [
        "theme/generated/eza/eza-colors.sh",
    ]),
    ("fastfetch/config.jsonc.tpl", [
        "theme/generated/fastfetch/config.jsonc",
        "fastfetch/.config/fastfetch/config.jsonc",
    ]),
    ("fastfetch/compact.jsonc.tpl", [
        "theme/generated/fastfetch/compact.jsonc",
        "fastfetch/.config/fastfetch/compact.jsonc",
    ]),
    ("fastfetch/diagnostic.jsonc.tpl", [
        "theme/generated/fastfetch/diagnostic.jsonc",
        "fastfetch/.config/fastfetch/diagnostic.jsonc",
    ]),
    ("fastfetch/windows.jsonc.tpl", [
        "theme/generated/fastfetch/windows.jsonc",
        "windows/config/fastfetch/config.jsonc",
    ]),
    ("glazewm/theme.yaml.tpl", [
        "theme/generated/glazewm/theme.yaml",
        "windows/config/glazewm/theme.yaml",
    ]),
    ("zebar/theme.css.tpl", [
        "theme/generated/zebar/theme.css",
        "windows/config/zebar/theme.css",
    ]),
]

TOKEN_RE = re.compile(r"\{\{([A-Z0-9_]+)\}\}")

def render_template(text: str, src_name: str) -> str:
    def repl(match: re.Match) -> str:
        key = match.group(1)
        if key not in tokens:
            sys.exit(f"[ERROR] Token desconhecido '{{{{{key}}}}}' em {src_name}")
        return str(tokens[key])
    rendered = TOKEN_RE.sub(repl, text)
    leftover = re.findall(r"\{\{[^}]+\}\}", rendered)
    if leftover:
        sys.exit(f"[ERROR] Tokens não resolvidos em {src_name}: {leftover}")
    return rendered

def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()

changed_count = 0
unchanged_count = 0

for tpl_rel, out_rels in targets:
    tpl_path = repo_root / "theme" / "templates" / tpl_rel
    raw = tpl_path.read_text(encoding="utf-8")
    rendered_bytes = render_template(raw, tpl_rel).encode("utf-8")
    new_hash = sha256_bytes(rendered_bytes)

    for out_rel in out_rels:
        out_path = repo_root / out_rel
        old_hash = None
        if out_path.is_file():
            old_hash = sha256_bytes(out_path.read_bytes())

        if old_hash == new_hash:
            unchanged_count += 1
            continue

        changed_count += 1
        if dry_run:
            if not quiet:
                print(f"[DRY-RUN] Atualizaria: {out_rel}")
            continue

        out_path.parent.mkdir(parents=True, exist_ok=True)
        fd, tmp_name = tempfile.mkstemp(prefix=".noc_tmp_", dir=str(out_path.parent))
        try:
            with os.fdopen(fd, "wb") as tmp_file:
                tmp_file.write(rendered_bytes)
            os.chmod(tmp_name, 0o644)
            os.replace(tmp_name, out_path)
        finally:
            if os.path.exists(tmp_name):
                os.unlink(tmp_name)

        if not quiet:
            print(f"[UPDATED] {out_rel}")

if not quiet:
    mode_label = "DRY-RUN" if dry_run else "APPLIED"
    print(f"[OK] ({mode_label}) Tema={variant} Acento={accent_name} ({accent_hex}) | alterados={changed_count} inalterados={unchanged_count}")
PYEOF
