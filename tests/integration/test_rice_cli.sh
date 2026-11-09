#!/usr/bin/env bash
# =============================================================================
# NOCTURNE — RICE CLI & WORKBENCH INTEGRATION TESTS
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
RICE_BIN="$REPO_ROOT/rice-bin/.local/bin/rice"
WB_BIN="$REPO_ROOT/rice-bin/.local/bin/wb"
SESH_BIN="$REPO_ROOT/rice-bin/.local/bin/sesh-picker"

TMP_TEST="$(mktemp -d "${TMPDIR:-/tmp}/bn_rice_test.XXXXXX")"
trap 'rm -rf "$TMP_TEST"' EXIT

export RICE_STATE_DIR="$TMP_TEST/rice"
export RICE_STATE_FILE="$RICE_STATE_DIR/state.env"

echo "=== [TEST] 1/5 Testando inicialização de state.env e permissões 600 ==="
"$RICE_BIN" status >/dev/null
PERM="$(stat -c '%a' "$RICE_STATE_FILE")"
if [ "$PERM" != "600" ]; then
  echo "[FAIL] Permissão esperada 600 em state.env, obtida: $PERM" >&2
  exit 1
fi
echo "CUSTOM_USER_FLAG=preserve_me" >> "$RICE_STATE_FILE"

echo "=== [TEST] 2/5 Testando troca de tema: 'rice theme moon cyan --no-sync' ==="
"$RICE_BIN" theme moon cyan --no-sync >/dev/null
grep -q "^RICE_THEME=moon$" "$RICE_STATE_FILE"
grep -q "^RICE_ACCENT=cyan$" "$RICE_STATE_FILE"
grep -q "^CUSTOM_USER_FLAG=preserve_me$" "$RICE_STATE_FILE"
grep -q 'variant = "moon"' "$REPO_ROOT/nvim/.config/nvim/lua/config/theme_generated.lua"
grep -q 'accent_name = "cyan"' "$REPO_ROOT/nvim/.config/nvim/lua/config/theme_generated.lua"
echo "[OK] Troca de tema e preservação de chaves customizadas verificadas."

echo "=== [TEST] 3/5 Restaurando tema padrão (night purple) ==="
"$RICE_BIN" theme night purple --no-sync >/dev/null
grep -q "^RICE_THEME=night$" "$RICE_STATE_FILE"
grep -q "^RICE_ACCENT=purple$" "$RICE_STATE_FILE"
echo "[OK] Tema padrão restaurado."

echo "=== [TEST] 4/5 Testando os 4 layouts do Workbench (code, server, db, study) ==="
for layout in code server db study; do
  OUT="$("$WB_BIN" "$layout" "$TMP_TEST" --dry-run)"
  grep -q "^LAYOUT=$layout$" <<< "$OUT"
done
"$SESH_BIN" --list >/dev/null
echo "[OK] Todos os 4 layouts do Workbench e sesh-picker validados."

echo "=== [TEST] 5/5 Validando Fastfetch em 120, 100, 99, 80, 79 e 60 colunas (com e sem TMUX) ==="
FETCH_HOME="$TMP_TEST/fastfetch-home"
mkdir -p "$FETCH_HOME/.config"
ln -s "$REPO_ROOT/fastfetch/.config/fastfetch" "$FETCH_HOME/.config/fastfetch"
python3 - "$REPO_ROOT" "$FETCH_HOME" << 'PYEOF'
import os
import re
import subprocess
import sys

repo_root = sys.argv[1]
ff_bin = f"{repo_root}/rice-bin/.local/bin/fastfetch"
ANSI_RE = re.compile(r"\x1b\[[0-9;?]*[A-Za-z]")

for cols in (120, 100, 99, 80, 79, 60):
    for tmux_val in ("", "/tmp/tmux-1000/default,123,0"):
        env = os.environ.copy()
        env["HOME"] = sys.argv[2]
        env["TERM"] = "xterm-256color"
        env["COLUMNS"] = str(cols)
        env.pop("NOCTURNE_ASCII", None)
        env["NOCTURNE_FORCE_TTY"] = "1"
        env["XDG_CONFIG_HOME"] = f"{repo_root}/fastfetch/.config"
        if tmux_val:
            env["TMUX"] = tmux_val
        else:
            env.pop("TMUX", None)

        out = subprocess.check_output([ff_bin], env=env, text=True)
        visible_lines = [ANSI_RE.sub("", line).rstrip("\r\n") for line in out.splitlines() if line.strip()]
        max_len = max((len(l) for l in visible_lines), default=0)
        if max_len > cols:
            sys.exit(f"[FAIL] Largura visível ({max_len}) excedeu {cols} colunas (TMUX={bool(tmux_val)})!")
        joined = "\n".join(visible_lines)
        if "Arch Linux" not in joined:
            sys.exit(f"[FAIL] Título do sistema ausente em {cols} colunas.")
        wide = cols >= 80
        if ("▟" in joined) != (80 <= cols < 100) or ("ooossss" in joined) != (cols >= 100):
            sys.exit(f"[FAIL] Logo inesperado em {cols} colunas.")
        for label in ("cpu", "disk", "pkgs"):
            if bool(re.search(rf"\b{label} {{2,}}", joined)) != wide:
                sys.exit(f"[FAIL] Preset inesperado em {cols} colunas: campo {label}.")
        print(f"  [OK] cols={cols:<3} tmux={str(bool(tmux_val)):<5} -> max_visible_width={max_len} (<= {cols})")
PYEOF
