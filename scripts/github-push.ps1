param(
    [Parameter(Mandatory = $true)]
    [string]$CommitMessage,
    [string]$ProjectPath,
    [string]$CodexRoot,
    [string]$Remote = 'origin'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-CurrentBranch {
    $branch = (git branch --show-current).Trim()
    if (-not $branch) {
        throw 'Unable to determine current git branch.'
    }

    return $branch
}

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

& (Join-Path $scriptRoot 'update-from-src.ps1') -ProjectPath $ProjectPath -CodexRoot $CodexRoot

Push-Location $repoRoot
try {
    git add .

    $status = (git status --short).Trim()
    if (-not $status) {
        Write-Output 'NO_CHANGES_TO_COMMIT'
        return
    }

    git commit -m $CommitMessage

    $branch = Get-CurrentBranch
    git push -u $Remote $branch
}
finally {
    Pop-Location
}

Write-Output 'GITHUB_PUSH_COMPLETE'
