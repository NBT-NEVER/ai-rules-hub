Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-AddressStorePath {
    return (Join-Path $PSScriptRoot 'addresses.txt')
}

function Read-KeyValueFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $map = [ordered]@{}
    if (-not (Test-Path $Path)) {
        return $map
    }

    foreach ($line in Get-Content -Path $Path -Encoding UTF8) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        $parts = $line -split '=', 2
        if ($parts.Count -ne 2) {
            continue
        }

        $map[$parts[0].Trim()] = $parts[1].Trim()
    }

    return $map
}

function Write-KeyValueFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]$Data
    )

    $orderedKeys = @(
        'github_repo_url',
        'local_codex_root',
        'cursor_project_path',
        'local_repo_path'
    )

    $lines = foreach ($key in $orderedKeys) {
        if ($Data.Contains($key)) {
            '{0}={1}' -f $key, $Data[$key]
        }
        else {
            '{0}=' -f $key
        }
    }

    Set-Content -Path $Path -Value $lines -Encoding UTF8
}

function Get-AddressConfig {
    $storePath = Get-AddressStorePath
    $config = Read-KeyValueFile -Path $storePath

    foreach ($key in @('github_repo_url', 'local_codex_root', 'cursor_project_path', 'local_repo_path')) {
        if (-not $config.Contains($key)) {
            $config[$key] = ''
        }
    }

    if ([string]::IsNullOrWhiteSpace([string]$config['github_repo_url'])) {
        $config['github_repo_url'] = 'https://github.com/NBT-NEVER/ai-rules-hub.git'
        Write-KeyValueFile -Path $storePath -Data $config
    }

    return $config
}

function Save-AddressConfig {
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]$Config
    )

    Write-KeyValueFile -Path (Get-AddressStorePath) -Data $Config
}

function Get-RepoRootFromScriptsRoot {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ScriptsRoot
    )

    return (Split-Path -Parent $ScriptsRoot)
}

function Test-IsRepoScriptsLayout {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ScriptsRoot
    )

    $repoRoot = Get-RepoRootFromScriptsRoot -ScriptsRoot $ScriptsRoot
    return ((Split-Path -Leaf $repoRoot) -eq 'ai-rules-hub')
}

function Use-CurrentRepoPath {
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]$Config,
        [Parameter(Mandatory = $true)]
        [string]$ScriptsRoot
    )

    $repoRoot = Get-RepoRootFromScriptsRoot -ScriptsRoot $ScriptsRoot
    $Config['local_repo_path'] = $repoRoot
    Save-AddressConfig -Config $Config
    return $repoRoot
}

function Get-ConfirmedAddressValue {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Prompt,
        [Parameter(Mandatory = $true)]
        [string]$StoreKey,
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]$Config,
        [switch]$MustNotBeEmpty
    )

    $defaultValue = ''
    if ($Config.Contains($StoreKey)) {
        $defaultValue = [string]$Config[$StoreKey]
    }

    $value = $defaultValue
    if (-not [string]::IsNullOrWhiteSpace($defaultValue)) {
        $choice = Read-Host ($Prompt + "`n默认路径：" + $defaultValue + "`n是否使用默认路径？(Y/n)")
        if ($choice -match '^[Nn]$') {
            $value = Read-Host '请输入新路径'
        }
    }
    else {
        $value = Read-Host ($Prompt + "`n请输入路径")
    }

    if ($MustNotBeEmpty -and [string]::IsNullOrWhiteSpace($value)) {
        throw ('路径不能为空：' + $StoreKey)
    }

    $Config[$StoreKey] = $value
    Save-AddressConfig -Config $Config
    return $value
}

function Ensure-LocalRepoPath {
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]$Config,
        [Parameter(Mandatory = $true)]
        [string]$ScriptsRoot
    )

    return (Get-ConfirmedAddressValue -Prompt '当前脚本不在 ai-rules-hub\\scripts 目录下，请输入本地仓库路径。' -StoreKey 'local_repo_path' -Config $Config -MustNotBeEmpty)
}

