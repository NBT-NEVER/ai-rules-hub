param(
    [string]$CodexRoot = 'C:\Users\18030\.codex'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-RepoRoot {
    return (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)))
}

$repoRoot = Get-RepoRoot
$distRoot = Join-Path $repoRoot 'dist'
$manifestPath = Join-Path $distRoot 'manifest.json'
$codexDistRoot = Join-Path $distRoot 'codex'

if (-not (Test-Path $manifestPath)) {
    throw 'dist/manifest.json not found. Run scripts/build.ps1 first.'
}

$manifest = Get-Content -Raw -Encoding UTF8 $manifestPath | ConvertFrom-Json
$targetSkillsRoot = Join-Path $CodexRoot 'skills'

New-Item -ItemType Directory -Path $targetSkillsRoot -Force | Out-Null
Copy-Item (Join-Path $codexDistRoot 'AGENTS.md') (Join-Path $CodexRoot 'AGENTS.md') -Force

foreach ($legacyDirectory in $manifest.legacyCodexSkillDirectories) {
    $legacyPath = Join-Path $targetSkillsRoot $legacyDirectory
    if (Test-Path $legacyPath) {
        Remove-Item -Recurse -Force $legacyPath
    }
}

foreach ($skill in $manifest.managedSkills) {
    $targetPath = Join-Path $targetSkillsRoot $skill.DirectoryName
    if (Test-Path $targetPath) {
        Remove-Item -Recurse -Force $targetPath
    }

    $sourcePath = Join-Path (Join-Path $codexDistRoot 'skills') $skill.DirectoryName
    Copy-Item $sourcePath $targetPath -Recurse -Force
}

Write-Output 'CODEX_INSTALL_COMPLETE'
