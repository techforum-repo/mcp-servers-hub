# MCP Servers Hub

Shared, versioned Model Context Protocol (MCP) server implementations and configuration templates.

## Prerequisites

The bundled sample server requires Node.js 20 or later and npm.

## Install a server safely

On macOS or Linux, run:

```bash
./scripts/bootstrap.sh
```

On Windows PowerShell, run:

```powershell
.\scripts\bootstrap.ps1
```

The bootstrap script builds every server under `servers/` and writes machine-specific configuration snippets under the user's configuration directory. It never replaces `~/.claude.json`, `~/.codex/config.toml`, or another existing user configuration file. Review and merge only the server entries you approve.

## Server requirements

Every server should include a pinned dependency lockfile, `build` and `check` scripts, documented ownership and data classification, and environment-variable references for secrets.

## Testing a server

Use the MCP Inspector to call a server's tools interactively before registering it:

```bash
npx @modelcontextprotocol/inspector node servers/sample-internal-tool/dist/index.js
```

CI builds, type-checks, and runs an MCP `initialize` smoke test against every server on each push.

## Credentials

The GitHub entry uses GitHub's official remote MCP server (`https://api.githubcopilot.com/mcp/`), so nothing is installed locally. It reads `GITHUB_TOKEN` from the environment: use a fine-grained personal access token limited to the repositories and permissions you need. Set it through your operating system's secure environment management or secret manager; do not commit it.

- Claude Code expands `${GITHUB_TOKEN}` in the `Authorization` header.
- Codex does not expand variables inside config values, so its entry uses `bearer_token_env_var = "GITHUB_TOKEN"` instead.
