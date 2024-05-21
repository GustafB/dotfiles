#!/bin/bash

set -e

if [ ! -d ~/powerlevel9k/ ]; then
    git clone "https://github.com/bhilburn/powerlevel9k.git"  ~/.oh-my-zsh/custom/themes/powerlevel9k
    echo "Cloned Powerlevel"
fi

if [ ! -d ~/.oh-my-zsh/ ]; then
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo "Installed oh-my-zsh"
fi
