# Camada Visual Windows 11 (`docs/WINDOWS_RICE.md`)

## 1. Instalação de Fontes (`Install-Fonts.ps1`)

No PowerShell 7 (sem necessidade de privilégios de Administrador):

```powershell
# Apenas verificar fontes instaladas:
pwsh -File \\wsl.localhost\archlinux\home\JVZerinho\brasilia-night\windows\scripts\Install-Fonts.ps1 -CheckOnly

# Simular instalação (-WhatIf):
pwsh -File \\wsl.localhost\archlinux\home\JVZerinho\brasilia-night\windows\scripts\Install-Fonts.ps1 -WhatIf

# Instalar fontes ausentes no escopo do usuário:
pwsh -File \\wsl.localhost\archlinux\home\JVZerinho\brasilia-night\windows\scripts\Install-Fonts.ps1
```

## 2. Sincronização de Configurações (`Sync-WindowsRice.ps1`)

```powershell
# Simular sincronização (-WhatIf):
pwsh -File \\wsl.localhost\archlinux\home\JVZerinho\brasilia-night\windows\scripts\Sync-WindowsRice.ps1 -WhatIf

# Aplicar sincronização (cria backup em %LOCALAPPDATA%\brasilia-night\backups):
pwsh -File \\wsl.localhost\archlinux\home\JVZerinho\brasilia-night\windows\scripts\Sync-WindowsRice.ps1
```

## 3. Instalação Opcional dos Aplicativos Visuais via Winget

Quando desejar instalar os aplicativos visuais no Windows 11:
```powershell
winget install --id wez.wezterm -e
winget install --id glzr-io.glazewm -e
winget install --id glzr-io.zebar -e
winget install --id Fastfetch-cli.Fastfetch -e
```
