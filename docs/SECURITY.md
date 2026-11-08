# Segurança, Permissões e Proteção de Segredos (`docs/SECURITY.md`)

## 1. Controles Técnicos Implementados

- **Isolamento de Estado (`0600`)**: `~/.config/rice/state.env` é criado com `chmod 600` em diretório `0700` e lido via parser determinístico em AWK/Python (jamais executado como script shell via `source`).
- **Proteção contra Execução Silenciosa na Monitoria (`wb algo-check`)**: exibe o caminho e o hash SHA-256 do código-fonte antes de compilar/executar, exige confirmação interativa (ou `--yes` explícito em scripts de teste) e aplica `timeout 5s`.
- **Separação de Identidade Pública vs Privada**: `identity/persona.toml` e `git/.config/git/config` não armazenam e-mails privados ou tokens. Configurações locais de e-mail/assinatura GPG ficam em `~/.config/git/config.local` (ignorado pelo repositório).
- **Validação Automática**: `theme/validate.sh` verifica se nenhum endereço de e-mail foi acidentalmente inserido em `identity/persona.toml`.
