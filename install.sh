#!/bin/bash
set -euo pipefail

# Find the folder containing this script
DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Programs I want installed
TOOLS=(git micro tmux)

echo "Starting my Linux setup..."

# Install tools only if they are missing
for tool in "${TOOLS[@]}"; do
    if dpkg -s "$tool" >/dev/null 2>&1; then
        echo "$tool is already installed."
    else
        echo "Installing $tool..."
        sudo apt-get update
        sudo apt-get install -y "$tool"
    fi
done

# Create a custom dotfile if needed
if [[ ! -f "$DOTFILES_DIR/.bash_aliases" ]]; then
    echo "alias ll='ls -alF'" > "$DOTFILES_DIR/.bash_aliases"
fi

# Back up an existing regular dotfile before linking
if [[ -e "$HOME/.bash_aliases" && ! -L "$HOME/.bash_aliases" ]]; then
    mv "$HOME/.bash_aliases" "$HOME/.bash_aliases.backup.$(date +%s)"
fi

# Link the dotfile into the home directory
ln -sfn "$DOTFILES_DIR/.bash_aliases" "$HOME/.bash_aliases"

echo "Dotfile linked successfully."
echo "Linux setup completed!"

