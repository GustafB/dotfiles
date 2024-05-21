#!/bin/bash

set -e

# Function to check if pure prompt is already installed
check_pure_installed() {
    if [ -d "$HOME/.zsh/pure" ]; then
        echo "Pure prompt is already installed."
        return 0
    else
        return 1
    fi
}

# Function to install pure prompt
install_pure_prompt() {
    echo "Installing Pure prompt..."
    mkdir -p "$HOME/.zsh"
    git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
    echo "Pure prompt installed successfully."
}

# Main script
main() {
    if ! check_pure_installed; then
        install_pure_prompt
    fi
}

main
