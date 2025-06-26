# Gabriel's Dotfiles

This repository contains my personal dotfiles for various tools and applications. These configurations help maintain a consistent environment across different machines using chezmoi for sophisticated dotfiles management.

## What's Included

- ZSH configuration with Oh-My-Zsh and custom functions
- Starship prompt customization with language indicators
- Git configuration with workflow helpers
- Custom GitHub PR handling and Git operations
- Development environment setup (Node.js, Python, Docker)
- API keys management with age encryption
- Chezmoi integration for cross-machine synchronization

## Installation

### Using Chezmoi (Recommended)

```bash
# Install chezmoi if not already installed
curl -sfL https://git.io/chezmoi | sh

# Initialize with this repository
chezmoi init https://github.com/ogabrielluiz/dotfiles.git

# Preview changes
chezmoi diff

# Apply dotfiles
chezmoi apply
```

### Quick Setup

```bash
# Update from repository
chezmoi update

# Edit configurations
chezmoi edit ~/.zshrc
```

### Post-Installation

1. **Configure Git**: Update your Git user information
2. **Setup API Keys**: Use `chezmoi edit ~/.api_keys` to securely manage encrypted API keys
3. **Restart Terminal**: Or run `source ~/.zshrc` to apply changes

## Key Features

### Advanced Git Workflow

- **`gcop <branch> [action]`**: Update main branch and rebase/merge into current branch
- **`ghpr <PR_URL>`**: Safely checkout GitHub PRs with automatic stash handling
- **`gnew <branch>`**: Create new branch from main with stash management
- **Auto PR URL detection**: Paste GitHub PR URLs to automatically checkout

### Development Tools

- **Port management**: `kp <port>` to kill processes, `kplf` for Langflow
- **Smart navigation**: zoxide integration for quick directory switching
- **Enhanced listing**: exa with Git integration and icons
- **Multiple environments**: Node.js, Python, Docker configurations

### Prompt & Shell

- **Starship prompt**: Custom styling with Git status and language indicators
- **ZSH enhancements**: Syntax highlighting, autosuggestions, completions
- **Tool integrations**: UV, NVM, pnpm, and development utilities

### Security & Management

- **API keys**: Age-encrypted management with secure cross-machine sync
- **Chezmoi**: Cross-machine synchronization with templating
- **Git security**: Global ignore patterns and safe configurations

## Documentation

See [CLAUDE.md](CLAUDE.md) for comprehensive documentation including:

- Detailed function usage and examples
- Chezmoi workflow and migration notes
- Development environment setup
- Tool integrations and configurations

## Customization

This dotfiles setup is designed to be easily customizable. Use chezmoi's templating features for machine-specific configurations, and feel free to modify the ZSH functions and aliases to match your workflow.
