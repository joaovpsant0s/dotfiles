# Manutenção da Workstation Windows 11 + WSL 2 (`docs/WINDOWS_MAINTENANCE.md`)

## 1. Diagnóstico Preventivo

Execute o script de diagnóstico no PowerShell 7:
```powershell
pwsh -File \\wsl.localhost\archlinux\home\JVZerinho\nocturne\windows\scripts\Invoke-WorkstationMaintenance.ps1
```

O script verifica:
- Memória física total do host (`15.71 GB`).
- Tamanho real do arquivo `ext4.vhdx` da distribuição `archlinux`.
- Disponibilidade das ferramentas visuais e CLI no PATH do Windows.
- Preservação e alerta sobre anomalias conhecidas (ex.: `.git` na raiz do perfil Windows).
