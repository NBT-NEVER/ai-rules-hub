param(
    [string]$ProjectPath = 'I:\STUDY\python\project\backup-test-cursor\cursor-workplace',
    [string]$CodexRoot = 'C:\Users\18030\.codex'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

& (Join-Path $PSScriptRoot 'sync-local.ps1') -ProjectPath $ProjectPath -CodexRoot $CodexRoot

Write-Output 'UPDATE_FROM_SRC_COMPLETE'
