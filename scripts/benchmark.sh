#!/usr/bin/env bash
# =============================================================================
# NOCTURNE — REAL STATISTICAL BENCHMARK SUITE
# Mede Cold, Warm, Média, Mediana e P95 reais usando Python time.perf_counter
# NUNCA inventa resultados para ferramentas não instaladas
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RUNS="${1:-10}"

python3 - "$REPO_ROOT" "$RUNS" << 'PYEOF'
import math
import shutil
import statistics
import subprocess
import sys
import time

repo_root = sys.argv[1]
runs = int(sys.argv[2])

def percentile(sorted_vals, pct):
    if not sorted_vals:
        return 0.0
    k = (len(sorted_vals) - 1) * (pct / 100.0)
    f = math.floor(k)
    c = math.ceil(k)
    if f == c:
        return sorted_vals[int(k)]
    return sorted_vals[f] * (c - k) + sorted_vals[c] * (k - f)

def bench_cmd(label, cmd, n=runs):
    times_ms = []
    for _ in range(n):
        t0 = time.perf_counter()
        res = subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        t1 = time.perf_counter()
        if res.returncode != 0:
            print(f"  [ERROR] {label}: comando retornou código {res.returncode}")
            return
        times_ms.append((t1 - t0) * 1000.0)

    cold = times_ms[0]
    warm_samples = times_ms[1:] if len(times_ms) > 1 else times_ms
    warm_min = min(warm_samples)
    mean = statistics.mean(times_ms)
    median = statistics.median(times_ms)
    p95 = percentile(sorted(times_ms), 95)
    print(f"  {label:<32} | cold={cold:6.2f}ms | warm_min={warm_min:6.2f}ms | mean={mean:6.2f}ms | median={median:6.2f}ms | p95={p95:6.2f}ms (n={n})")

print("╭───────────────────────────────────────────────────────────────────────────────────────────────╮")
print("│  NOCTURNE — BENCHMARK REAL DE INICIALIZAÇÃO E ENGINE                                    │")
print("╰───────────────────────────────────────────────────────────────────────────────────────────────╯")

bench_cmd("theme/generate.sh (idempotent)", [f"{repo_root}/theme/generate.sh", "--quiet"], n=runs)
bench_cmd("wb algo --dry-run", [f"{repo_root}/rice-bin/.local/bin/wb", "algo", "--dry-run"], n=runs)
bench_cmd("bash -i -c exit", ["bash", "-i", "-c", "exit"], n=runs)

if shutil.which("zsh"):
    bench_cmd("zsh -i -c exit", ["zsh", "-i", "-c", "exit"], n=runs)
else:
    print("  zsh -i -c exit                   | [PENDENTE] pacote 'zsh' aguarda instalação via 'make install-packages'")

if shutil.which("nvim"):
    bench_cmd("nvim --headless +qa", ["nvim", "--headless", "+qa"], n=runs)
else:
    print("  nvim --headless +qa              | [PENDENTE] pacote 'neovim' aguarda instalação via 'make install-packages'")
PYEOF
