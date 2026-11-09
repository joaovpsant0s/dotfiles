# 60-functions.zsh — Funções utilitárias de navegação e proteção NTFS

y() {
  if ! command -v yazi >/dev/null 2>&1; then
    echo "[WARN] yazi não encontrado." >&2
    return 1
  fi
  local tmp cwd yazi_status=0
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")" || return
  yazi "$@" --cwd-file="$tmp" || yazi_status=$?
  if (( yazi_status == 0 )) && cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
  return "$yazi_status"
}

mkcd() {
  mkdir -p -- "$1" && builtin cd -- "$1"
}

git() {
  if [[ -n "${NOCTURNE_ON_WINDOWS_FS:-}" && "${1:-}" == "status" ]]; then
    command git -c core.preloadindex=true -c status.showUntrackedFiles=no "$@"
  else
    command git "$@"
  fi
}
