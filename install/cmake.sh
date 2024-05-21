#!/bin/bash

set -e

# Function to check the OS and architecture
detect_os_arch() {
    OS="$(uname -s)"
    ARCH="$(uname -m)"

    case "${OS}" in
        Linux*)     OS=linux;;
        Darwin*)    OS=darwin;;
        *)          echo "Unsupported OS: ${OS}"; exit 1;;
    esac

    case "${ARCH}" in
        x86_64)     ARCH=x86_64;;
        arm64)      ARCH=arm64;;
        aarch64)    ARCH=arm64;;
        *)          echo "Unsupported architecture: ${ARCH}"; exit 1;;
    esac
}

# Function to check if the latest version of CMake is already installed
check_cmake_version() {
    if command -v cmake &> /dev/null; then
        current_version=$(cmake --version | head -n1 | awk '{print $3}')
        latest_version=$(curl -s https://api.github.com/repos/Kitware/CMake/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")' | sed 's/^v//')
        if [ "$current_version" = "$latest_version" ]; then
            echo "CMake $latest_version is already installed."
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
    sudo apt install -y wget build-essential libssl-dev
}

# Function to download and install the latest version of CMake
install_cmake() {
    latest_version=$(curl -s https://api.github.com/repos/Kitware/CMake/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")' | sed 's/^v//')
    cmake_tarball="cmake-${latest_version}-${OS}-${ARCH}.tar.gz"
    download_url="https://github.com/Kitware/CMake/releases/download/v${latest_version}/${cmake_tarball}"

    echo "Fetching the latest version of CMake..."
    wget ${download_url}

    echo "Extracting CMake ${latest_version}..."
    tar -zxvf ${cmake_tarball}
    cd cmake-${latest_version}-${OS}-${ARCH}

    echo "Building and installing CMake ${latest_version}..."
    ./bootstrap
    make -j$(nproc)
    sudo make install

    echo "Verifying the installation..."
    cmake --version

    echo "Cleaning up..."
    cd ..
    rm -rf cmake-${latest_version}-${OS}-${ARCH} ${cmake_tarball}

    echo "CMake ${latest_version} installation completed successfully."
}

# Main script
main() {
    detect_os_arch
    if ! check_cmake_version; then
        install_dependencies
        install_cmake
    fi
}

main
