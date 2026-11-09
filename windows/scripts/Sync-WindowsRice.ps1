<#
.SYNOPSIS
    Sincroniza configurações geradas pelo nocturne (WSL 2) para o host Windows 11.
.DESCRIPTION
    Mescla de forma não-destrutiva o settings.json do Windows Terminal (perfis 'Arch · WSL'
    e 'PowerShell · host' + esquema Nocturne), configura o $PROFILE do PowerShell 7 e 5.1,
    e sincroniza Starship, Fastfetch, WezTerm, GlazeWM e Zebar com backup prévio e suporte a -WhatIf.
    Use -AppearanceOnly para aplicar a interface sem substituir perfis PowerShell ou a configuração principal do GlazeWM.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$WslDistro = 'archlinux',
    [string]$WslRepoPath = '/home/JVZerinho/nocturne',
    [switch]$AppearanceOnly,
    [switch]$Quiet
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$UncRoot = "\\wsl.localhost\$WslDistro" + ($WslRepoPath -replace '/', '\')
if (-not (Test-Path $UncRoot)) {
    throw "Caminho UNC do repositório WSL não encontrado: $UncRoot"
}

$WinConfigSource = Join-Path $UncRoot 'windows\config'
$BackupRoot      = Join-Path $env:LOCALAPPDATA ("nocturne\backups\" + ((Get-Date -Format 'yyyyMMdd-HHmmss-fff') + '-' + [guid]::NewGuid().ToString('N').Substring(0,8)))

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
        Name   = 'Windows Fastfetch (logo-windows.txt)'
        Source = Join-Path $WinConfigSource 'fastfetch\logo-windows.txt'
        Target = Join-Path $HOME '.config\fastfetch\logo-windows.txt'
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

if ($AppearanceOnly) {
    $SyncMappings = @($SyncMappings | Where-Object {
        $_.Name -match '^(PowerShell Starship|Windows Fastfetch|WezTerm|Zebar (HTML|Theme))'
    })
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
        $wtObj = Get-Content -LiteralPath $WtSettingsPath -Raw | ConvertFrom-Json
        $before = $wtObj | ConvertTo-Json -Depth 100
        $schemeObj = (Get-Content -Path $SchemePath -Raw) | ConvertFrom-Json

        # The Mono build keeps patched icons within one terminal cell.
        $userFontDir = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'
        $fontFace = if (Test-Path -LiteralPath (Join-Path $userFontDir 'GeistMonoNerdFontMono-Regular.otf')) {
            'GeistMono Nerd Font Mono'
        }
        elseif (Test-Path -LiteralPath (Join-Path $userFontDir 'JetBrainsMonoNerdFontMono-Regular.ttf')) {
            'JetBrainsMono Nerd Font Mono'
        }
        else {
            'Cascadia Mono'
        }

        # Update or add Nocturne color scheme
        $existingSchemes = @()
        if ($wtObj.PSObject.Properties['schemes'] -and $null -ne $wtObj.schemes) {
            $existingSchemes = @($wtObj.schemes | Where-Object { $_.name -ne 'Nocturne' })
        }
        $existingSchemes += $schemeObj
        if ($wtObj.PSObject.Properties['schemes']) {
            $wtObj.schemes = $existingSchemes
        }
        else {
            $wtObj | Add-Member -NotePropertyName 'schemes' -NotePropertyValue $existingSchemes
        }

        foreach ($prof in $wtObj.profiles.list) {
            $source = if ($prof.PSObject.Properties['source']) { $prof.source }
            if ($source -eq 'Microsoft.WSL' -and $prof.name -in @($WslDistro, 'Arch · WSL')) {
                $title = 'Arch · WSL'
                $accent = $schemeObj.brightBlue
                if (-not $prof.PSObject.Properties['startingDirectory']) {
                    $linuxHome = wsl.exe --distribution $WslDistro --cd '~' --exec pwd
                    if ($LASTEXITCODE -eq 0 -and $linuxHome -match '^/') {
                        $linuxHomeUnc = "\\wsl.localhost\$WslDistro" + ($linuxHome -replace '/', '\')
                        $prof | Add-Member -NotePropertyName 'startingDirectory' -NotePropertyValue $linuxHomeUnc
                    }
                }
            }
            elseif ($source -eq 'Windows.Terminal.PowershellCore') {
                $title = 'PowerShell · host'
                $accent = $schemeObj.brightPurple
            }
            elseif ($prof.PSObject.Properties['guid'] -and $prof.guid -eq '{61c54bbd-c2c6-5271-96e7-009a87ff44bf}') {
                $title = 'PowerShell 5.1'
                $accent = $schemeObj.brightPurple
            }
            else {
                continue
            }

            $appearance = [ordered]@{
                tabTitle = $title
                colorScheme = 'Nocturne'
                cursorColor = $accent
                cursorShape = 'bar'
                tabColor = $schemeObj.selectionBackground
                opacity = 100
                antialiasingMode = 'cleartype'
                padding = '16, 12, 16, 12'
                bellStyle = 'none'
            }
            foreach ($property in $appearance.GetEnumerator()) {
                $existing = $prof.PSObject.Properties[$property.Key]
                if ($existing) {
                    $existing.Value = $property.Value
                }
                else {
                    $prof | Add-Member -NotePropertyName $property.Key -NotePropertyValue $property.Value
                }
            }
            if (-not $prof.PSObject.Properties['font'] -or $null -eq $prof.font) {
                $prof | Add-Member -NotePropertyName 'font' -NotePropertyValue ([pscustomobject]@{}) -Force
            }
            foreach ($fontProperty in ([ordered]@{ face = $fontFace; size = 12 }).GetEnumerator()) {
                $existing = $prof.font.PSObject.Properties[$fontProperty.Key]
                if ($existing) {
                    $existing.Value = $fontProperty.Value
                }
                else {
                    $prof.font | Add-Member -NotePropertyName $fontProperty.Key -NotePropertyValue $fontProperty.Value
                }
            }
        }

        $after = $wtObj | ConvertTo-Json -Depth 100
        if ($before -ceq $after) {
            if (-not $Quiet) {
                Write-Host "[UNCHANGED] Windows Terminal settings.json" -ForegroundColor DarkGray
            }
            return
        }

        New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null
        $backup = Join-Path $BackupRoot 'WindowsTerminal_settings.json.bak'
        $temp = Join-Path (Split-Path -Parent $WtSettingsPath) ("nocturne-" + [guid]::NewGuid() + ".tmp")
        try {
            [IO.File]::WriteAllText($temp, $after + [Environment]::NewLine)
            [IO.File]::Replace($temp, $WtSettingsPath, $backup)
        }
        finally {
            if (Test-Path -LiteralPath $temp) {
                Remove-Item -LiteralPath $temp
            }
        }
        if (-not $Quiet) {
            Write-Host "[SYNCED] Windows Terminal settings.json (Arch · WSL & PowerShell · host) -> $WtSettingsPath | Backup: $backup" -ForegroundColor Green
        }
    }
}
