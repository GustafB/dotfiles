#!/bin/bash

set -e

# Function to check if clang-17 is installed
check_clang_installed() {
    if ! command -v clang-17 &> /dev/null; then
        echo "clang-17 is not installed. Please install clang-17 before running this script."
        exit 1
    fi
}

# Function to install clangd-17
install_clangd() {
    echo "Updating package list..."
    sudo apt update -y

    echo "Installing clangd-17..."
    sudo apt install -y clangd-17

    echo "Verifying the installation..."
    if command -v clangd-17 &> /dev/null; then
        echo "clangd-17 installed successfully."
    else
        echo "clangd-17 installation failed."
        exit 1
    fi
}

# Main script
main() {
    check_clang_installed
    install_clangd
}

main
