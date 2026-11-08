<#
.SYNOPSIS
    Sincroniza configurações geradas pelo brasilia-night (WSL 2) para o host Windows 11.
.DESCRIPTION
    Copia WezTerm, GlazeWM, Zebar e Fastfetch de forma reversível (criando backup com timestamp
    antes de atualizar arquivos existentes) e suporta -WhatIf.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$WslDistro = 'archlinux',
    [string]$WslRepoPath = '/home/JVZerinho/brasilia-night',
    [switch]$Quiet
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$UncRoot = "\\wsl.localhost\$WslDistro" + ($WslRepoPath -replace '/', '\')
if (-not (Test-Path $UncRoot)) {
    throw "Caminho UNC do repositório WSL não encontrado: $UncRoot"
}

$WinConfigSource = Join-Path $UncRoot 'windows\config'
$BackupRoot      = Join-Path $env:LOCALAPPDATA ("brasilia-night\backups\" + (Get-Date -Format 'yyyyMMdd-HHmmss'))

$SyncMappings = @(
    @{
        Name   = 'WezTerm (wezterm.lua)'
        Source = Join-Path $WinConfigSource 'wezterm\wezterm.lua'
        Target = Join-Path $HOME '.config\wezterm\wezterm.lua'
    },
    @{
        Name   = 'WezTerm Color Scheme (brasilia-night.toml)'
        Source = Join-Path $WinConfigSource 'wezterm\colors\brasilia-night.toml'
        Target = Join-Path $HOME '.config\wezterm\colors\brasilia-night.toml'
    },
    @{
        Name   = 'GlazeWM (config.yaml)'
        Source = Join-Path $WinConfigSource 'glazewm\config.yaml'
        Target = Join-Path $HOME '.glzr\glazewm\config.yaml'
    },
    @{
        Name   = 'GlazeWM Theme (theme.yaml)'
        Source = Join-Path $WinConfigSource 'glazewm\theme.yaml'
        Target = Join-Path $HOME '.glzr\glazewm\theme.yaml'
    },
    @{
        Name   = 'Zebar Settings (settings.json)'
        Source = Join-Path $WinConfigSource 'zebar\settings.json'
        Target = Join-Path $HOME '.glzr\zebar\settings.json'
    },
    @{
        Name   = 'Zebar Widget Config (brasilia-night.zebar.json)'
        Source = Join-Path $WinConfigSource 'zebar\brasilia-night.zebar.json'
        Target = Join-Path $HOME '.glzr\zebar\brasilia-night.zebar.json'
    },
    @{
        Name   = 'Zebar HTML (brasilia-night.html)'
        Source = Join-Path $WinConfigSource 'zebar\brasilia-night.html'
        Target = Join-Path $HOME '.glzr\zebar\brasilia-night.html'
    },
    @{
        Name   = 'Zebar Theme CSS (theme.css)'
        Source = Join-Path $WinConfigSource 'zebar\theme.css'
        Target = Join-Path $HOME '.glzr\zebar\theme.css'
    },
    @{
        Name   = 'Windows Fastfetch (config.jsonc)'
        Source = Join-Path $WinConfigSource 'fastfetch\config.jsonc'
        Target = Join-Path $HOME '.config\fastfetch\config.jsonc'
    },
    @{
        Name   = 'Windows Fastfetch Logo (logo-brasilia.txt)'
        Source = Join-Path $WinConfigSource 'fastfetch\logo-brasilia.txt'
        Target = Join-Path $HOME '.config\fastfetch\logo-brasilia.txt'
    }
)

if (-not $Quiet) {
    Write-Host "=== BRASILIA-NIGHT — WINDOWS RICE SYNC ===" -ForegroundColor Cyan
}

foreach ($item in $SyncMappings) {
    if (-not (Test-Path $item.Source)) {
        Write-Warning "Arquivo-fonte ausente: $($item.Source)"
        continue
    }

    $needsCopy = $true
    if (Test-Path $item.Target) {
        $srcHash = (Get-FileHash -Path $item.Source -Algorithm SHA256).Hash
        $dstHash = (Get-FileHash -Path $item.Target -Algorithm SHA256).Hash
        if ($srcHash -eq $dstHash) {
            $needsCopy = $false
        }
    }

    if (-not $needsCopy) {
        if (-not $Quiet) {
            Write-Host "[UNCHANGED] $($item.Name)" -ForegroundColor DarkGray
        }
        continue
    }

    if ($PSCmdlet.ShouldProcess($item.Target, "Sincronizar $($item.Name)")) {
        $targetDir = Split-Path -Parent $item.Target
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }

        if (Test-Path $item.Target) {
            New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null
            $safeName = ($item.Target -replace '[:\\\/]', '_')
            Copy-Item -Path $item.Target -Destination (Join-Path $BackupRoot $safeName) -Force
        }

        Copy-Item -Path $item.Source -Destination $item.Target -Force
        if (-not $Quiet) {
            Write-Host "[SYNCED] $($item.Name) -> $($item.Target)" -ForegroundColor Green
        }
    }
}
