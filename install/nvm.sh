#!/bin/bash

set -e

# Function to check if nvm is already installed
check_nvm_installed() {
    if [ -d "$HOME/.nvm" ]; then
        echo "nvm is already installed."
        return 0
    else
        return 1
    fi
}

# Function to install nvm
install_nvm() {
    echo "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

    echo "Setting up nvm environment..."
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

    echo "nvm installed successfully."
}

# Function to install the latest Node.js and npm
install_node() {
    echo "Installing the latest Node.js and npm..."
    nvm install node

    echo "Verifying the installation..."
    if command -v node &> /dev/null && command -v npm &> /dev/null; then
        echo "Node.js and npm installed successfully."
        node -v
        npm -v
    else
        echo "Node.js and npm installation failed."
        exit 1
    fi
}

# Main script
main() {
    # if ! check_nvm_installed; then
        install_nvm
    # fi

    install_node
}

main
