# Gabriel's Dotfiles

This repository contains my personal dotfiles for various tools and applications. These configurations help maintain a consistent environment across different machines.

## What's Included

- ZSH configuration with Oh-My-Zsh
- Starship prompt customization
- Git configuration
- Custom functions and aliases
- Various tool configurations

## Installation

To install these dotfiles, you can use the installation script:

```bash
./install.sh
```

This will create symbolic links from the files in this repository to your home directory and set up an API keys template.

### After Installation

1. **Configure Git**: Update your Git user information
2. **Setup API Keys**: Edit `~/.api_keys` with your actual API keys
3. **Restart Terminal**: Or run `source ~/.zshrc` to apply changes

## Manual Installation

You can also manually link the configurations:

```bash
ln -sf $(pwd)/zsh/.zshrc ~/.zshrc
ln -sf $(pwd)/starship/starship.toml ~/.config/starship.toml
# Add more as needed
```

## Components

### ZSH

The ZSH configuration includes:

- Custom aliases and functions
- Git workflow helpers (`gcop`, `ghpr`, `gnew`, etc.)
- Integration with tools like zoxide, starship
- Support for multiple development environments
- API keys management

### Starship

A customized Starship prompt with:

- Directory truncation
- Git status information
- Language version indicators
- Custom colors and formatting

### Git

Git configurations for everyday use:

- Useful aliases
- Better diff and merge tools
- Automatic cleanup settings

### Security

- API keys are stored separately in `~/.api_keys`
- Sensitive information is not tracked in the repository
- Template provided for easy setup

## Customization

Feel free to fork this repository and customize it to your liking. The modular structure makes it easy to add or remove components.
