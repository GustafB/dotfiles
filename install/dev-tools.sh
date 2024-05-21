#!/bin/bash

# List of default development tools to install
DEV_TOOLS=(
    git
    make
    gdb
    valgrind
    curl
    wget
    vim
    build-essential
    ninja-build
    lldb
    libssl-dev
)

# Function to update the package list
update_package_list() {
    echo "Updating package list..."
    sudo apt update -y
}

# Function to install development tools
install_dev_tools() {
    echo "Installing development tools..."
    for tool in "${DEV_TOOLS[@]}"; do
        sudo apt install -y "$tool"
    done
}

# Function to verify the installation
verify_installation() {
    echo "Verifying installation..."
    for tool in "${DEV_TOOLS[@]}"; do
        if command -v "$tool" &> /dev/null; then
            echo "$tool is installed."
        else
            echo "Failed to install $tool."
        fi
    done
}

# Main script
main() {
    update_package_list
    install_dev_tools
    verify_installation
}

main
