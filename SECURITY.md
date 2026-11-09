# Política de Segurança — `nocturne`

## Princípios de Segurança

- **Menor Privilégio**: `install.sh`, `theme/generate.sh`, `rice` e `wb` operam integralmente em user-space. `sudo` é solicitado exclusivamente em `scripts/install-packages.sh` para pacotes oficiais via `pacman`.
- **Builds AUR Seguros**: `scripts/install-packages.sh` bloqueia execução como `root` (`EUID == 0`), garantindo que `makepkg`/`yay` nunca compilem pacotes com privilégios elevados.
- **Estado Seguro (`state.env`)**: `~/.config/rice/state.env` é gravado atomicamente com permissões `0600` (diretório `0700`) e lido por parser chave-valor restrito (nunca executado via `source`).
