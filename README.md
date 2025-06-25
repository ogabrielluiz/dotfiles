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

This will create symbolic links from the files in this repository to your home directory.

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

- Custom aliases
- Functions for Git workflow
- Integration with tools like zoxide, starship

### Starship

A customized Starship prompt with:

- Directory truncation
- Git status information
- Language version indicators

### Git

Git configurations for everyday use.

## Customization

Feel free to fork this repository and customize it to your liking. The modular structure makes it easy to add or remove components.
