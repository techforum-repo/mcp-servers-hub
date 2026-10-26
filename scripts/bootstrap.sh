#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVER_DIR="$REPO_ROOT/servers/sample-internal-tool"
ENTRYPOINT="$SERVER_DIR/dist/index.js"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/mcp-servers-hub"

echo "Building sample-internal-tool from $SERVER_DIR..."
cd "$SERVER_DIR"
npm ci
npm run build

mkdir -p "$CONFIG_DIR"
escaped_entrypoint=$(printf '%s' "$ENTRYPOINT" | sed 's/[&|]/\\\\&/g')
sed "s|__MCP_SERVER_ENTRYPOINT__|$escaped_entrypoint|g" "$REPO_ROOT/bootstrap/claude-code-user.json" > "$CONFIG_DIR/claude-code-user.json"
sed "s|__MCP_SERVER_ENTRYPOINT__|$escaped_entrypoint|g" "$REPO_ROOT/bootstrap/codex-user.toml" > "$CONFIG_DIR/codex-user.toml"

echo
echo "Built: $ENTRYPOINT"
echo "Generated safe configuration snippets:"
echo "  $CONFIG_DIR/claude-code-user.json"
echo "  $CONFIG_DIR/codex-user.toml"
echo
echo "No global configuration was replaced. Merge the server entries you approve into"
echo "your existing Claude Code and Codex configuration files."
