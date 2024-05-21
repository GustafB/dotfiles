#!/bin/bash

set -e

# Function to check the OS and architecture
detect_os_arch() {
    OS="$(uname -s)"
    ARCH="$(uname -m)"

    case "${OS}" in
        Linux*)     OS=linux;;
        Darwin*)    OS=macos;;
        *)          echo "Unsupported OS: ${OS}"; exit 1;;
    esac

    case "${ARCH}" in
        x86_64)     ARCH=64;;
        arm64)      ARCH=arm64;;
        aarch64)    ARCH=arm64;;
        *)          echo "Unsupported architecture: ${ARCH}"; exit 1;;
    esac
}

# Function to check if the latest version of Neovim is already installed
check_neovim_version() {
    if command -v nvim &> /dev/null; then
        current_version=$(nvim --version | head -n1 | awk '{print $2}')
        latest_version=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
        if [ "$current_version" = "$latest_version" ]; then
            echo "Neovim $latest_version is already installed."
            return 0
        fi
    fi
    return 1
}

# Function to install required dependencies
install_dependencies() {
    echo "Updating package list..."
    sudo apt update -y

    echo "Installing required dependencies..."
    sudo apt install -y wget tar
}

# Function to download and install the latest version of Neovim
install_neovim() {
    latest_version=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")' | sed 's/^v//')
    nvim_tarball="nvim-${OS}${ARCH}.tar.gz"
    download_url="https://github.com/neovim/neovim/releases/download/v${latest_version}/${nvim_tarball}"

    echo "Fetching the latest version of Neovim..."
    wget ${download_url}

    echo "Extracting Neovim ${latest_version}..."
    tar -zxvf ${nvim_tarball}

    echo "Installing Neovim ${latest_version}..."
    sudo mv "nvim-${OS}${ARCH}" /usr/local/neovim
    sudo ln -sf /usr/local/neovim/bin/nvim /usr/local/bin/nvim

    echo "Verifying the installation..."
    nvim --version

    echo "Cleaning up..."
    rm -rf ${nvim_tarball}

    echo "Neovim ${latest_version} installation completed successfully."
}

# Main script
main() {
    detect_os_arch
    if ! check_neovim_version; then
        install_dependencies
        install_neovim
    fi
}

main
