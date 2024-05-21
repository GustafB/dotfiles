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
        x86_64)     ARCH=amd64;;
        arm64)      ARCH=arm64;;
        aarch64)    ARCH=arm64;;
        *)          echo "Unsupported architecture: ${ARCH}"; exit 1;;
    esac
}

# Function to download the latest Go tarball
download_go() {
    LATEST_GO=$(wget -qO- https://go.dev/VERSION?m=text | head -n 1)
    GO_TARBALL="${LATEST_GO}.${OS}-${ARCH}.tar.gz"
    DOWNLOAD_URL="https://dl.google.com/go/${GO_TARBALL}"

    echo "Downloading ${DOWNLOAD_URL}..."
    wget "${DOWNLOAD_URL}"
}

# Function to install Go
install_go() {
    echo "Installing Go..."
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "${GO_TARBALL}"
    rm -f "${GO_TARBALL}"
    echo "Go installed to /usr/local/go"
}

# Function to set Go environment variables
setup_go_env() {
    echo "Setting up Go environment variables..."
    echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
    echo "export PATH=\$PATH:$(go env GOPATH)/bin" >> ~/.profile
    source ~/.profile
    echo "Go environment variables set."
}

# Function to install gopls
install_gopls() {
    echo "Installing gopls..."
    /usr/local/go/bin/go install golang.org/x/tools/gopls@latest
    echo "gopls installed."
}

# Main script
main() {
    detect_os_arch
    download_go
    install_go
    setup_go_env
    install_gopls
    echo "Installation completed successfully."
}

main
