param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-RepoRoot {
    return (Split-Path -Parent $PSScriptRoot)
}

$repoRoot = Get-RepoRoot
$distRoot = Join-Path $repoRoot 'dist'
$manifestPath = Join-Path $distRoot 'manifest.json'
$cursorTemplateRoot = Join-Path $distRoot 'cursor\project-template'
$targetRulesRoot = Join-Path $ProjectPath '.cursor\rules'

if (-not (Test-Path $ProjectPath)) {
    throw "Cursor project path not found: $ProjectPath"
}

if (-not (Test-Path $manifestPath)) {
    throw 'dist/manifest.json not found. Run scripts/build.ps1 first.'
}

$manifest = Get-Content -Raw -Encoding UTF8 $manifestPath | ConvertFrom-Json

New-Item -ItemType Directory -Path $targetRulesRoot -Force | Out-Null
Copy-Item (Join-Path $cursorTemplateRoot 'AGENTS.md') (Join-Path $ProjectPath 'AGENTS.md') -Force

foreach ($legacyRule in $manifest.legacyCursorRuleFiles) {
    $legacyPath = Join-Path $targetRulesRoot $legacyRule
    if (Test-Path $legacyPath) {
        Remove-Item -Force $legacyPath
    }
}

foreach ($skill in $manifest.managedSkills) {
    $targetRulePath = Join-Path $targetRulesRoot $skill.CursorRuleFile
    if (Test-Path $targetRulePath) {
        Remove-Item -Force $targetRulePath
    }

    $sourceRulePath = Join-Path (Join-Path $cursorTemplateRoot '.cursor\rules') $skill.CursorRuleFile
    Copy-Item $sourceRulePath $targetRulePath -Force
}

Write-Output 'CURSOR_PROJECT_INSTALL_COMPLETE'
