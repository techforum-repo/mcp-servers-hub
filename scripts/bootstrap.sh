#!/bin/bash
set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd)"
SHARED_DIR="/Users/shared/mcp-servers-hub"

echo "Step 1: Provisioning standard machine path location..."
sudo mkdir -p "$SHARED_DIR"
sudo chown -R $(whoami) "$SHARED_DIR"

echo "Step 2: Transferring codebases to deployment workspace..."
rsync -av --exclude='node_modules' --exclude='dist' --exclude='.git' "$REPO_ROOT/" "$SHARED_DIR/"

echo "Step 3: Compiling internal custom servers..."
cd "$SHARED_DIR/servers/sample-internal-tool"
npm install
npm run build

echo "Step 4: Symlinking system user configurations..."
mkdir -p "$HOME/.codex"
ln -sf "$SHARED_DIR/bootstrap/claude-code-user.json" "$HOME/.claude.json"
ln -sf "$SHARED_DIR/bootstrap/codex-user.toml" "$HOME/.codex/config.toml"

echo "🚀 All MCP servers configured and successfully deployed!"