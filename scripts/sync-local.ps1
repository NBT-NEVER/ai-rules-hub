param(
    [string]$ProjectPath = 'I:\STUDY\python\project\backup-test-cursor\cursor-workplace',
    [string]$CodexRoot = 'C:\Users\18030\.codex'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptRoot = $PSScriptRoot

& (Join-Path $scriptRoot 'core\build\build.ps1')
& (Join-Path $scriptRoot 'core\install\install-codex.ps1') -CodexRoot $CodexRoot

if ($ProjectPath) {
    & (Join-Path $scriptRoot 'core\install\install-cursor-project.ps1') -ProjectPath $ProjectPath
}

Write-Output 'SYNC_LOCAL_COMPLETE'
