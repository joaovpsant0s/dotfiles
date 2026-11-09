<#
.SYNOPSIS
    Sincroniza configurações geradas pelo nocturne (WSL 2) para o host Windows 11.
.DESCRIPTION
    Mescla de forma não-destrutiva o settings.json do Windows Terminal (perfis 'Arch · WSL'
    e 'PowerShell · host' + esquema Nocturne), configura o $PROFILE do PowerShell 7 e 5.1,
    e sincroniza Starship, Fastfetch, WezTerm, GlazeWM e Zebar com backup prévio e suporte a -WhatIf.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$WslDistro = 'archlinux',
    [string]$WslRepoPath = '/home/JVZerinho/nocturne',
    [switch]$Quiet
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$UncRoot = "\\wsl.localhost\$WslDistro" + ($WslRepoPath -replace '/', '\')
if (-not (Test-Path $UncRoot)) {
    throw "Caminho UNC do repositório WSL não encontrado: $UncRoot"
}

$WinConfigSource = Join-Path $UncRoot 'windows\config'
$BackupRoot      = Join-Path $env:LOCALAPPDATA ("nocturne\backups\" + (Get-Date -Format 'yyyyMMdd-HHmmss'))

$SyncMappings = @(
    @{
        Name   = 'PowerShell Starship (starship.toml)'
        Source = Join-Path $WinConfigSource 'starship\starship.toml'
        Target = Join-Path $HOME '.config\starship\starship.toml'
    },
    @{
        Name   = 'PowerShell 7 Profile'
        Source = Join-Path $WinConfigSource 'powershell\Microsoft.PowerShell_profile.ps1'
        Target = Join-Path $HOME 'Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
    },
    @{
        Name   = 'Windows PowerShell 5.1 Profile'
        Source = Join-Path $WinConfigSource 'powershell\Microsoft.PowerShell_profile.ps1'
        Target = Join-Path $HOME 'Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1'
    },
    @{
        Name   = 'WezTerm (wezterm.lua)'
        Source = Join-Path $WinConfigSource 'wezterm\wezterm.lua'
        Target = Join-Path $HOME '.config\wezterm\wezterm.lua'
    },
    @{
        Name   = 'WezTerm Color Scheme (nocturne.toml)'
        Source = Join-Path $WinConfigSource 'wezterm\colors\nocturne.toml'
        Target = Join-Path $HOME '.config\wezterm\colors\nocturne.toml'
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
        Name   = 'Zebar Widget Config (nocturne.zebar.json)'
        Source = Join-Path $WinConfigSource 'zebar\nocturne.zebar.json'
        Target = Join-Path $HOME '.glzr\zebar\nocturne.zebar.json'
    },
    @{
        Name   = 'Zebar HTML (nocturne.html)'
        Source = Join-Path $WinConfigSource 'zebar\nocturne.html'
        Target = Join-Path $HOME '.glzr\zebar\nocturne.html'
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
    }
)

if (-not $Quiet) {
    Write-Host "=== NOCTURNE — WINDOWS RICE & TERMINAL SYNC ===" -ForegroundColor Cyan
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

# Non-destructive merge into Windows Terminal settings.json
$WtSettingsPath = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$SchemePath     = Join-Path $WinConfigSource "windows-terminal\scheme.json"

if ((Test-Path $WtSettingsPath) -and (Test-Path $SchemePath)) {
    if ($PSCmdlet.ShouldProcess($WtSettingsPath, "Mesclar esquema Nocturne e perfis 'Arch · WSL' / 'PowerShell · host' no Windows Terminal")) {
        New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null
        Copy-Item -Path $WtSettingsPath -Destination (Join-Path $BackupRoot "WindowsTerminal_settings.json.bak") -Force

        # Strip single-line // comments if present in JSONC before parsing
        $rawWt = (Get-Content -Path $WtSettingsPath -Raw) -replace '(?m)^\s*//.*$', ''
        $wtObj = $rawWt | ConvertFrom-Json
        $schemeObj = (Get-Content -Path $SchemePath -Raw) | ConvertFrom-Json

        # Check if GeistMono Nerd Font is installed, else fallback to Geist Mono
        $userFontDir = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'
        $hasNerdFont = (Test-Path $userFontDir) -and (@(Get-ChildItem -Path $userFontDir -Filter "GeistMono*NerdFont*.ttf" -ErrorAction SilentlyContinue).Count -gt 0)
        $fontFace    = if ($hasNerdFont) { "GeistMono Nerd Font" } else { "Geist Mono" }

        # Update or add Nocturne color scheme
        $existingSchemes = @()
        if ($wtObj.PSObject.Properties['schemes'] -and $null -ne $wtObj.schemes) {
            $existingSchemes = @($wtObj.schemes | Where-Object { $_.name -ne 'Nocturne' })
        }
        $existingSchemes += $schemeObj
        $wtObj.schemes = $existingSchemes

        # Update defaults
        if (-not $wtObj.profiles.PSObject.Properties['defaults']) {
            $wtObj.profiles | Add-Member -NotePropertyName 'defaults' -NotePropertyValue ([pscustomobject]@{})
        }
        $wtObj.profiles.defaults | Add-Member -NotePropertyName 'colorScheme' -NotePropertyValue 'Nocturne' -Force
        $wtObj.profiles.defaults | Add-Member -NotePropertyName 'padding' -NotePropertyValue '12, 10, 12, 10' -Force
        $wtObj.profiles.defaults | Add-Member -NotePropertyName 'opacity' -NotePropertyValue 100 -Force
        $wtObj.profiles.defaults | Add-Member -NotePropertyName 'cursorShape' -NotePropertyValue 'filledBox' -Force
        $wtObj.profiles.defaults | Add-Member -NotePropertyName 'font' -NotePropertyValue ([pscustomobject]@{
            face = $fontFace
            size = 11
        }) -Force

        # Customize Arch WSL and PowerShell profiles while preserving GUIDs
        foreach ($prof in $wtObj.profiles.list) {
            if ($prof.name -match 'archlinux|Arch' -or ($prof.PSObject.Properties['source'] -and $prof.source -eq 'Microsoft.WSL')) {
                $prof | Add-Member -NotePropertyName 'name' -NotePropertyValue 'Arch · WSL' -Force
                $prof | Add-Member -NotePropertyName 'tabTitle' -NotePropertyValue 'Arch · WSL' -Force
                $prof | Add-Member -NotePropertyName 'colorScheme' -NotePropertyValue 'Nocturne' -Force
                $prof | Add-Member -NotePropertyName 'cursorColor' -NotePropertyValue '#7aa2f7' -Force
                $prof | Add-Member -NotePropertyName 'bellStyle' -NotePropertyValue 'none' -Force
            }
            elseif ($prof.PSObject.Properties['source'] -and $prof.source -eq 'Windows.Terminal.PowershellCore') {
                $prof | Add-Member -NotePropertyName 'name' -NotePropertyValue 'PowerShell · host' -Force
                $prof | Add-Member -NotePropertyName 'tabTitle' -NotePropertyValue 'PowerShell · host' -Force
                $prof | Add-Member -NotePropertyName 'colorScheme' -NotePropertyValue 'Nocturne' -Force
                $prof | Add-Member -NotePropertyName 'cursorColor' -NotePropertyValue '#bb9af7' -Force
                $prof | Add-Member -NotePropertyName 'bellStyle' -NotePropertyValue 'none' -Force
            }
        }

        $wtObj | ConvertTo-Json -Depth 16 | Set-Content -Path $WtSettingsPath -Encoding UTF8
        if (-not $Quiet) {
            Write-Host "[SYNCED] Windows Terminal settings.json (Arch · WSL & PowerShell · host) -> $WtSettingsPath" -ForegroundColor Green
        }
    }
}
