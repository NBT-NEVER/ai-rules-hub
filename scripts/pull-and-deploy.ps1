param(
    [string]$ProjectPath,
    [string]$CodexRoot = 'C:\Users\18030\.codex',
    [switch]$SkipCodex
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot

if (-not (Test-Path (Join-Path $repoRoot '.git'))) {
    throw "Not a git repository: $repoRoot"
}

Push-Location $repoRoot
try {
    git pull
}
finally {
    Pop-Location
}

& (Join-Path $PSScriptRoot 'build.ps1')

if (-not $SkipCodex) {
    & (Join-Path $PSScriptRoot 'install-codex.ps1') -CodexRoot $CodexRoot
}

if ($ProjectPath) {
    & (Join-Path $PSScriptRoot 'install-cursor-project.ps1') -ProjectPath $ProjectPath
}

Write-Output 'PULL_AND_DEPLOY_COMPLETE'
