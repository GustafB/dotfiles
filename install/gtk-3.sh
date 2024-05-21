#!/bin/bash

set -e

# Function to check if GTK-3 is already installed
check_gtk_installed() {
    if pkg-config --exists gtk+-3.0; then
        echo "GTK-3 is already installed."
        return 0
    else
        return 1
    fi
}

# Function to install GTK-3
install_gtk() {
    echo "Updating package list..."
    sudo apt update -y

    echo "Installing GTK-3..."
    sudo apt install -y libgtk-3-dev

    echo "Verifying the installation..."
    if pkg-config --exists gtk+-3.0; then
        echo "GTK-3 installed successfully."
    else
        echo "GTK-3 installation failed."
        exit 1
    fi
}

# Main script
main() {
    if ! check_gtk_installed; then
        install_gtk
    fi
}

main
