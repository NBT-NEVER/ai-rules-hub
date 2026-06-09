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
    Write-Host ('Initialization failed: ' + $_.Exception.Message)
    $scriptFailed = $true
}

if (-not $scriptFailed -and -not (Test-Path $repoRoot)) {
    $parentPath = Split-Path -Parent $repoRoot
    if (-not (Test-Path $parentPath)) {
        Write-Host ('Error: parent directory not found: ' + $parentPath)
        $scriptFailed = $true
    }
    else {
        Write-Host ('Cloning repository to: ' + $repoRoot)
        & git clone $config['github_repo_url'] $repoRoot
        if ($global:LASTEXITCODE -ne 0) {
            Write-Host 'Error: git clone failed.'
            $scriptFailed = $true
        }
    }
}

if (-not $scriptFailed -and -not (Test-Path (Join-Path $repoRoot '.git'))) {
    Write-Host ('Error: target directory is not a git repository: ' + $repoRoot)
    $scriptFailed = $true
}

if (-not $scriptFailed) {
    Invoke-GitWithLocation -RepositoryPath $repoRoot -Action {
        $status = (& git status --porcelain | Out-String).Trim()
        if ($status) {
            Write-Host 'Local uncommitted changes detected.'
            $choice = Read-Host 'Enter O to overwrite local changes, or S to stop'
            if ($choice -match '^[Ss]$') {
                Write-Host 'Pull cancelled by user.'
                $script:scriptFailed = $true
                return
            }
            if ($choice -notmatch '^[Oo]$') {
                Write-Host 'Error: invalid selection.'
                $script:scriptFailed = $true
                return
            }

            & git reset --hard HEAD
            if ($global:LASTEXITCODE -ne 0) {
                Write-Host 'Error: git reset failed.'
                $script:scriptFailed = $true
                return
            }

            & git clean -fd
            if ($global:LASTEXITCODE -ne 0) {
                Write-Host 'Error: git clean failed.'
                $script:scriptFailed = $true
                return
            }
        }

        & git fetch --all --prune
        if ($global:LASTEXITCODE -ne 0) {
            Write-Host 'Error: git fetch failed.'
            $script:scriptFailed = $true
            return
        }

        $currentBranch = (& git branch --show-current | Out-String).Trim()
        if (-not $currentBranch) {
            Write-Host 'Error: could not determine current branch.'
            $script:scriptFailed = $true
            return
        }

        $upstream = (& git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>$null | Out-String).Trim()
        if (-not $upstream) {
            & git branch --set-upstream-to "origin/$currentBranch" $currentBranch | Out-Null
            if ($global:LASTEXITCODE -ne 0) {
                Write-Host 'Error: failed to set upstream branch.'
                $script:scriptFailed = $true
                return
            }
            $upstream = 'origin/' + $currentBranch
        }

        $behindCountText = (& git rev-list --count "HEAD..$upstream" | Out-String).Trim()
        $behindCount = 0
        $isCountOk = [int]::TryParse($behindCountText, [ref]$behindCount)
        if (-not $isCountOk) {
            Write-Host 'Error: could not parse behind count.'
            $script:scriptFailed = $true
            return
        }

        if ($behindCount -gt 0) {
            Write-Host ('Remote is ahead by ' + $behindCount + ' commit(s). Resetting local branch.')
            & git reset --hard $upstream
            if ($global:LASTEXITCODE -ne 0) {
                Write-Host 'Error: git reset to upstream failed.'
                $script:scriptFailed = $true
                return
            }
        }
        else {
            & git pull --ff-only
            if ($global:LASTEXITCODE -ne 0) {
                Write-Host 'Error: git pull failed.'
                $script:scriptFailed = $true
                return
            }
        }
    }
}

if (-not $scriptFailed) {
    & (Join-Path $repoRoot 'scripts\update-from-src.ps1')
    if ($global:LASTEXITCODE -ne 0) {
        Write-Host 'Error: update-from-src.ps1 failed.'
        $scriptFailed = $true
    }
}

if (-not $scriptFailed) {
    Write-Host ''
    Write-Host ('Repository path: ' + $repoRoot)
    Write-Host ('GitHub URL: ' + $config['github_repo_url'])
    Show-SkillSummary -RepoPath $repoRoot
    Wait-ForSuccessExit
    exit 0
}

Wait-ForFailureExit
exit 1
