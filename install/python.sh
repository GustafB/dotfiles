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
    sudo apt install -y wget build-essential libssl-dev zlib1g-dev libncurses5-dev libncursesw5-dev \
                        libreadline-dev libsqlite3-dev libgdbm-dev libdb5.3-dev libbz2-dev \
                        libexpat1-dev liblzma-dev tk-dev curl
}

# Function to get the latest version of Python
get_latest_python_version() {
    latest_version=$(curl -s https://endoflife.date/api/python.json | grep -oP '"latest"\s*:\s*"\K[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
    echo "Latest Python version is ${latest_version}"
}

check_python_version() {
    if command -v python3 &> /dev/null; then
        installed_version=$(python3 --version | awk '{print $2}')
        if [ "$installed_version" == "$latest_version" ]; then
            echo "Python $installed_version is already the latest version."
            exit 0
        fi
    fi
}

# Function to download and install the latest version of Python
install_python() {
    python_tarball="Python-${latest_version}.tgz"
    download_url="https://www.python.org/ftp/python/${latest_version}/${python_tarball}"

    echo "Fetching the latest version of Python (${latest_version})..."
    wget ${download_url}

    echo "Extracting Python ${latest_version}..."
    tar -zxvf ${python_tarball}
    cd Python-${latest_version}

    echo "Configuring the build..."
    ./configure --enable-optimizations

    echo "Building and installing Python ${latest_version}..."
    make -j$(nproc)
    sudo make altinstall

    echo "Verifying the installation..."
    python${latest_version%.*} --version

    echo "Cleaning up..."
    cd ..
    rm -rf Python-${latest_version} ${python_tarball}

    echo "Python ${latest_version} installation completed successfully."
}

# Main script
main() {
    detect_os_arch
    install_dependencies
    get_latest_python_version
    check_python_version
    install_python
}

main
