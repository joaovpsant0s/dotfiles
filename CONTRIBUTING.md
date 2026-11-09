# Guia de Contribuição e Manutenção — `nocturne`

## Regras Inegociáveis

1. **Zero Cores Hardcoded em Templates**: Qualquer alteração visual deve ser feita em `theme/palette.toml` e referenciada via tokens `{{...}}` em `theme/templates/`.
2. **Idempotência**: Scripts devem poder ser executados múltiplas vezes sem efeitos colaterais destrutivos.
3. **Validação Obrigatória**: Antes de qualquer commit, execute `make test` e `make doctor`.
4. **Sem Segredos no Git**: Jamais adicione chaves, tokens, senhas ou endereços de e-mail privados em arquivos rastreados. Use `~/.config/git/config.local` para configurações sensíveis locais.
