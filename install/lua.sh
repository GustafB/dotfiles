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

# Function to install required dependencies
install_dependencies() {
    echo "Updating package list..."
    sudo apt update -y

    echo "Installing required dependencies..."
    sudo apt install -y wget build-essential libreadline-dev
}

# Function to get the latest version of Lua
get_latest_lua_version() {
    latest_version=$(curl -s https://www.lua.org/ftp/ | grep -oP 'lua-[0-9]+\.[0-9]+\.[0-9]+\.tar\.gz' | sort -V | tail -1 | grep -oP '[0-9]+\.[0-9]+\.[0-9]+')
    echo "Latest Lua version is ${latest_version}"
}

# Function to check if the installed Lua version matches the latest version
check_lua_version() {
    if command -v lua &> /dev/null; then
        installed_version=$(lua -v | grep -oP 'Lua \K[0-9]+\.[0-9]+\.[0-9]+')
        if [ "$installed_version" == "$latest_version" ]; then
            echo "Lua $installed_version is already the latest version."
            exit 0
        fi
    fi
}

# Function to download and install the latest version of Lua
install_lua() {
    lua_tarball="lua-${latest_version}.tar.gz"
    download_url="https://www.lua.org/ftp/${lua_tarball}"

    echo "Fetching the latest version of Lua (${latest_version})..."
    wget ${download_url}

    echo "Extracting Lua ${latest_version}..."
    tar -zxvf ${lua_tarball}
    cd lua-${latest_version}

    echo "Building and installing Lua ${latest_version}..."
    make linux test
    sudo make install

    echo "Verifying the installation..."
    lua -v

    echo "Cleaning up..."
    cd ..
    rm -rf lua-${latest_version} ${lua_tarball}

    echo "Lua ${latest_version} installation completed successfully."
}

# Main script
main() {
    detect_os_arch
    install_dependencies
    get_latest_lua_version
    check_lua_version
    install_lua
}

main
