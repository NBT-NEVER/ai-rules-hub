Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'

$scriptRoot = $PSScriptRoot
$coreRoot = Join-Path $scriptRoot 'core'
. (Join-Path $coreRoot 'common.ps1')

$scriptFailed = $false
$repoRoot = $null
$config = $null
$commitMessage = $null
$branch = $null
$global:LASTEXITCODE = 0

try {
    $config = Get-AddressConfig
    if (Test-IsRepoScriptsLayout -ScriptsRoot $scriptRoot) {
        $repoRoot = Use-CurrentRepoPath -Config $config -ScriptsRoot $scriptRoot
    }
    else {
        $repoRoot = Ensure-LocalRepoPath -Config $config -ScriptsRoot $scriptRoot
    }
    Set-GitProxyForSession
}
catch {
    Write-Host ('初始化失败：' + $_.Exception.Message)
    $scriptFailed = $true
}

if (-not $scriptFailed -and -not (Test-Path (Join-Path $repoRoot '.git'))) {
    Write-Host ('错误：目标目录不是 Git 仓库：' + $repoRoot)
    $scriptFailed = $true
}

if (-not $scriptFailed) {
    $commitMessage = Read-Host '请输入提交说明'
    if ([string]::IsNullOrWhiteSpace($commitMessage)) {
        Write-Host '错误：提交说明不能为空。'
        $scriptFailed = $true
    }
}

if (-not $scriptFailed) {
    Invoke-GitWithLocation -RepositoryPath $repoRoot -Action {
        Write-Host ('仓库：' + $repoRoot)
        Write-Host ('远端地址：' + $config['github_repo_url'])
        Write-Host '正在设置远端地址...'
        & git remote set-url origin $config['github_repo_url']
        if ($global:LASTEXITCODE -ne 0) {
            Write-Host '错误：设置远端地址失败。'
            $script:scriptFailed = $true
            return
        }

        Write-Host '正在暂存变更...'
        & git add .
        if ($global:LASTEXITCODE -ne 0) {
            Write-Host '错误：git add 执行失败。'
            $script:scriptFailed = $true
            return
        }

        $status = (& git status --short | Out-String).Trim()
        if (-not $status) {
            Write-Host '没有可提交的变更。'
            return
        }

        Write-Host '待提交的变更：'
        & git status --short

        Write-Host ('正在创建提交：' + $commitMessage)
        & git commit --trailer "Co-authored-by: Cursor <cursoragent@cursor.com>" -m $commitMessage
        if ($global:LASTEXITCODE -ne 0) {
            Write-Host '错误：git commit --trailer "Co-authored-by: Cursor <cursoragent@cursor.com>" 执行失败。'
            $script:scriptFailed = $true
            return
        }

        $branch = (& git branch --show-current | Out-String).Trim()
        if (-not $branch) {
            Write-Host '错误：无法确定当前分支。'
            $script:scriptFailed = $true
            return
        }

        Write-Host ('当前分支：' + $branch)
        Write-Host ('开始推送到 origin/' + $branch + ' ...')
        & git push -u origin $branch
        if ($global:LASTEXITCODE -ne 0) {
            Write-Host ('错误：推送到 origin/' + $branch + ' 失败。')
            $script:scriptFailed = $true
            return
        }

        Write-Host ('已成功推送到 origin/' + $branch)
    }
}

if (-not $scriptFailed) {
    Write-Host ''
    Write-Host 'Git 提交与推送流程已成功完成。'
    Wait-ForSuccessExit
    exit 0
}

Wait-ForFailureExit
exit 1