function Ensure-CodexRoot {
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]$Config
    )

    if ([string]::IsNullOrWhiteSpace([string]$Config['local_codex_root'])) {
        $Config['local_codex_root'] = (Join-Path $env:USERPROFILE '.codex')
        Save-AddressConfig -Config $Config
    }

    return (Get-ConfirmedAddressValue -Prompt '请确认 Codex 根目录路径。' -StoreKey 'local_codex_root' -Config $Config -MustNotBeEmpty)
}

function Ensure-CursorProjectPath {
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]$Config
    )

    return (Get-ConfirmedAddressValue -Prompt '请确认 Cursor 项目路径。' -StoreKey 'cursor_project_path' -Config $Config -MustNotBeEmpty)
}

function Get-GitProxyCandidate {
    $proxyVariables = @('HTTPS_PROXY', 'https_proxy', 'HTTP_PROXY', 'http_proxy', 'ALL_PROXY', 'all_proxy')
    foreach ($name in $proxyVariables) {
        $value = [Environment]::GetEnvironmentVariable($name)
        if (-not [string]::IsNullOrWhiteSpace($value)) {
            return $value.Trim()
        }
    }

    return $null
}

function Set-GitProxyForSession {
    $proxy = Get-GitProxyCandidate
    if ([string]::IsNullOrWhiteSpace($proxy)) {
        Write-Host '未检测到代理，保持当前 Git 代理设置不变。'
        return
    }

    & git config --global http.proxy $proxy | Out-Null
    & git config --global https.proxy $proxy | Out-Null
    Write-Host ('已设置 Git 代理：' + $proxy)
}

function Invoke-GitWithLocation {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepositoryPath,
        [Parameter(Mandatory = $true)]
        [scriptblock]$Action
    )

    Push-Location $RepositoryPath
    try {
        & $Action
    }
    finally {
        Pop-Location
    }
}

function Get-SkillSummary {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepoPath
    )

    $skillsRoot = Join-Path $RepoPath 'src\skills'
    if (-not (Test-Path $skillsRoot)) {
        return @()
    }

    $summaries = @()
    $skillDirs = Get-ChildItem -Path $skillsRoot -Directory | Sort-Object Name
    foreach ($dir in $skillDirs) {
        $skillFile = Join-Path $dir.FullName 'SKILL.md'
        if (-not (Test-Path $skillFile)) {
            continue
        }

        $content = Get-Content -Raw -Encoding UTF8 $skillFile
        $nameMatch = [regex]::Match($content, '(?m)^name:\s*(.+?)\s*$')
        $descMatch = [regex]::Match($content, '(?m)^description:\s*(.+?)\s*$')

        $name = $dir.Name
        if ($nameMatch.Success) {
            $name = $nameMatch.Groups[1].Value.Trim()
        }

        $description = '暂无描述'
        if ($descMatch.Success) {
            $description = $descMatch.Groups[1].Value.Trim()
        }

        $summaries += [pscustomobject]@{
            Directory = $dir.Name
            Name = $name
            Description = $description
        }
    }

    return $summaries
}

function Show-SkillSummary {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepoPath
    )

    $skills = Get-SkillSummary -RepoPath $RepoPath
    if ($skills.Count -eq 0) {
        Write-Host '未找到可展示的技能。'
        return
    }

    Write-Host ''
    Write-Host '技能列表：'
    foreach ($skill in $skills) {
        Write-Host ('- {0} ({1})' -f $skill.Name, $skill.Directory)
        Write-Host ('  {0}' -f $skill.Description)
    }
}

function Wait-ForSuccessExit {
    Write-Host ''
    Write-Host '操作完成。按任意键关闭窗口。'
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}

function Wait-ForFailureExit {
    Write-Host ''
    Write-Host '操作失败。错误信息已保留在窗口中，按任意键关闭窗口。'
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}