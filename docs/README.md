# Yansu Agent Documentation

Yansu Agent is a local development companion that syncs your project's knowledge base with the Yansu cloud, enabling AI coding assistants to understand your project better.

## Table of Contents

- [Installation](#installation)
- [Getting Started](#getting-started)
- [Commands](#commands)
- [Background Daemon](#background-daemon)
- [AI Agent Integration](#ai-agent-integration)
- [Knowledge Capture](#knowledge-capture)
- [Troubleshooting](#troubleshooting)

## Installation

### Quick Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/Isoform/yansu-releases/main/install.sh | bash
```

This will:
1. Download the latest version for your platform
2. Install it to `/usr/local/bin`
3. Optionally install the background sync service

### Manual Installation

#### macOS (Apple Silicon)
```bash
curl -L https://github.com/Isoform/yansu-releases/releases/latest/download/yansu-darwin-arm64 -o yansu
chmod +x yansu
sudo mv yansu /usr/local/bin/
```

#### macOS (Intel)
```bash
curl -L https://github.com/Isoform/yansu-releases/releases/latest/download/yansu-darwin-amd64 -o yansu
chmod +x yansu
sudo mv yansu /usr/local/bin/
```

#### Linux (x86_64)
```bash
curl -L https://github.com/Isoform/yansu-releases/releases/latest/download/yansu-linux-amd64 -o yansu
chmod +x yansu
sudo mv yansu /usr/local/bin/
```

#### Linux (ARM64)
```bash
curl -L https://github.com/Isoform/yansu-releases/releases/latest/download/yansu-linux-arm64 -o yansu
chmod +x yansu
sudo mv yansu /usr/local/bin/
```

### Verify Installation

```bash
yansu --version
```

## Getting Started

### 1. Login

First, authenticate with your Yansu account:

```bash
yansu login
```

This opens your browser for authentication. Once logged in, the CLI stores your credentials securely.

### 2. Clone a Project

Clone a project from Yansu with full context:

```bash
yansu clone <org>/<product>/<project>
```

For example:
```bash
yansu clone acme/web-app/user-auth-feature
```

This will:
- Clone the Git repository
- Download the project's knowledge base
- Set up AI agent instruction files (CLAUDE.md, .cursorrules, etc.)
- Install git hooks for automatic knowledge capture
- Register the project with the background daemon

### 3. Start Coding

Open the project in your favorite AI coding assistant:

```bash
cd user-auth-feature
claude  # or cursor, windsurf, etc.
```

The AI agent will automatically read the knowledge base from `.something/` directory.

## Commands

### Authentication

| Command | Description |
|---------|-------------|
| `yansu login` | Authenticate with Yansu |
| `yansu logout` | Log out from Yansu |
| `yansu status` | Show authentication and project status |

### Project Management

| Command | Description |
|---------|-------------|
| `yansu clone <org/product/project>` | Clone a project with full context |
| `yansu sync` | Manually sync knowledge with cloud |
| `yansu push` | Push code and knowledge to remote |
| `yansu push --code` | Push only git commits |
| `yansu push --knowledge` | Push only knowledge |

### Daemon Management

| Command | Description |
|---------|-------------|
| `yansu daemon` | Start the background sync daemon |
| `yansu register [path]` | Register a project with the daemon |
| `yansu unregister [path]` | Unregister a project from the daemon |
| `yansu projects` | List all registered projects |

### Service Management

| Command | Description |
|---------|-------------|
| `yansu service install` | Install as a system service (auto-start on login) |
| `yansu service uninstall` | Remove the system service |
| `yansu service start` | Start the service |
| `yansu service stop` | Stop the service |
| `yansu service status` | Show service status |
| `yansu service logs` | Show service logs |

### Other Commands

| Command | Description |
|---------|-------------|
| `yansu analyze` | Analyze recent changes and suggest knowledge to capture |
| `yansu hook install` | Install git hooks for automatic knowledge capture |
| `yansu hook uninstall` | Remove git hooks |
| `yansu update` | Update yansu to the latest version |

## Background Daemon

The background daemon automatically syncs knowledge between your local projects and the Yansu cloud.

### Architecture

```
┌─────────────────────────────────────────────────────────┐
│              Global Daemon (single process)             │
│  Socket: ~/.yansu-agent/daemon.sock                     │
│  Registry: ~/.yansu-agent/registry.json                 │
└─────────────────────────────────────────────────────────┘
        ▲ register        ▲ unregister       ▲ list
        │                 │                  │
   yansu clone      yansu unregister    yansu projects
```

### Install as System Service (Recommended)

Install the daemon as a system service to start automatically on login:

```bash
yansu service install
```

This creates:
- **macOS**: LaunchAgent at `~/Library/LaunchAgents/ai.yansu.agent.plist`
- **Linux**: systemd user service at `~/.config/systemd/user/yansu-agent.service`

### Manual Daemon Control

Start the daemon manually (foreground):
```bash
yansu daemon
```

Start the daemon for a specific project only:
```bash
yansu daemon --project /path/to/project
```

### View Registered Projects

```bash
yansu projects
```

## AI Agent Integration

Yansu Agent automatically creates instruction files for popular AI coding assistants:

| File | AI Agent |
|------|----------|
| `CLAUDE.md` | Claude Code |
| `.cursorrules` | Cursor |
| `.windsurfrules` | Windsurf |
| `AGENTS.md` | OpenAI Codex |
| `.github/copilot-instructions.md` | GitHub Copilot |

These files instruct the AI agent to:
1. Read the knowledge base before making changes
2. Follow project patterns and conventions
3. Capture new knowledge after completing tasks

## Knowledge Capture

### Automatic Capture (Git Hook)

When you commit code, the post-commit hook automatically:
1. Analyzes your changes using AI
2. Extracts patterns, decisions, and learnings
3. Creates knowledge files in `.something/new-knowledge/`
4. Syncs to the cloud via the daemon

### Manual Capture

Create knowledge manually by writing to `.something/new-knowledge/<name>.md`:

```markdown
# Action
create

# Trigger
How to handle authentication errors in this project

# Content
Always use the `AuthErrorHandler` wrapper for authentication errors:

```go
err := authService.Validate(token)
if err != nil {
    return AuthErrorHandler.Handle(err)
}
```

This ensures consistent error messages and proper logging.
```

### Analyze Recent Changes

Get AI suggestions for knowledge to capture:

```bash
yansu analyze              # Analyze last commit
yansu analyze --commits 5  # Analyze last 5 commits
yansu analyze --auto       # Auto-generate drafts
```

## Directory Structure

After cloning a project, you'll have:

```
project/
├── .something/
│   ├── project.json          # Project configuration
│   ├── context.md            # Project context and requirements
│   ├── knowledge/            # Synced knowledge base
│   │   ├── _index.md         # Quick lookup index
│   │   └── *.md              # Knowledge files
│   ├── new-knowledge/        # Pending knowledge (not yet synced)
│   └── activity/             # Activity logs
├── CLAUDE.md                 # Claude Code instructions
├── .cursorrules              # Cursor instructions
├── .windsurfrules            # Windsurf instructions
└── ...
```

## Troubleshooting

### "Not authenticated" error

Run `yansu login` to authenticate.

### "Daemon not running" warning

Install and start the daemon:
```bash
yansu service install
```

Or run manually:
```bash
yansu daemon &
```

### Knowledge not syncing

1. Check daemon status: `yansu service status`
2. Check registered projects: `yansu projects`
3. Manual sync: `yansu sync`

### Git clone fails

If cloning via the Yansu proxy fails:
1. Check your authentication: `yansu status`
2. Verify the project exists in Yansu dashboard
3. Ensure you have access to the repository

### Update to latest version

```bash
yansu update
```

## Support

- Dashboard: [dashboard.yansu.ai](https://dashboard.yansu.ai)
- Issues: [GitHub Issues](https://github.com/Isoform/yansu-releases/issues)
