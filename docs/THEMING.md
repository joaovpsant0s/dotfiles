# Theme Engine — Single Source of Truth (`docs/THEMING.md`)

## 1. Paleta e Variantes (`theme/palette.toml`)

- **Variantes**:
  - `night` (padrão — `#1a1b26`)
  - `storm` (`#24283b`)
  - `moon` (`#222436`)
- **Acentos**:
  - `purple` (padrão — `#bb9af7`)
  - `blue` (`#7aa2f7`)
  - `cyan` (`#7dcfff`)
  - `green` (`#9ece6a`)
  - `orange` (`#ff9e64`)
  - `red` (`#f7768e`)

## 2. Regras dos temas

1. **Zero Hex Hardcoded nos Templates**: Todos os arquivos `.tpl` em `theme/templates/` usam exclusivamente placeholders `{{TOKEN}}`. O script `theme/validate.sh` falha imediatamente caso encontre qualquer literal `#[0-9a-fA-F]{6}` em um template.
2. **Escrita Atômica por Hash SHA-256**: `theme/generate.sh` calcula o hash SHA-256 do conteúdo renderizado e só substitui o arquivo de destino (via `mktemp` + `os.replace`) quando o conteúdo efetivamente mudou.
3. **Alvos Renderizados (16)**: `wezterm`, `tmux`, `starship`, `nvim`, `yazi`, `btop`, `lazygit`, `lazydocker`, `lazysql`, `fzf`, `bat`, `delta`, `eza`, `fastfetch`, `glazewm`, `zebar`.
