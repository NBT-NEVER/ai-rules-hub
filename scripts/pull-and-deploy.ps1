param(
    [string]$ProjectPath,
    [string]$CodexRoot,
    [switch]$SkipCodex
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot 'core\env\resolve-machine-context.ps1')
$machineContext = Resolve-MachineContext -RepoRoot $repoRoot

if (-not $ProjectPath) {
    $ProjectPath = $machineContext.DefaultCursorProjectPath
}

if (-not $CodexRoot) {
    $CodexRoot = $machineContext.DefaultCodexRoot
}

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

& (Join-Path $PSScriptRoot 'core\build\build.ps1')

if (-not $SkipCodex) {
    & (Join-Path $PSScriptRoot 'core\install\install-codex.ps1') -CodexRoot $CodexRoot
}

if ($ProjectPath) {
    & (Join-Path $PSScriptRoot 'core\install\install-cursor-project.ps1') -ProjectPath $ProjectPath
}

Write-Output 'PULL_AND_DEPLOY_COMPLETE'
