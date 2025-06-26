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

# Edit encrypted API keys file
chezmoi edit ~/.api_keys

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

### Chezmoi Encryption & Security
- **Age encryption** is configured for sensitive files like API keys
- **Private key** is stored locally at `~/.config/chezmoi/key.txt` (never commit this!)
- **Encrypted files** are safely stored in the repository and sync across machines
- **Backup your age private key** securely (password manager recommended)

Common chezmoi commands:
```bash
# Add new files to chezmoi management
chezmoi add <file>

# Add files with encryption
chezmoi add --encrypt <sensitive_file>

# Edit any managed file
chezmoi edit <file>

# View what would change
chezmoi diff

# Apply all changes
chezmoi apply
```

### API Keys Management
API keys are managed using chezmoi with age encryption for security:

```bash
# Edit encrypted API keys (will decrypt, open editor, re-encrypt on save)
chezmoi edit ~/.api_keys

# View current encrypted status
chezmoi status

# Apply any changes
chezmoi apply
```

The encrypted file includes keys for:
- OpenAI, Anthropic, Groq, NVIDIA
- Tavily, Composio, Hugging Face
- Astra DB, CodeFlash

Keys are encrypted with age and safely synced across machines. 

**Initial Setup Options:**
1. **Existing machine**: API keys are already encrypted and managed by chezmoi
2. **New machine setup**: Use `chezmoi apply --exclude encrypted` to apply non-encrypted files first, then manually set up API keys
3. **Fresh start**: Remove encrypted file and use the automated template with prompts

### Development Environment
- Python environment with UV support
- Node.js with pnpm and NVM
- Docker with platform configuration
- Various development tools (UV, LM Studio, Windsurf)
- Langflow-specific configurations and shortcuts

## Claude Workflow Guidance

### Workflow Principles
- Always update CLAUDE.md when the workflow or structure changes