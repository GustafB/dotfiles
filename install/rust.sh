#!/bin/bash

set -e

# Function to check if Rust is already installed
check_rust_installed() {
    if command -v rustc &> /dev/null && command -v cargo &> /dev/null; then
        echo "Rust and Cargo are already installed."
        return 0
    else
        return 1
    fi
}

# Function to install Rust and Cargo
install_rust() {
    echo "Installing Rust and Cargo..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    echo "Setting up environment variables..."
    source $HOME/.cargo/env

    echo "Verifying the installation..."
    if command -v rustc &> /dev/null && command -v cargo &> /dev/null; then
        echo "Rust and Cargo installed successfully."
        rustc --version
        cargo --version
    else
        echo "Rust and Cargo installation failed."
        exit 1
    fi
}

# Main script
main() {
    if ! check_rust_installed; then
        install_rust
    fi
}

main
