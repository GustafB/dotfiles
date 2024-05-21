#!/bin/bash

set -e

# Check if Clang 17 is already installed
if command -v clang-17 &> /dev/null && command -v clang++-17 &> /dev/null; then
    echo "Clang 17 is already installed."
    exit 0
fi

# Update and upgrade the package list
apt update && apt upgrade -y

# Install Clang 17 using the official LLVM script
wget -O - https://apt.llvm.org/llvm.sh | bash

# Create symbolic links for clang and clang++
rm -f /usr/bin/clang /usr/bin/clang++
ln -sf /usr/bin/clang-17 /usr/bin/clang
ln -sf /usr/bin/clang++-17 /usr/bin/clang++

# Verify installation
if command -v clang-17 &> /dev/null && command -v clang++-17 &> /dev/null; then
    echo "Clang 17 installation completed successfully."
else
    echo "Clang 17 installation failed."
    exit 1
fi
