#!/bin/bash

#export NVM_DIR="$HOME/.nvm"
#. "${NVM_DIR}/nvm.sh"

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
export PATH="$PATH:/mnt/c/windows"
export PATH="$PATH:/mnt/c/windows/system32/openssh"
export PATH=$PATH:~/install/zig-linux-x86_64-0.15.0-dev.56+d0911786c
export FPATH="$HOME/installs/eza/completions/zsh:$FPATH"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0
export DISPLAY=:0.0

export GDK_SCALE=0.5

export GDK_DPI_SCALE=2

export PYENV_ROOT="$HOME/.pyenv"

export ZPLUG_HOME="$HOME/.zplug"

export XDG_RUNTIME_DIR="/run/user/$(id -u)/xdg_runtime_dir"

# . "$HOME/.cargo/env"

if [[ -f "$HOME/.saporo_env" ]]; then
  . "$HOME/.saporo_env"
fi

if [ ! -d "/run/user/1000/xdg_runtime_dir" ]; then 
    mkdir "/run/user/1000/xdg_runtime_dir"
fi

#export GOTCH_LIBTORCH="/usr/local/lib/libtorch"
#export LIBRARY_PATH="$LIBRARY_PATH:$GOTCH_LIBTORCH/lib"
#export CPATH="$CPATH:$GOTCH_LIBTORCH/lib:$GOTCH_LIBTORCH/include:$GOTCH_LIBTORCH/include/torch/csrc/api/include"
#LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$GOTCH_LIBTORCH/lib:/usr/lib64-nvidia:/usr/local/cuda-${CUDA_VERSION}/lib64"

