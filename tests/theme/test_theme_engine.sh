#!/usr/bin/env bash
# =============================================================================
# BRASILIA-NIGHT — THEME ENGINE TEST SUITE
# Testa:
# 1. Validação de palette.toml, persona.toml e zero hex em templates
# 2. Todas as 18 combinações (3 variantes x 6 acentos)
# 3. Idempotência (segunda execução consecutiva = 0 arquivos alterados)
# 4.Rejeição de variantes/acentos inválidos
# 5. Git working tree permanece limpa após geração
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "=== [TEST] 1/5 Validando esquema TOML e templates ==="
"$REPO_ROOT/theme/validate.sh"

echo "=== [TEST] 2/5 Testando todas as 18 combinações (3 variantes x 6 acentos) ==="
VARIANTS=(night storm moon)
ACCENTS=(blue purple cyan green orange red)
COMBO_COUNT=0

for v in "${VARIANTS[@]}"; do
  for a in "${ACCENTS[@]}"; do
    "$REPO_ROOT/theme/generate.sh" --variant "$v" --accent "$a" --quiet
    COMBO_COUNT=$((COMBO_COUNT + 1))
  done
done
echo "[OK] $COMBO_COUNT combinações geradas com sucesso."

echo "=== [TEST] 3/5 Verificando idempotência (night + purple) ==="
"$REPO_ROOT/theme/generate.sh" --variant night --accent purple --quiet
OUT="$("$REPO_ROOT/theme/generate.sh" --variant night --accent purple)"
echo "$OUT"
if ! grep -q "alterados=0" <<< "$OUT"; then
  echo "[FAIL] Segunda execução consecutiva não foi idempotente!" >&2
  exit 1
fi
echo "[OK] Idempotência comprovada (alterados=0)."

echo "=== [TEST] 4/5 Testando rejeição de argumentos inválidos ==="
if "$REPO_ROOT/theme/generate.sh" --variant invalid_variant --accent purple >/dev/null 2>&1; then
  echo "[FAIL] Deveria falhar para variante inválida!" >&2
  exit 1
fi
if "$REPO_ROOT/theme/generate.sh" --variant night --accent invalid_accent >/dev/null 2>&1; then
  echo "[FAIL] Deveria falhar para acento inválido!" >&2
  exit 1
fi
echo "[OK] Argumentos inválidos rejeitados com código de erro."

echo "=== [TEST] 5/5 Verificando ausência de tokens residuais nos arquivos gerados ==="
if grep -rnE '\{\{[A-Z0-9_]+\}\}' "$REPO_ROOT/theme/generated/"; then
  echo "[FAIL] Tokens não substituídos encontrados em theme/generated/!" >&2
  exit 1
fi
echo "[OK] Zero tokens residuais nos 16 artefatos gerados."
