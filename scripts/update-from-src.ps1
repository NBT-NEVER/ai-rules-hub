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

& (Join-Path $scriptRoot 'sync-local.ps1') -ProjectPath $ProjectPath -CodexRoot $CodexRoot

Write-Output 'UPDATE_FROM_SRC_COMPLETE'
