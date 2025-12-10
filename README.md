# devenv

A modular development environment using Dev Containers and Features.

[![Build and Push Dev Containers](https://github.com/callmeradical/devenv/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/callmeradical/devenv/actions/workflows/docker-publish.yml)
[![Test Dev Containers](https://github.com/callmeradical/devenv/actions/workflows/devcontainer-ci.yml/badge.svg)](https://github.com/callmeradical/devenv/actions/workflows/devcontainer-ci.yml)

## Overview

This repository provides a flexible development environment setup using:
- **Dev Containers** for consistent development environments
- **Custom Features** for modular tool installation
- **Base tools** including git, curl, neovim, zsh, ripgrep, and more
- **Optional Node.js** support via features

## Quick Start

### Using VS Code

1. Clone this repository
2. Open in VS Code
3. When prompted, click "Reopen in Container"
4. Once container starts, run `tmux` to access your pre-configured development environment

### Using Dev Container CLI

```bash
# Install the CLI
npm install -g @devcontainers/cli

# Build and run the dev container
devcontainer up --workspace-folder .

# Execute commands in the container
devcontainer exec --workspace-folder . tmux
```

### Using the Environment

Your dotfiles from [callmeradical/dotfiles](https://github.com/callmeradical/dotfiles) are automatically installed, giving you:

- **Neovim**: Fully configured with your plugins and settings
- **Tmux**: With your key bindings and TPM for plugin management
- **Zsh**: With Oh My Zsh and your custom configurations
- **Git**: With your aliases and configurations

Start a new tmux session:
```bash
tmux new -s dev
```

Or attach to an existing session:
```bash
tmux attach -t dev
```

## Available Configurations

### Default Configuration (Node.js + Base Tools)

The default `devcontainer.json` includes both base tools and Node.js development environment.

### Base Tools Only

To use only the base tools without Node.js:

```json
{
  "name": "Base Development Environment",
  "image": "mcr.microsoft.com/devcontainers/base:debian",
  "features": {
    "./features/base-tools": {}
  },
  "customizations": {
    "vscode": {
      "settings": {
        "terminal.integrated.defaultProfile.linux": "zsh"
      }
    }
  },
  "remoteUser": "vscode",
  "workspaceMount": "source=${localWorkspaceFolder},target=/workspace,type=bind",
  "workspaceFolder": "/workspace"
}
```

## Structure

```
.devcontainer/
├── devcontainer.json          # Main dev container configuration
├── devcontainer.nodejs.json   # Node.js variant reference
└── features/
    ├── base-tools/            # Essential development tools
    │   ├── devcontainer-feature.json
    │   └── install.sh
    └── nodejs/                # Node.js development environment
        ├── devcontainer-feature.json
        └── install.sh
```

## Available Features

### Base Tools (`base-tools`)
- **Build tools**: build-essential, git, curl
- **Search tools**: ripgrep, fd-find  
- **Editor**: Neovim with pynvim support
- **Python**: Python 3 with pip and pipx
- **Shell**: Zsh with Oh My Zsh
- **Plugins**: zsh-autosuggestions, zsh-syntax-highlighting
- **Terminal multiplexer**: tmux with TPM (Tmux Plugin Manager)
- **Utilities**: screen, sudo, locales, stow
- **Dotfiles**: Automatically installs from [callmeradical/dotfiles](https://github.com/callmeradical/dotfiles)
  - Pre-configured Neovim setup
  - Tmux configuration with plugins
  - Zsh configuration
  - Git aliases and settings

### Node.js (`nodejs`)
- **Node.js**: Installed via NVM (configurable version)
- **Package managers**: npm (included with Node.js)
- **Global packages**: TypeScript, ts-node, nodemon
- **Persistent configuration**: NVM automatically loaded in shells

## Pre-built Images

Ready-to-use images are available:

### Docker Hub
- `callmeradical/devenv:latest` - Base tools only
- `callmeradical/devenv:base` - Base tools only
- `callmeradical/devenv:nodejs` - Base tools + Node.js

### GitHub Container Registry
- `ghcr.io/callmeradical/devenv:base` - Base tools only
- `ghcr.io/callmeradical/devenv:nodejs` - Base tools + Node.js

## Customization

### Adding New Features

1. Create a new directory under `.devcontainer/features/your-feature/`
2. Add `devcontainer-feature.json`:
   ```json
   {
     "id": "your-feature",
     "version": "1.0.0",
     "name": "Your Feature Name",
     "description": "Description of your feature",
     "options": {}
   }
   ```
3. Add `install.sh` with installation logic
4. Reference in `devcontainer.json`:
   ```json
   "features": {
     "./features/base-tools": {},
     "./features/your-feature": {}
   }
   ```

### Modifying Node.js Version

```json
"features": {
  "./features/nodejs": {
    "version": "18"  // or "20", "22", etc.
  }
}
```

## Troubleshooting

### Common Issues

1. **Oh My Zsh already exists error**: The feature checks if Oh My Zsh is already installed
2. **Theme not changing**: The devcontainers base image overrides some zsh configurations
3. **ARM64 compatibility**: Uses appropriate Neovim packages for ARM64 systems

### Container Won't Start

```bash
# Check logs
docker logs $(docker ps -a -q -n 1)

# Rebuild without cache
devcontainer build --no-cache --workspace-folder .
```

### Tools Not Found

Ensure you're using the correct shell and user:
```bash
# NVM/Node commands need sourcing
source ~/.nvm/nvm.sh

# Or use the vscode user
su - vscode
```

## Migration from Branch-Based Approach

If you were using the previous branch-based system:

- `main` branch → Use base configuration
- `node` branch → Use default configuration with Node.js feature

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally with `devcontainer build`
5. Submit a pull request

## License

This project is open source and available under the [MIT License](LICENSE).
