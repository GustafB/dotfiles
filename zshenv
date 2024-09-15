#!/bin/bash

export NVM_DIR="$HOME/.nvm"
. "${NVM_DIR}/nvm.sh"

export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/bin:$PATH"
export PATH="$HOME/.npm/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="/snap/bin:$PATH"
export PATH="/home/cafebabe/.cargo/bin/navi:$PATH"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$PATH:/opt/nvim-linux64/bin"
export FPATH="$HOME/installs/eza/completions/zsh:$FPATH"

# export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0
export DISPLAY=:0.0

export GDK_SCALE=0.5

export GDK_DPI_SCALE=2

export PYENV_ROOT="$HOME/.pyenv"

export ZPLUG_HOME=$HOME/.zplug

. "$HOME/.cargo/env"

if [[ -f "$HOME/.saporo_env" ]]; then
  . "$HOME/.saporo_env"
fi

