# 10-wsl-guard.zsh — Detecção de volumes NTFS (/mnt/*) e proteção de I/O no WSL 2
typeset -gA __BN_WARNED_MOUNTS

__bn_is_windows_mount() {
  local dir="${1:-$PWD}"
  [[ "$dir" == /mnt/[a-zA-Z] || "$dir" == /mnt/[a-zA-Z]/* ]]
}

__bn_wsl_chpwd_guard() {
  if __bn_is_windows_mount "$PWD"; then
    export BN_ON_WINDOWS_FS=1
    local mount_root="${PWD#/mnt/}"
    mount_root="/mnt/${mount_root%%/*}"
    if [[ -z "${__BN_WARNED_MOUNTS[$mount_root]:-}" ]]; then
      __BN_WARNED_MOUNTS[$mount_root]=1
      print -P "%F{yellow}[WSL-GUARD]%f Diretório em filesystem NTFS (%B$mount_root%b). Verificações Git pesadas foram reduzidas; mantenha projetos em %B~%b (ext4)." >&2
    fi
  else
    unset BN_ON_WINDOWS_FS
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd __bn_wsl_chpwd_guard
__bn_wsl_chpwd_guard
