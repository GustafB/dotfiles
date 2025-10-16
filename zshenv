#!/bin/bash

export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/bin:$PATH"
export PATH="$HOME/.npm/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="/snap/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$PATH:/mnt/c/windows"
export PATH="$PATH:/mnt/c/windows/system32/openssh"
export PATH=$PATH:~/install/zig-linux-x86_64-0.15.0-dev.56+d0911786c
export FPATH="$HOME/installs/eza/completions/zsh:$FPATH"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

export DISPLAY=:0.0
export GDK_SCALE=0.5
export GDK_DPI_SCALE=2
export ZPLUG_HOME="$HOME/.zplug"
export XDG_RUNTIME_DIR="/run/user/$(id -u)/xdg_runtime_dir"

if [[ -f "$HOME/priv/.saporo_env" ]]; then
  . "$HOME/priv/.saporo_env"
fi

if [[ ! $OSTYPE = darwin* ]]; then
    if [ ! -d "/run/user/1000/xdg_runtime_dir" ]; then 
        mkdir "/run/user/1000/xdg_runtime_dir"
    fi
fi

if [[ $OSTYPE = darwin* ]]; then
    eval "$($HOME/homebrew/bin/brew shellenv)"
    export PATH="$HOME/.local/nvim/nvim-macos-arm64/bin:$PATH"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

. "$HOME/.cargo/env"
