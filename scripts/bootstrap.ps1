$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path "$PSScriptRoot\..").Path
$ServersDir = Join-Path $RepoRoot "servers"
$ConfigRoot = if ($env:APPDATA) { $env:APPDATA } else { $env:USERPROFILE }
$ConfigDir = Join-Path $ConfigRoot "mcp-servers-hub"

# Build every server under servers\ that has a package.json.
Get-ChildItem $ServersDir -Directory | Where-Object { Test-Path (Join-Path $_.FullName "package.json") } | ForEach-Object {
    Write-Host "Building $($_.Name) from $($_.FullName)..." -ForegroundColor Cyan
    Push-Location $_.FullName
    try {
        npm ci
        if ($LASTEXITCODE -ne 0) { throw "npm ci failed for $($_.Name)" }
        npm run build
        if ($LASTEXITCODE -ne 0) { throw "npm run build failed for $($_.Name)" }
    } finally {
        Pop-Location
    }
}

# Node accepts forward slashes on Windows, and they need no escaping in JSON or TOML
# (a raw C:\Users\... path would be an invalid escape sequence in both).
$PortableServersDir = $ServersDir.Replace("\", "/")

New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
$ClaudeTemplate = Get-Content (Join-Path $RepoRoot "bootstrap\claude-code-user.json") -Raw
$CodexTemplate = Get-Content (Join-Path $RepoRoot "bootstrap\codex-user.toml") -Raw
$ClaudeTemplate.Replace("__SERVERS_DIR__", $PortableServersDir) | Set-Content (Join-Path $ConfigDir "claude-code-user.json") -NoNewline
$CodexTemplate.Replace("__SERVERS_DIR__", $PortableServersDir) | Set-Content (Join-Path $ConfigDir "codex-user.toml") -NoNewline

Write-Host "Generated safe configuration snippets:" -ForegroundColor Green
Write-Host "  $(Join-Path $ConfigDir 'claude-code-user.json')"
Write-Host "  $(Join-Path $ConfigDir 'codex-user.toml')"
Write-Host "No global configuration was replaced. Merge the server entries you approve into your existing Claude Code and Codex configuration files, or add one at a time with: claude mcp add-json --scope user <name> '<entry JSON>'" -ForegroundColor Yellow
