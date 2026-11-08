<#
.SYNOPSIS
    Diagnóstico e manutenção preventiva não-destrutiva da Workstation Windows 11 + WSL 2.
.DESCRIPTION
    Inspeciona o estado do WSL, tamanho do VHDX da distribuição archlinux, presença de ferramentas
    visuais (WezTerm, GlazeWM, Zebar, Fastfetch) e integridade de fontes. Suporta -WhatIf.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Write-Host "╭──────────────────────────────────────────────────────────────────╮" -ForegroundColor Cyan
Write-Host "│  BRASILIA-NIGHT — WORKSTATION DIAGNOSTICS & MAINTENANCE          │" -ForegroundColor Cyan
Write-Host "╰──────────────────────────────────────────────────────────────────╯" -ForegroundColor Cyan

# 1. Hardware & Memory Summary
$cs = Get-CimInstance Win32_ComputerSystem
$ramGB = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
Write-Host "[HOST] Memória física total: $ramGB GB"

# 2. Check WSL VHDX Size
$lxss = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss" -ErrorAction SilentlyContinue |
    ForEach-Object { Get-ItemProperty $_.PSPath } |
    Where-Object { $_.DistributionName -eq 'archlinux' }

if ($lxss -and $lxss.BasePath) {
    $vhdx = Join-Path ($lxss.BasePath -replace '^\\\\\?\\', '') 'ext4.vhdx'
    if (Test-Path $vhdx) {
        $sizeGB = [math]::Round((Get-Item $vhdx).Length / 1GB, 2)
        Write-Host "[WSL] Disco virtual archlinux (ext4.vhdx): $sizeGB GB em $vhdx" -ForegroundColor Green
    }
}

# 3. Check Windows Layer Tools
$tools = @('wezterm', 'glazewm', 'zebar', 'fastfetch', 'pwsh', 'git')
foreach ($t in $tools) {
    $cmd = Get-Command $t -ErrorAction SilentlyContinue
    if ($cmd) {
        Write-Host "[TOOL] ${t}: INSTALADO ($($cmd.Source))" -ForegroundColor Green
    } else {
        Write-Host "[TOOL] ${t}: AUSENTE no PATH Windows" -ForegroundColor Yellow
    }
}

# 4. Warn if accidental .git exists directly in $HOME
$accidentalGit = Join-Path $HOME '.git'
if (Test-Path $accidentalGit) {
    Write-Host "[WARN] Repositório Git detectado na raiz do perfil Windows ($accidentalGit). Preservado conforme regra de segurança." -ForegroundColor Yellow
}
