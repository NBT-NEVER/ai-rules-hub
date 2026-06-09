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
    Write-Host ('Initialization failed: ' + $_.Exception.Message)
    $scriptFailed = $true
}

if (-not $scriptFailed -and -not (Test-Path (Join-Path $repoRoot '.git'))) {
    Write-Host ('Error: target directory is not a git repository: ' + $repoRoot)
    $scriptFailed = $true
}

if (-not $scriptFailed) {
    $commitMessage = Read-Host 'Enter commit message'
    if ([string]::IsNullOrWhiteSpace($commitMessage)) {
        Write-Host 'Error: commit message cannot be empty.'
        $scriptFailed = $true
    }
}

if (-not $scriptFailed) {
    Invoke-GitWithLocation -RepositoryPath $repoRoot -Action {
        Write-Host ('Repository: ' + $repoRoot)
        Write-Host ('Remote URL: ' + $config['github_repo_url'])
        Write-Host 'Setting remote URL...'
        & git remote set-url origin $config['github_repo_url']
        if ($global:LASTEXITCODE -ne 0) {
            Write-Host 'Error: failed to set remote URL.'
            $script:scriptFailed = $true
            return
        }

        Write-Host 'Staging changes...'
        & git add .
        if ($global:LASTEXITCODE -ne 0) {
            Write-Host 'Error: git add failed.'
            $script:scriptFailed = $true
            return
        }

        $status = (& git status --short | Out-String).Trim()
        if (-not $status) {
            Write-Host 'No changes to commit.'
            return
        }

        Write-Host 'Changes to commit:'
        & git status --short

        Write-Host ('Creating commit: ' + $commitMessage)
        & git commit -m $commitMessage
        if ($global:LASTEXITCODE -ne 0) {
            Write-Host 'Error: git commit failed.'
            $script:scriptFailed = $true
            return
        }

        $branch = (& git branch --show-current | Out-String).Trim()
        if (-not $branch) {
            Write-Host 'Error: could not determine current branch.'
            $script:scriptFailed = $true
            return
        }

        Write-Host ('Current branch: ' + $branch)
        Write-Host ('Starting push to origin/' + $branch + ' ...')
        & git push -u origin $branch
        if ($global:LASTEXITCODE -ne 0) {
            Write-Host ('Error: git push failed for origin/' + $branch)
            $script:scriptFailed = $true
            return
        }

        Write-Host ('Push completed successfully to origin/' + $branch)
    }
}

if (-not $scriptFailed) {
    Write-Host ''
    Write-Host 'Git push workflow completed successfully.'
    Wait-ForSuccessExit
    exit 0
}

Wait-ForFailureExit
exit 1
