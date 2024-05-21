#!/bin/bash

set -e

# Function to check if ranger is already installed
check_ranger_installed() {
    if command -v ranger &> /dev/null; then
        echo "Ranger is already installed."
        return 0
    else
        return 1
    fi
}

# Function to install ranger
install_ranger() {
    echo "Updating package list..."
    sudo apt update -y

    echo "Installing Ranger..."
    sudo apt install -y ranger

    echo "Verifying the installation..."
    if command -v ranger &> /dev/null; then
        echo "Ranger installed successfully."
    else
        echo "Ranger installation failed."
        exit 1
    fi
}

# Main script
main() {
    if ! check_ranger_installed; then
        install_ranger
    fi
}

main
