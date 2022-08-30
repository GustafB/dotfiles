PATH="/usr/local/Cellar/gcc/11.2.0/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="/Users/gbrostedt1/Documents/bbg-bde/bde-tools/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
. "${NVM_DIR}/nvm.sh"
export PATH="/usr/local/sbin:$PATH"
export PATH="$PATH:/Users/gbrostedt1/workspace/mactoolkit/"
export PATH="$PATH:/Users/gbrostedt1/workspace/tkdcopyrun/"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
export no_proxy=localhost,127.*,[::1],repo.dev.bloomberg.com,artifactory.bdns.bloomberg.com,artprod.dev.bloomberg.com,blp-dpkg.dev.bloomberg.com

export dev_proxy='http_proxy=http://bproxy.tdmz1.bloomberg.com:85 https_proxy=http://bproxy.tdmz1.bloomberg.com:85'
export ext_proxy='http_proxy=http://proxy.bloomberg.com:77 https_proxy=http://proxy.bloomberg.com:77'

#export http_proxy=http://localhost:8888
#export https_proxy=http://localhost:8888

export PIPENV_PYPI_MIRROR=https://artprod.dev.bloomberg.com/artifactory/api/pypi/bloomberg-pypi/simple

alias unmount_mbig='diskutil unmount /users/gbrostedt1/Documents/bbg/mbig'

alias mount_mbig='sshfs devsftp:/bb/mbig/mbig7278/ /Users/gbrostedt1/Documents/bbg/mbig -oauto_cache,reconnect,defer_permissions,negative_vncache,volname=mybig,allow_other,loglevel=DEBUG3'

alias run_docker='docker run --rm -it -v $1 bash'

alias start_tinyproxy='launchctl load -w /usr/local/Cellar/tinyproxy/1.11.0/homebrew.mxcl.tinyproxy.plist'

alias stop_tinyproxy='launchctl unload -w /usr/local/Cellar/tinyproxy/1.11.0/homebrew.mxcl.tinyproxy.plist'

function setproxy() {
    export {http,https,ftp}_proxy='http://proxy.bloomberg.com:77'
}

function unsetproxy() {
    export {http,https,ftp}_proxy=''
}

function setlocalproxy() {
    export {http,https,ftp}_proxy=http://localhost:8888
}

function starttinyproxy() {
    setlocalproxy
    start_tinyproxy
}

function stoptinyproxy() {
    unsetproxy
    stop_tinyproxy
}

export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0
export GDK_SCALE=0.5
export GDK_DPI_SCALE=2

export PATH="/usr/local/opt/ruby/bin:$PATH"
