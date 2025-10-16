typeset -U path fpath

path=(
  $HOME/.local/bin
  /usr/local/sbin
  /usr/local/opt/ruby/bin
  /usr/local/go/bin
  $HOME/go/bin
  $HOME/.cargo/bin
  $HOME/.npm/bin
  /opt/nvim-linux-x86_64/bin
  /snap/bin
  /usr/bin
  $path
  /mnt/c/windows
  /mnt/c/windows/system32/openssh
  $HOME/install/zig-linux-x86_64-0.15.0-dev.56+d0911786c
)

[[ -n $PYENV_ROOT ]] && path=($PYENV_ROOT/bin $path)

fpath=($HOME/installs/eza/completions/zsh $fpath)

export PATH=${path:|:}
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export TERM="xterm-256color"
