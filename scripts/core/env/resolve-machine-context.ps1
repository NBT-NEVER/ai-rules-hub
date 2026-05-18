Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-RepoRootFromScriptPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ScriptPath
    )

    return (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $ScriptPath)))
}

function Resolve-MachineContext {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepoRoot
    )

    $normalizedRepoRoot = [System.IO.Path]::GetFullPath($RepoRoot)
    $defaultCodexRoot = Join-Path $env:USERPROFILE '.codex'

    $localRepoRoot = [System.IO.Path]::GetFullPath('I:\STUDY\python\project\backup-test-cursor\ai-rules-hub')
    $remoteRepoRoot = [System.IO.Path]::GetFullPath('I:\PYTHON\OWN_PROJECT\backup-test-cursor\ai-rules-hub')

    if ($normalizedRepoRoot -eq $localRepoRoot) {
        return [pscustomobject]@{
            MachineRole = 'local'
            RepoRoot = $normalizedRepoRoot
            DefaultCursorProjectPath = 'I:\STUDY\python\project\backup-test-cursor\cursor-workplace'
            DefaultCodexRoot = $defaultCodexRoot
        }
    }

    if ($normalizedRepoRoot -eq $remoteRepoRoot) {
        return [pscustomobject]@{
            MachineRole = 'remote'
            RepoRoot = $normalizedRepoRoot
            DefaultCursorProjectPath = 'I:\PYTHON\OWN_PROJECT\backup-test-cursor\workplace'
            DefaultCodexRoot = $defaultCodexRoot
        }
    }

    throw "Unknown machine context for repo root: $normalizedRepoRoot. Update scripts/core/env/resolve-machine-context.ps1 or pass explicit paths."
}
