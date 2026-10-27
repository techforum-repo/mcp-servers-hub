#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVERS_DIR="$REPO_ROOT/servers"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/mcp-servers-hub"

# Build every server under servers/ that has a package.json.
for server_dir in "$SERVERS_DIR"/*/; do
    [ -f "$server_dir/package.json" ] || continue
    echo "Building $(basename "$server_dir") from $server_dir..."
    (cd "$server_dir" && npm ci && npm run build)
done

mkdir -p "$CONFIG_DIR"
escaped_servers_dir=$(printf '%s' "$SERVERS_DIR" | sed 's/[&|]/\\&/g')
sed "s|__SERVERS_DIR__|$escaped_servers_dir|g" "$REPO_ROOT/bootstrap/claude-code-user.json" > "$CONFIG_DIR/claude-code-user.json"
sed "s|__SERVERS_DIR__|$escaped_servers_dir|g" "$REPO_ROOT/bootstrap/codex-user.toml" > "$CONFIG_DIR/codex-user.toml"

echo
echo "Generated safe configuration snippets:"
echo "  $CONFIG_DIR/claude-code-user.json"
echo "  $CONFIG_DIR/codex-user.toml"
echo
echo "No global configuration was replaced. Merge the server entries you approve into"
echo "your existing Claude Code and Codex configuration files, or add one at a time:"
echo "  claude mcp add-json --scope user <name> '<entry JSON from the snippet>'"
