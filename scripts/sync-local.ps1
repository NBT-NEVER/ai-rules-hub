param(
    [string]$ProjectPath,
    [string]$CodexRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptRoot = $PSScriptRoot
$repoRoot = Split-Path -Parent $scriptRoot
. (Join-Path $scriptRoot 'core\env\resolve-machine-context.ps1')
$machineContext = Resolve-MachineContext -RepoRoot $repoRoot

if (-not $ProjectPath) {
    $ProjectPath = $machineContext.DefaultCursorProjectPath
}

if (-not $CodexRoot) {
    $CodexRoot = $machineContext.DefaultCodexRoot
}

& (Join-Path $scriptRoot 'core\build\build.ps1')
& (Join-Path $scriptRoot 'core\install\install-codex.ps1') -CodexRoot $CodexRoot

if ($ProjectPath) {
    & (Join-Path $scriptRoot 'core\install\install-cursor-project.ps1') -ProjectPath $ProjectPath
}

Write-Output 'SYNC_LOCAL_COMPLETE'
