# Otimização do WSL 2 e Ativação do Systemd (`docs/WSL_OPTIMIZATION.md`)

## 1. Ativando o `systemd` no Arch Linux WSL 2

A auditoria baseline identificou que o PID 1 atual é `/init`. O arquivo `wsl-system/wsl.conf` já está preparado com `systemd = true` e `hostname = arch`.

Para ativar com segurança e backup:
```bash
sudo cp /etc/wsl.conf /etc/wsl.conf.bak.$(date +%Y%m%d)
sudo cp ~/nocturne/wsl-system/wsl.conf /etc/wsl.conf
```
Em seguida, no PowerShell do Windows:
```powershell
wsl --terminate archlinux
```
Ao reabrir o WSL, verifique com `systemctl is-system-running` e `ps -p 1 -o comm=`.

## 2. Limites de Recursos (`.wslconfig`)

Copie `wsl-system/.wslconfig.example` para `C:\Users\joaovpsantos\.wslconfig` caso deseje limitar o consumo da VM WSL2 em `8GB` de RAM e `8` núcleos lógicos (ideal para o Intel Core i5-13420H com 16 GB de RAM).

## 3. Guard de Filesystem NTFS (`/mnt/*`)

O módulo `zsh/.config/zsh/conf.d/10-wsl-guard.zsh` e o `workbench` (`wb`) detectam automaticamente diretórios sob `/mnt/c`, `/mnt/d`, etc., desativando varreduras caras de arquivos não rastreados no `git status` e recomendando manter projetos no filesystem `ext4` (`~`).
