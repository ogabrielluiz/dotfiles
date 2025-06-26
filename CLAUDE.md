# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that provides shell configurations, prompt customization, and development environment setup. The repository uses chezmoi for dotfiles management, which provides a sophisticated approach to managing configuration files across different machines with templating and encryption support.

## Installation Commands

### Chezmoi Workflow
```bash
# Initialize chezmoi with this repository
chezmoi init https://github.com/username/dotfiles.git

# Preview changes before applying
chezmoi diff

# Apply dotfiles
chezmoi apply

# Update from repository
chezmoi update

# Edit a file (will open in editor and apply on save)
chezmoi edit ~/.zshrc

# Add new files to be managed by chezmoi
chezmoi add ~/.new_config_file

# Re-add existing files after manual changes
chezmoi re-add
```

### Post-Installation Setup
```bash
# Configure Git user information
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Edit API keys file
edit ~/.api_keys

# Apply ZSH changes
source ~/.zshrc
```

## Repository Structure

### Core Components
- **zsh/.zshrc**: Main ZSH configuration with custom functions, aliases, and integrations
- **starship/starship.toml**: Starship prompt configuration with custom styling
- **git/.gitconfig**: Git configuration with aliases and tool settings
- **git/.gitignore_global**: Global Git ignore patterns
- **example.api_keys**: Template for API keys (copied to ~/.api_keys)
- **.chezmoi.toml**: Chezmoi configuration file (located in `~/.local/share/chezmoi/`)

### Key ZSH Functions
- `gcop <main_branch> [action]`: Update main branch and optionally rebase/merge into current branch
- `ghpr <PR_NUMBER_OR_URL>`: Safely checkout GitHub PR, stashing local changes
- `gnew <branch_name> [base_branch]`: Create new branch from main (or specified base)
- `gcos <branch_or_tag>`: Stash changes, checkout branch/tag, then apply stash
- `show_diff <--backend|--frontend|--docs> [--all|--A|--M]`: Show diff between versions with file filtering
- `kp <port1> [port2] ...`: Kill processes on specified ports
- `kplf`: Kill Langflow processes (ports 3000 and 7860)

### Important Aliases
- `gpl`: `git push --force-with-lease`
- `gpp`: `git pull --rebase && git push`
- `ls`: `exa --icons -F -H --group-directories-first --git -1`
- `rc`: `code ~/.zshrc`
- `src`: `source ~/.zshrc`
- `cdl`, `cdl2`, `cdlf`, `cdlb`, `cdlbb`: Quick navigation to Langflow project directories

## Environment Features

### Integrations
- **Oh-My-Zsh**: ZSH framework with plugins (git, python, pip, syntax highlighting, autosuggestions)
- **Starship**: Cross-shell prompt with Git integration and language version indicators
- **zoxide**: Smarter directory navigation
- **exa**: Modern replacement for ls with Git integration

### URL Auto-handling
The configuration includes automatic GitHub PR URL detection - pasting a GitHub PR URL will automatically checkout that PR using the `ghpr` function.

### Chezmoi Migration Notes
- When migrating existing files to chezmoi, use `chezmoi add <file>` to start managing them
- Template variables can be used in chezmoi for machine-specific configurations
- Sensitive files like API keys can be encrypted using chezmoi's encryption features
- Use `chezmoi edit <file>` to make changes that will be automatically applied

### API Keys Management
API keys are stored separately in `~/.api_keys` and sourced automatically. The template includes keys for:
- OpenAI, Anthropic, Groq, NVIDIA
- Tavily, Composio, Hugging Face
- Astra DB, CodeFlash

### Development Environment
- Python environment with UV support
- Node.js with pnpm and NVM
- Docker with platform configuration
- Various development tools (UV, LM Studio, Windsurf)
- Langflow-specific configurations and shortcuts