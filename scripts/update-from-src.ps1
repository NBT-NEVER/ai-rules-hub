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
    Write-Host ('错误：未找到构建脚本：' + $repoRoot)
    $scriptFailed = $true
}

if (-not $scriptFailed) {
    Write-Host '请选择更新目标：'
    Write-Host '1. 更新 Codex 技能'
    Write-Host '2. 更新 Cursor 技能'
    Write-Host '3. 同时更新 Codex 和 Cursor 技能'
    $choice = Read-Host '请输入 1、2 或 3'

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
        Write-Host '错误：输入选项无效。'
        $scriptFailed = $true
    }
}

if (-not $scriptFailed) {
    & (Join-Path $repoRoot 'scripts\core\build\build.ps1')
    if ($global:LASTEXITCODE -ne 0) {
        Write-Host '错误：build.ps1 执行失败。'
        $scriptFailed = $true
    }
}

if (-not $scriptFailed -and ($choice -eq '1' -or $choice -eq '3')) {
    & (Join-Path $repoRoot 'scripts\core\install\install-codex.ps1') -CodexRoot $codexRoot
    if ($global:LASTEXITCODE -ne 0) {
        Write-Host '错误：install-codex.ps1 执行失败。'
        $scriptFailed = $true
    }
}

if (-not $scriptFailed -and ($choice -eq '2' -or $choice -eq '3')) {
    & (Join-Path $repoRoot 'scripts\core\install\install-cursor-project.ps1') -ProjectPath $cursorProjectPath
    if ($global:LASTEXITCODE -ne 0) {
        Write-Host '错误：install-cursor-project.ps1 执行失败。'
        $scriptFailed = $true
    }
}

if (-not $scriptFailed) {
    Write-Host ''
    Write-Host ('Codex 路径：' + $config['local_codex_root'])
    Write-Host ('Cursor 路径：' + $config['cursor_project_path'])
    Show-SkillSummary -RepoPath $repoRoot
    Wait-ForSuccessExit
    exit 0
}

Wait-ForFailureExit
exit 1