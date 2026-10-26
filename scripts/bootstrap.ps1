$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path "$PSScriptRoot\..").Path
$ServerDir = Join-Path $RepoRoot "servers\sample-internal-tool"
$EntryPoint = Join-Path $ServerDir "dist\index.js"
$ConfigRoot = if ($env:APPDATA) { $env:APPDATA } else { $env:USERPROFILE }
$ConfigDir = Join-Path $ConfigRoot "mcp-servers-hub"

Write-Host "Building sample-internal-tool from $ServerDir..." -ForegroundColor Cyan
Set-Location $ServerDir
npm ci
npm run build

New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
$ClaudeTemplate = Get-Content (Join-Path $RepoRoot "bootstrap\claude-code-user.json") -Raw
$CodexTemplate = Get-Content (Join-Path $RepoRoot "bootstrap\codex-user.toml") -Raw
$ClaudeTemplate.Replace("__MCP_SERVER_ENTRYPOINT__", $EntryPoint) | Set-Content (Join-Path $ConfigDir "claude-code-user.json") -NoNewline
$CodexTemplate.Replace("__MCP_SERVER_ENTRYPOINT__", $EntryPoint) | Set-Content (Join-Path $ConfigDir "codex-user.toml") -NoNewline

Write-Host "Built: $EntryPoint" -ForegroundColor Green
Write-Host "Generated safe configuration snippets:" -ForegroundColor Green
Write-Host "  $(Join-Path $ConfigDir 'claude-code-user.json')"
Write-Host "  $(Join-Path $ConfigDir 'codex-user.toml')"
Write-Host "No global configuration was replaced. Merge the server entries you approve into your existing Claude Code and Codex configuration files." -ForegroundColor Yellow
