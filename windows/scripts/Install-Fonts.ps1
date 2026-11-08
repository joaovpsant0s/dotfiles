<#
.SYNOPSIS
    Instala ou verifica as fontes GeistMono Nerd Font, JetBrainsMono Nerd Font e Symbols Nerd Font Mono.
.DESCRIPTION
    Prioriza instalação em escopo de usuário ($env:LOCALAPPDATA\Microsoft\Windows\Fonts),
    detecta famílias já presentes em C:\Windows\Fonts, cria backup de conflitos e suporta -WhatIf.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$CheckOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$SystemFontDir = Join-Path $env:WINDIR 'Fonts'
$UserFontDir   = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'

$FontTargets = @(
    @{
        Name       = 'GeistMono Nerd Font'
        Pattern    = 'GeistMono*NerdFont*.ttf'
        BaseFamily = 'GeistMono-*.ttf'
        ArchiveUrl = 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/GeistMono.zip'
    },
    @{
        Name       = 'JetBrainsMono Nerd Font'
        Pattern    = 'JetBrainsMono*NerdFont*.ttf'
        BaseFamily = 'JetBrainsMono-*.ttf'
        ArchiveUrl = 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip'
    },
    @{
        Name       = 'Symbols Nerd Font Mono'
        Pattern    = 'SymbolsNerdFontMono*.ttf'
        BaseFamily = 'SymbolsNerdFontMono*.ttf'
        ArchiveUrl = 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip'
    }
)

Write-Host "=== BRASILIA-NIGHT — AUDITORIA & INSTALAÇÃO DE FONTES ===" -ForegroundColor Cyan

foreach ($font in $FontTargets) {
    $installedNerd = @()
    if (Test-Path $SystemFontDir) {
        $installedNerd += Get-ChildItem -Path $SystemFontDir -Filter $font.Pattern -ErrorAction SilentlyContinue
    }
    if (Test-Path $UserFontDir) {
        $installedNerd += Get-ChildItem -Path $UserFontDir -Filter $font.Pattern -ErrorAction SilentlyContinue
    }

    $installedBase = @()
    if (Test-Path $SystemFontDir) {
        $installedBase += Get-ChildItem -Path $SystemFontDir -Filter $font.BaseFamily -ErrorAction SilentlyContinue
    }

    if ($installedNerd.Count -gt 0) {
        Write-Host "[OK] $($font.Name): $($installedNerd.Count) arquivos Nerd Font encontrados." -ForegroundColor Green
        continue
    }

    if ($installedBase.Count -gt 0) {
        Write-Host "[INFO] $($font.Name): variante base encontrada ($($installedBase.Count) arquivos em C:\Windows\Fonts), mas variante Nerd Font ausente." -ForegroundColor Yellow
    } else {
        Write-Host "[MISSING] $($font.Name): ausente." -ForegroundColor Yellow
    }

    if ($CheckOnly) {
        continue
    }

    if ($PSCmdlet.ShouldProcess($UserFontDir, "Baixar e instalar $($font.Name) em escopo de usuário")) {
        New-Item -ItemType Directory -Path $UserFontDir -Force | Out-Null
        $tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) ("bn-fonts-" + [guid]::NewGuid().ToString("N"))
        New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null
        try {
            $zipPath = Join-Path $tmpDir "font.zip"
            Invoke-WebRequest -Uri $font.ArchiveUrl -OutFile $zipPath -UseBasicParsing
            Expand-Archive -Path $zipPath -DestinationPath $tmpDir -Force
            $ttfFiles = Get-ChildItem -Path $tmpDir -Include "*.ttf", "*.otf" -Recurse |
                        Where-Object { $_.Name -notmatch "Windows Compatible" }

            $regPath = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'
            foreach ($ttf in $ttfFiles) {
                $dest = Join-Path $UserFontDir $ttf.Name
                if (-not (Test-Path $dest)) {
                    Copy-Item -Path $ttf.FullName -Destination $dest -Force
                    New-ItemProperty -Path $regPath -Name "$($ttf.BaseName) (TrueType)" -Value $dest -PropertyType String -Force | Out-Null
                }
            }
            Write-Host "[INSTALLED] $($font.Name) instalada em $UserFontDir" -ForegroundColor Green
        } finally {
            if (Test-Path $tmpDir) {
                Remove-Item -Path $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    }
}
