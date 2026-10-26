$RepoRoot = Resolve-Path "$PSScriptRoot\.."
$SharedDir = "C:\Users\Public\mcp-servers-hub"

# Create a clean absolute workspace anchor for the host machine config
If (!(Test-Path $SharedDir)) { New-Item -ItemType Directory -Path $SharedDir -Force }
Copy-Item -Path "$RepoRoot\*" -Destination $SharedDir -Recurse -Force -Exclude "node_modules","dist",".git"

Write-Host "Building custom tools..." -ForegroundColor Cyan
Set-Location "$SharedDir\servers\sample-internal-tool"
npm install
npm run build

Write-Host "Symlinking cross-platform runtimes..." -ForegroundColor Cyan
$ClaudePath = "$env:USERPROFILE\.claude.json"
$CodexDir   = "$env:USERPROFILE\.codex"
$CodexPath  = "$CodexDir\config.toml"

If (!(Test-Path $CodexDir)) { New-Item -ItemType Directory -Path $CodexDir -Force }
if (Test-Path $ClaudePath) { Remove-Item $ClaudePath -Force }
if (Test-Path $CodexPath) { Remove-Item $CodexPath -Force }

# Establish exact Windows Junction Symbolic Links
New-Item -ItemType SymbolicLink -Path $ClaudePath -Value "$SharedDir\bootstrap\claude-code-user.json" | Out-Null
New-Item -ItemType SymbolicLink -Path $CodexPath -Value "$SharedDir\bootstrap\codex-user.toml" | Out-Null

Write-Host "✓ Windows Host Architecture Environments Matched Natively." -ForegroundColor Green