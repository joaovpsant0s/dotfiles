# =============================================================================
# NOCTURNE — WINDOWS POWERSHELL 7 / 5.1 PROFILE
# Prompt Starship em lilás (#bb9af7), indicador 'admin' elevado e zero lag WSL
# =============================================================================

# Detect elevated administrator privileges without spawning external processes
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)
if ($isAdmin) {
    $env:NOCTURNE_ADMIN = "admin"
} else {
    Remove-Item Env:\NOCTURNE_ADMIN -ErrorAction SilentlyContinue
}

$env:STARSHIP_CONFIG = Join-Path $HOME ".config\starship\starship.toml"

# Ensure Winget user paths are discoverable in current session
$wingetLinks = Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Links"
if ((Test-Path $wingetLinks) -and ($env:PATH -notlike "*$wingetLinks*")) {
    $env:PATH = "$wingetLinks;$env:PATH"
}
$starshipBin = "C:\Program Files\starship\bin"
if ((Test-Path $starshipBin) -and ($env:PATH -notlike "*$starshipBin*")) {
    $env:PATH = "$starshipBin;$env:PATH"
}

function Invoke-NocturneFastfetch {
    $ffCmd = Get-Command fastfetch -ErrorAction SilentlyContinue
    $cfgPath = Join-Path $HOME ".config\fastfetch\config.jsonc"
    if ($ffCmd -and (Test-Path $cfgPath)) {
        & $ffCmd.Source --config $cfgPath
    } elseif ($ffCmd) {
        & $ffCmd.Source
    }
}
Set-Alias -Name ff -Value Invoke-NocturneFastfetch

if ((Get-Command starship -ErrorAction SilentlyContinue) -and ($env:NOCTURNE_ASCII -ne "1")) {
    Invoke-Expression (&starship init powershell)
} else {
    function prompt {
        $ok = $?
        $adminPrefix = if ($env:NOCTURNE_ADMIN) { "$([char]27)[1;33madmin $([char]27)[0m" } else { "" }
        $cwd = (Get-Location).Path.Replace($HOME, "~")
        $symColor = if ($ok) { "$([char]27)[1;35m" } else { "$([char]27)[1;31m" }
        $sym = if ($env:NOCTURNE_ASCII -eq "1") { ">" } else { "❯" }
        return "`n${adminPrefix}$([char]27)[1;37m${cwd}$([char]27)[0m`n${symColor}${sym}$([char]27)[0m "
    }
}
