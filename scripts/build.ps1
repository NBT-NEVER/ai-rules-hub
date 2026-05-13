Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-RepoRoot {
    return (Split-Path -Parent $PSScriptRoot)
}

function Reset-Directory {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
        return
    }

    Get-ChildItem -Force -Path $Path | Remove-Item -Recurse -Force
}

function Get-SkillMetadata {
    param([Parameter(Mandatory = $true)][string]$SkillFile)

    $raw = Get-Content -Raw -Encoding UTF8 $SkillFile
    $match = [regex]::Match($raw, '^(?s)---\r?\n(?<front>.*?)\r?\n---\r?\n(?<body>.*)$')
    if (-not $match.Success) {
        throw "Invalid SKILL frontmatter: $SkillFile"
    }

    $frontmatter = $match.Groups['front'].Value
    $body = $match.Groups['body'].Value.Trim()
    $nameMatch = [regex]::Match($frontmatter, '(?m)^name:\s*(.+?)\s*$')
    $descriptionMatch = [regex]::Match($frontmatter, '(?m)^description:\s*(.+?)\s*$')

    if (-not $nameMatch.Success -or -not $descriptionMatch.Success) {
        throw "Missing name or description in: $SkillFile"
    }

    return [pscustomobject]@{
        Name = $nameMatch.Groups[1].Value.Trim()
        Description = $descriptionMatch.Groups[1].Value.Trim()
        Body = $body
    }
}

$repoRoot = Get-RepoRoot
$srcRoot = Join-Path $repoRoot 'src'
$distRoot = Join-Path $repoRoot 'dist'
$codexRoot = Join-Path $distRoot 'codex'
$codexSkillsRoot = Join-Path $codexRoot 'skills'
$cursorRoot = Join-Path $distRoot 'cursor'
$cursorProjectTemplateRoot = Join-Path $cursorRoot 'project-template'
$cursorRulesRoot = Join-Path $cursorProjectTemplateRoot '.cursor\rules'

Reset-Directory -Path $codexRoot
Reset-Directory -Path $cursorRoot

New-Item -ItemType Directory -Path $codexSkillsRoot -Force | Out-Null
New-Item -ItemType Directory -Path $cursorRulesRoot -Force | Out-Null

Copy-Item (Join-Path $srcRoot 'AGENTS.md') (Join-Path $codexRoot 'AGENTS.md') -Force
Copy-Item (Join-Path $srcRoot 'AGENTS.md') (Join-Path $cursorProjectTemplateRoot 'AGENTS.md') -Force
Copy-Item (Join-Path $srcRoot 'AGENTS.md') (Join-Path $cursorRoot 'user-rules.txt') -Force

$skillDirectories = Get-ChildItem -Path (Join-Path $srcRoot 'skills') -Directory | Sort-Object Name
$manifestSkills = @()

foreach ($skillDirectory in $skillDirectories) {
    $sourceSkillPath = $skillDirectory.FullName
    $targetCodexSkillPath = Join-Path $codexSkillsRoot $skillDirectory.Name
    Copy-Item $sourceSkillPath $targetCodexSkillPath -Recurse -Force

    $skillFile = Join-Path $sourceSkillPath 'SKILL.md'
    $metadata = Get-SkillMetadata -SkillFile $skillFile
    $cursorRulePath = Join-Path $cursorRulesRoot ($skillDirectory.Name + '.mdc')
    $cursorRuleContent = @"
---
description: $($metadata.Description)
alwaysApply: false
---
$($metadata.Body)
"@
    Set-Content -Path $cursorRulePath -Value $cursorRuleContent -Encoding UTF8

    $manifestSkills += [pscustomobject]@{
        DirectoryName = $skillDirectory.Name
        SkillName = $metadata.Name
        CursorRuleFile = $skillDirectory.Name + '.mdc'
    }
}

$manifest = [pscustomobject]@{
    generatedAt = (Get-Date).ToString('s')
    managedSkills = $manifestSkills
    legacyCodexSkillDirectories = @('codex-skill-maintainer')
    legacyCursorRuleFiles = @('codex-skill-maintainer.mdc')
}

$manifest | ConvertTo-Json -Depth 5 | Set-Content -Path (Join-Path $distRoot 'manifest.json') -Encoding UTF8
Write-Output 'BUILD_COMPLETE'
