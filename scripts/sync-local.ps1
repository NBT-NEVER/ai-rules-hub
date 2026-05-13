param(
    [string]$ProjectPath,
    [string]$CodexRoot = 'C:\Users\18030\.codex'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptRoot = $PSScriptRoot

& (Join-Path $scriptRoot 'build.ps1')
& (Join-Path $scriptRoot 'install-codex.ps1') -CodexRoot $CodexRoot

if ($ProjectPath) {
    & (Join-Path $scriptRoot 'install-cursor-project.ps1') -ProjectPath $ProjectPath
}

Write-Output 'SYNC_LOCAL_COMPLETE'
