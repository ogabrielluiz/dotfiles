#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Directory containing this script
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}Installing dotfiles from ${DOTFILES_DIR}${RESET}\n"

# Create necessary directories
mkdir -p "$HOME/.config"

# ZSH Configuration
echo -e "${BLUE}Setting up ZSH configuration...${RESET}"
if [ -f "$HOME/.zshrc" ]; then
    echo -e "${YELLOW}Backing up existing .zshrc to .zshrc.backup${RESET}"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi
ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
echo -e "${GREEN}✓ ZSH configuration linked${RESET}"

# Starship Configuration
echo -e "${BLUE}Setting up Starship prompt...${RESET}"
if [ -f "$HOME/.config/starship.toml" ]; then
    echo -e "${YELLOW}Backing up existing starship.toml to starship.toml.backup${RESET}"
    mv "$HOME/.config/starship.toml" "$HOME/.config/starship.toml.backup"
fi
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
echo -e "${GREEN}✓ Starship configuration linked${RESET}"

# Git Configuration
echo -e "${BLUE}Setting up Git configuration...${RESET}"
if [ -f "$HOME/.gitconfig" ]; then
    echo -e "${YELLOW}Backing up existing .gitconfig to .gitconfig.backup${RESET}"
    mv "$HOME/.gitconfig" "$HOME/.gitconfig.backup"
fi
ln -sf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

if [ -f "$HOME/.gitignore_global" ]; then
    echo -e "${YELLOW}Backing up existing .gitignore_global to .gitignore_global.backup${RESET}"
    mv "$HOME/.gitignore_global" "$HOME/.gitignore_global.backup"
fi
ln -sf "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
echo -e "${GREEN}✓ Git configuration linked${RESET}"

# API Keys setup
echo -e "${BLUE}Setting up API keys template...${RESET}"
if [ ! -f "$HOME/.api_keys" ]; then
    cp "$DOTFILES_DIR/example.api_keys" "$HOME/.api_keys"
    echo -e "${GREEN}✓ API keys template created at ~/.api_keys${RESET}"
    echo -e "${YELLOW}Please edit ~/.api_keys and add your actual API keys${RESET}"
else
    echo -e "${YELLOW}API keys file already exists at ~/.api_keys${RESET}"
fi

# Remind user to customize Git config
echo -e "${YELLOW}Remember to customize your Git user information:${RESET}"
echo -e "git config --global user.name \"Your Name\""
echo -e "git config --global user.email \"your.email@example.com\""

# Check if essential tools are installed
echo -e "\n${BLUE}Checking for required tools...${RESET}"

check_command() {
    if command -v "$1" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ $1 is installed${RESET}"
    else
        echo -e "${RED}✗ $1 is not installed${RESET}"
        echo -e "${YELLOW}To install $1: $2${RESET}"
    fi
}

# Check for important tools with installation instructions
check_command "zsh" "brew install zsh"
check_command "starship" "curl -sS https://starship.rs/install.sh | sh"
check_command "zoxide" "brew install zoxide"
check_command "exa" "brew install exa"
check_command "gh" "brew install gh"

echo -e "\n${GREEN}Dotfiles installation complete!${RESET}"
echo -e "${YELLOW}You may need to restart your terminal or run 'source ~/.zshrc' for all changes to take effect.${RESET}" 