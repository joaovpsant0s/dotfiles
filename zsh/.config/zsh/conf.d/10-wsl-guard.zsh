# 10-wsl-guard.zsh — Detecção de volumes NTFS (/mnt/*) e proteção de I/O no WSL 2
typeset -gA __NOCTURNE_WARNED_MOUNTS

__nocturne_is_windows_mount() {
  local dir="${1:-$PWD}"
  [[ "$dir" == /mnt/[a-zA-Z] || "$dir" == /mnt/[a-zA-Z]/* ]]
}

__nocturne_wsl_chpwd_guard() {
  if __nocturne_is_windows_mount "$PWD"; then
    export NOCTURNE_ON_WINDOWS_FS=1
    local mount_root="${PWD#/mnt/}"
    mount_root="/mnt/${mount_root%%/*}"
    if [[ -z "${__NOCTURNE_WARNED_MOUNTS[$mount_root]:-}" ]]; then
      __NOCTURNE_WARNED_MOUNTS[$mount_root]=1
      print -P "%F{yellow}[WSL-GUARD]%f Diretório em NTFS (%B$mount_root%b). Checagens Git pesadas desativadas; prefira o ext4 (%B~%b)." >&2
    fi
  else
    unset NOCTURNE_ON_WINDOWS_FS
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd __nocturne_wsl_chpwd_guard
__nocturne_wsl_chpwd_guard
