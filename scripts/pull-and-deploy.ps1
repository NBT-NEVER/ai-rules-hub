Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'

$scriptRoot = $PSScriptRoot
$coreRoot = Join-Path $scriptRoot 'core'
. (Join-Path $coreRoot 'common.ps1')

$scriptFailed = $false
$repoRoot = $null
$config = $null
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

if (-not $scriptFailed -and -not (Test-Path $repoRoot)) {
    $parentPath = Split-Path -Parent $repoRoot
    if (-not (Test-Path $parentPath)) {
        Write-Host ('错误：未找到上级目录：' + $parentPath)
        $scriptFailed = $true
    }
    else {
        Write-Host ('正在克隆仓库到：' + $repoRoot)
        & git clone $config['github_repo_url'] $repoRoot
        if ($global:LASTEXITCODE -ne 0) {
            Write-Host '错误：git clone 执行失败。'
            $scriptFailed = $true
        }
    }
}

if (-not $scriptFailed -and -not (Test-Path (Join-Path $repoRoot '.git'))) {
    Write-Host ('错误：目标目录不是 Git 仓库：' + $repoRoot)
    $scriptFailed = $true
}

if (-not $scriptFailed) {
    Invoke-GitWithLocation -RepositoryPath $repoRoot -Action {
        $status = (& git status --porcelain | Out-String).Trim()
        if ($status) {
            Write-Host '检测到本地存在未提交的修改。'
            $choice = Read-Host '输入 O 覆盖本地修改，或输入 S 停止执行'
            if ($choice -match '^[Ss]$') {
                Write-Host '已取消拉取操作。'
                $script:scriptFailed = $true
                return
            }
            if ($choice -notmatch '^[Oo]$') {
                Write-Host '错误：输入选项无效。'
                $script:scriptFailed = $true
                return
            }

            & git reset --hard HEAD
            if ($global:LASTEXITCODE -ne 0) {
                Write-Host '错误：git reset 执行失败。'
                $script:scriptFailed = $true
                return
            }

            & git clean -fd
            if ($global:LASTEXITCODE -ne 0) {
                Write-Host '错误：git clean 执行失败。'
                $script:scriptFailed = $true
                return
            }
        }

        & git fetch --all --prune
        if ($global:LASTEXITCODE -ne 0) {
            Write-Host '错误：git fetch 执行失败。'
            $script:scriptFailed = $true
            return
        }

        $currentBranch = (& git branch --show-current | Out-String).Trim()
        if (-not $currentBranch) {
            Write-Host '错误：无法确定当前分支。'
            $script:scriptFailed = $true
            return
        }

        $upstream = (& git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>$null | Out-String).Trim()
        if (-not $upstream) {
            & git branch --set-upstream-to "origin/$currentBranch" $currentBranch | Out-Null
            if ($global:LASTEXITCODE -ne 0) {
                Write-Host '错误：设置上游分支失败。'
                $script:scriptFailed = $true
                return
            }
            $upstream = 'origin/' + $currentBranch
        }

        $behindCountText = (& git rev-list --count "HEAD..$upstream" | Out-String).Trim()
        $behindCount = 0
        $isCountOk = [int]::TryParse($behindCountText, [ref]$behindCount)
        if (-not $isCountOk) {
            Write-Host '错误：无法解析落后提交数。'
            $script:scriptFailed = $true
            return
        }

        if ($behindCount -gt 0) {
            Write-Host ('远端领先 ' + $behindCount + ' 个提交，正在将本地分支重置到上游分支。')
            & git reset --hard $upstream
            if ($global:LASTEXITCODE -ne 0) {
                Write-Host '错误：重置到上游分支失败。'
                $script:scriptFailed = $true
                return
            }
        }
        else {
            & git pull --ff-only
            if ($global:LASTEXITCODE -ne 0) {
                Write-Host '错误：git pull 执行失败。'
                $script:scriptFailed = $true
                return
            }
        }
    }
}

if (-not $scriptFailed) {
    & (Join-Path $repoRoot 'scripts\update-from-src.ps1')
    if ($global:LASTEXITCODE -ne 0) {
        Write-Host '错误：update-from-src.ps1 执行失败。'
        $scriptFailed = $true
    }
}

if (-not $scriptFailed) {
    Write-Host ''
    Write-Host ('仓库路径：' + $repoRoot)
    Write-Host ('GitHub 地址：' + $config['github_repo_url'])
    Show-SkillSummary -RepoPath $repoRoot
    Wait-ForSuccessExit
    exit 0
}

Wait-ForFailureExit
exit 1