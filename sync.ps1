# Copies the configs listed in .env into this repo, then commits and pushes any changes.
$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot
$log = Join-Path $repo 'sync.log'

function Log($msg) { "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $msg" | Add-Content $log }

try {
    $paths = @{}
    Get-Content (Join-Path $repo '.env') | Where-Object { $_ -match '^\s*([^#=]+)=(.+)$' } | ForEach-Object {
        $paths[$Matches[1].Trim()] = $Matches[2].Trim()
    }

    # env key -> backup dir in this repo
    foreach ($name in 'neovim', 'powershell', 'wezterm') {
        $src = $paths[$name]
        $dest = Join-Path $repo ".$name"
        if (-not $src -or -not (Test-Path $src)) { Log "skip ${name}: source '$src' not found"; continue }

        if (Test-Path $src -PathType Container) {
            robocopy $src $dest /MIR /XD .git /XF *.bak* /NJH /NJS /NFL /NDL /NP | Out-Null
            if ($LASTEXITCODE -ge 8) { throw "robocopy failed for $name (exit $LASTEXITCODE)" }
        } else {
            New-Item -ItemType Directory -Force $dest | Out-Null
            Copy-Item $src (Join-Path $dest (Split-Path $src -Leaf)) -Force
        }
    }

    Set-Location $repo
    git add -A
    $changes = git status --porcelain
    if (-not $changes) { exit 0 }

    $changed = $changes | ForEach-Object { ($_.Substring(3) -split '/')[0].TrimStart('.') } | Sort-Object -Unique
    $msg = "sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm') ($($changed -join ', '))"
    git commit -q -m $msg
    if ($LASTEXITCODE -ne 0) { throw 'git commit failed' }
    git push -q origin master 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'git push failed' }
    Log "pushed: $msg"
} catch {
    Log "ERROR: $_"
    exit 1
}
