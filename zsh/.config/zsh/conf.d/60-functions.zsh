# 60-functions.zsh — Funções utilitárias de navegação e produtividade

# Wrapper oficial Yazi para trocar de diretório ao sair com 'q'
y() {
  if ! command -v yazi >/dev/null 2>&1; then
    echo "[WARN] yazi ainda não está instalado." >&2
    return 1
  fi
  local tmp
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

mkcd() {
  mkdir -p -- "$1" && builtin cd -- "$1"
}

git() {
  if [[ -n "${BN_ON_WINDOWS_FS:-}" && "${1:-}" == "status" ]]; then
    command git -c core.preloadindex=true -c status.showUntrackedFiles=no "$@"
  else
    command git "$@"
  fi
}
