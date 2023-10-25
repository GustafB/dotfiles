#export NVM_DIR="$HOME/.nvm"
#. "${NVM_DIR}/nvm.sh"
export PATH="/usr/local/sbin:$PATH"
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0
export GDK_SCALE=0.5
export GDK_DPI_SCALE=2
export PYENV_ROOT="$HOME/.pyenv"

export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="/home/cafebabe/go/bin:$PATH"
export PATH="/snap/bin:$PATH"
export PATH="/home/cafebabe/.cargo/bin/navi:$PATH"
export PATH="$PYENV_ROOT/bin:$PATH"
. "$HOME/.cargo/env"
