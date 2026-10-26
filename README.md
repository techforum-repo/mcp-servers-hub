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

The bootstrap script builds the bundled server and writes machine-specific configuration snippets under the user's configuration directory. It never replaces `~/.claude.json`, `~/.codex/config.toml`, or another existing user configuration file. Review and merge only the server entries you approve.

## Server requirements

Every server should include a pinned dependency lockfile, `build` and `check` scripts, documented ownership and data classification, and environment-variable references for secrets.

## Credentials

The GitHub template reads `GITHUB_TOKEN` from the environment. Set it through your operating system's secure environment management or secret manager; do not commit it.
