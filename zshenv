export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="/Users/gbrostedt1/Documents/bbg-bde/bde-tools/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"
export PATH="/usr/local/sbin:$PATH"

alias dev_proxy='http_proxy=http://bproxy.tdmz1.bloomberg.com:80 https_proxy=http://bproxy.tdmz1.bloomberg.com:80'
alias ext_proxy='http_proxy=http://proxy.bloomberg.com:77 https_proxy=http://proxy.bloomberg.com:77'
alias dev_proxy='http_proxy=http://bproxy.tdmz1.bloomberg.com:80 https_proxy=http://bproxy.tdmz1.bloomberg.com:80'
alias ext_proxy='http_proxy=http://proxy.bloomberg.com:77 https_proxy=http://proxy.bloomberg.com:77'

function setproxy() {
    export {http,https,ftp}_proxy='http://proxy.bloomberg.com:77'
}

function unsetproxy() {
    export {http,https,ftp}_proxy=
}
