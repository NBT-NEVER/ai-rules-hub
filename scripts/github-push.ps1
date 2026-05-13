param(
    [Parameter(Mandatory = $true)]
    [string]$CommitMessage,
    [string]$ProjectPath = 'I:\STUDY\python\project\backup-test-cursor\cursor-workplace',
    [string]$CodexRoot = 'C:\Users\18030\.codex',
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

& (Join-Path $PSScriptRoot 'update-from-src.ps1') -ProjectPath $ProjectPath -CodexRoot $CodexRoot

$repoRoot = Split-Path -Parent $PSScriptRoot
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
