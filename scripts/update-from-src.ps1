Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'

$scriptRoot = $PSScriptRoot
$coreRoot = Join-Path $scriptRoot 'core'
. (Join-Path $coreRoot 'common.ps1')

$scriptFailed = $false
$repoRoot = $null
$config = $null
$choice = $null
$codexRoot = $null
$cursorProjectPath = $null
$global:LASTEXITCODE = 0

$config = Get-AddressConfig

if (Test-IsRepoScriptsLayout -ScriptsRoot $scriptRoot) {
    $repoRoot = Use-CurrentRepoPath -Config $config -ScriptsRoot $scriptRoot
}
else {
    $repoRoot = Ensure-LocalRepoPath -Config $config -ScriptsRoot $scriptRoot
}

if (-not (Test-Path (Join-Path $repoRoot 'scripts\core\build\build.ps1'))) {
    Write-Host ('Error: build script not found: ' + $repoRoot)
    $scriptFailed = $true
}

if (-not $scriptFailed) {
    Write-Host 'Select update target:'
    Write-Host '1. Update Codex skills'
    Write-Host '2. Update Cursor skills'
    Write-Host '3. Update both Codex and Cursor skills'
    $choice = Read-Host 'Enter 1, 2, or 3'

    if ($choice -eq '1') {
        $codexRoot = Ensure-CodexRoot -Config $config
    }
    elseif ($choice -eq '2') {
        $cursorProjectPath = Ensure-CursorProjectPath -Config $config
    }
    elseif ($choice -eq '3') {
        $codexRoot = Ensure-CodexRoot -Config $config
        $cursorProjectPath = Ensure-CursorProjectPath -Config $config
    }
    else {
        Write-Host 'Error: invalid selection.'
        $scriptFailed = $true
    }
}

if (-not $scriptFailed) {
    & (Join-Path $repoRoot 'scripts\core\build\build.ps1')
    if ($global:LASTEXITCODE -ne 0) {
        Write-Host 'Error: build.ps1 failed.'
        $scriptFailed = $true
    }
}

if (-not $scriptFailed -and ($choice -eq '1' -or $choice -eq '3')) {
    & (Join-Path $repoRoot 'scripts\core\install\install-codex.ps1') -CodexRoot $codexRoot
    if ($global:LASTEXITCODE -ne 0) {
        Write-Host 'Error: install-codex.ps1 failed.'
        $scriptFailed = $true
    }
}

if (-not $scriptFailed -and ($choice -eq '2' -or $choice -eq '3')) {
    & (Join-Path $repoRoot 'scripts\core\install\install-cursor-project.ps1') -ProjectPath $cursorProjectPath
    if ($global:LASTEXITCODE -ne 0) {
        Write-Host 'Error: install-cursor-project.ps1 failed.'
        $scriptFailed = $true
    }
}

if (-not $scriptFailed) {
    Write-Host ''
    Write-Host ('Codex path: ' + $config['local_codex_root'])
    Write-Host ('Cursor path: ' + $config['cursor_project_path'])
    Show-SkillSummary -RepoPath $repoRoot
    Wait-ForSuccessExit
    exit 0
}

Wait-ForFailureExit
exit 1
