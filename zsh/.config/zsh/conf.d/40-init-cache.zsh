# 40-init-cache.zsh — Cache de scripts de init (starship, zoxide, atuin, direnv) com invalidação
__nocturne_cached_eval() {
  local name="$1"
  local bin_path="$2"
  local cfg_path="$3"
  shift 3

  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/init"
  local cache_file="$cache_dir/${name}.zsh"
  local rebuild=0

  if [[ ! -s "$cache_file" ]]; then
    rebuild=1
  elif [[ -n "$bin_path" && -f "$bin_path" && "$bin_path" -nt "$cache_file" ]]; then
    rebuild=1
  elif [[ -n "$cfg_path" && -f "$cfg_path" && "$cfg_path" -nt "$cache_file" ]]; then
    rebuild=1
  fi

  if (( rebuild )); then
    mkdir -p "$cache_dir"
    "$@" >| "$cache_file" 2>/dev/null || rm -f "$cache_file"
  fi

  [[ -f "$cache_file" ]] && source "$cache_file"
}

if (( $+commands[zoxide] )); then
  __nocturne_cached_eval "zoxide" "$commands[zoxide]" "" zoxide init zsh
fi

if (( $+commands[atuin] )); then
  __nocturne_cached_eval "atuin" "$commands[atuin]" "$XDG_CONFIG_HOME/atuin/config.toml" atuin init zsh --disable-up-arrow
fi

if (( $+commands[direnv] )); then
  __nocturne_cached_eval "direnv" "$commands[direnv]" "" direnv hook zsh
fi
