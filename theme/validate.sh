#!/usr/bin/env bash
# =============================================================================
# NOCTURNE — THEME & PERSONA VALIDATOR
# Valida palette.toml, persona.toml e garante zero hex hardcoded em templates
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PALETTE_FILE="${1:-$REPO_ROOT/theme/palette.toml}"
PERSONA_FILE="${2:-$REPO_ROOT/identity/persona.toml}"
TEMPLATES_DIR="$REPO_ROOT/theme/templates"

python3 - "$PALETTE_FILE" "$PERSONA_FILE" "$TEMPLATES_DIR" << 'PYEOF'
import pathlib
import re
import sys
import tomllib

palette_path = pathlib.Path(sys.argv[1])
persona_path = pathlib.Path(sys.argv[2])
templates_dir = pathlib.Path(sys.argv[3])

HEX_RE = re.compile(r"^#[0-9a-fA-F]{6}$")
INLINE_HEX_RE = re.compile(r"#[0-9a-fA-F]{6}\b")

if not palette_path.is_file():
    sys.exit(f"[ERROR] Arquivo de paleta ausente: {palette_path}")
if not persona_path.is_file():
    sys.exit(f"[ERROR] Arquivo de persona ausente: {persona_path}")

with palette_path.open("rb") as f:
    palette = tomllib.load(f)

with persona_path.open("rb") as f:
    persona = tomllib.load(f)

required_persona_str = [
    "owner_name",
    "display_name",
    "username",
    "github_username",
    "hostname",
    "signature",
    "tagline",
    "professional_role",
]
for key in required_persona_str:
    val = persona.get(key)
    if not isinstance(val, str) or not val.strip():
        sys.exit(f"[ERROR] identity/persona.toml: campo obrigatório inválido ou vazio: '{key}'")

for list_key in ("primary_languages", "technical_focus"):
    val = persona.get(list_key)
    if not isinstance(val, list) or not val or not all(isinstance(x, str) and x.strip() for x in val):
        sys.exit(f"[ERROR] identity/persona.toml: lista obrigatória inválida: '{list_key}'")

raw_persona = persona_path.read_text(encoding="utf-8")
if re.search(r"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}", raw_persona):
    sys.exit("[ERROR] identity/persona.toml não deve conter endereços de e-mail públicos.")

meta = palette.get("meta", {})
expected_variants = ["night", "storm", "moon"]
expected_accents = ["blue", "purple", "cyan", "green", "orange", "red"]

if meta.get("variants") != expected_variants:
    sys.exit(f"[ERROR] meta.variants inválido: {meta.get('variants')}")
if meta.get("accents") != expected_accents:
    sys.exit(f"[ERROR] meta.accents inválido: {meta.get('accents')}")

accents_map = palette.get("accents", {})
for acc in expected_accents:
    color = accents_map.get(acc, "")
    if not isinstance(color, str) or not HEX_RE.match(color):
        sys.exit(f"[ERROR] Cor de acento inválida para '{acc}': {color!r}")

required_variant_keys = [
    "background",
    "background_alt",
    "surface",
    "surface_alt",
    "foreground",
    "foreground_muted",
    "foreground_subtle",
    "accent_secondary",
    "border",
    "selection",
    "cursor",
    "success",
    "warning",
    "error",
    "info",
] + [f"ansi_{i}" for i in range(16)]

variants_map = palette.get("variants", {})
for var_name in expected_variants:
    var_data = variants_map.get(var_name)
    if not isinstance(var_data, dict):
        sys.exit(f"[ERROR] Variante ausente em [variants.{var_name}]")
    for k in required_variant_keys:
        c = var_data.get(k, "")
        if not isinstance(c, str) or not HEX_RE.match(c):
            sys.exit(f"[ERROR] Cor inválida em [variants.{var_name}].{k}: {c!r}")

tpl_files = sorted(templates_dir.rglob("*.tpl"))
if len(tpl_files) < 16:
    sys.exit(f"[ERROR] Esperados pelo menos 16 templates em {templates_dir}, encontrados {len(tpl_files)}")

for tpl in tpl_files:
    content = tpl.read_text(encoding="utf-8")
    matches = INLINE_HEX_RE.findall(content)
    if matches:
        sys.exit(f"[ERROR] Hex color literal encontrado no template {tpl}: {matches}")

print(f"[OK] Validação concluída: {len(expected_variants)} variantes, {len(expected_accents)} acentos, {len(tpl_files)} templates limpos.")
PYEOF
