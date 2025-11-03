#!/bin/zsh

# ============================== Core options ==============================
setopt BANG_HIST EXTENDED_HISTORY INC_APPEND_HISTORY SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS HIST_IGNORE_SPACE HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS HIST_VERIFY HIST_BEEP
setopt PUSHD_IGNORE_DUPS PUSHD_MINUS AUTO_CD EXTENDED_GLOB

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE

KEYTIMEOUT=1
WORDCHARS='*?_-[]~=./&;!#$%^(){}<>'

export LESS="-CQaix4"

# ============================== Completion ================================
autoload -Uz compinit
compinit -C                             # cached; skips security checks after first run

# completion quality & UI
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# git: prefer branches, then remotes, then tags
zstyle ':completion:*:*:git-(checkout|switch|merge|rebase|cherry-pick|reset):*' tag-order 'heads' 'remote-heads' 'tags'

# =============================== Prompt ===================================
eval "$(starship init zsh)"

# ================================ FZF =====================================
export FZF_DEFAULT_OPTS='--height 40% --reverse --border --inline-info --color=dark,bg+:235,hl+:10,pointer:5'
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

# =============================== Plugins ==================================
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} zinit…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" \
    && print -P "%F{34}Installation successful.%f" \
    || print -P "%F{160}The clone has failed.%f"
fi
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit; (( ${+_comps} )) && _comps[zinit]=_zinit

zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search

export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
zinit ice lucid wait"1"
zinit light lukechilds/zsh-nvm

# ============================== Environment ===============================
export DISPLAY=:0.0
export GDK_SCALE=0.5
export GDK_DPI_SCALE=2

if [[ $OSTYPE != darwin* ]]; then
  export XDG_RUNTIME_DIR="/run/user/$(id -u)/xdg_runtime_dir"
  [[ -d "$XDG_RUNTIME_DIR" ]] || mkdir -p "$XDG_RUNTIME_DIR"
fi

if [[ $OSTYPE = darwin* ]]; then
  [[ -x "$HOME/homebrew/bin/brew" ]] && eval "$($HOME/homebrew/bin/brew shellenv)"
  export PATH="$HOME/.local/nvim/nvim-macos-arm64/bin:$PATH"
fi

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

[[ -f "$HOME/priv/saporo_env" ]] && . "$HOME/priv/saporo_env"

# ============================== Functions =================================
timezsh() {
  local shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time -f "%e" "$shell" -i -c exit; done
}

# Grep processes (avoid matching grep itself)
pps() {
  ps aux | grep --color=auto -i "[${1[1]}]${1[2,-1]}"
}

# Git diff picker (space-safe)
gfd() {
  local preview='git diff --color=always -- {-1}'
  git diff --name-only -z "$@" | tr -d '\n' | tr '\0' '\n' | fzf -m --ansi --preview "$preview"
}

# Current git branch in prompt (if you use it)
parse_git_branch() {
  git branch 2>/dev/null | sed -n 's/^\* \(.*\)$/ (\1)/p'
}

# Docker helpers
dsql() { docker exec "$(docker ps -q -f "name=psql")" psql -U postgres main -c "${1}"; }
isql() { docker exec -it "$(docker ps -q -f "name=psql")" psql -U postgres main; }
mg()   { docker exec -it "$(docker ps -q -f "name=mg")" mgconsole --term-colors=true; }

# Tmux sessionizer (preserve prompt buffer)
tmux_sessionizer() {
  local selected
  selected=$(find ~/saporo ~/install/dotfiles ~/code ~/tmp ~/notes -mindepth 1 -maxdepth 1 -type d | fzf)
  [[ -n $selected ]] && ~/bin/tmux-sessionizer "$selected"
}
tmux_sessionizer_widget() {
  local saved_buffer="$BUFFER" saved_cursor="$CURSOR"
  zle clear-screen
  tmux_sessionizer
  zle reset-prompt
  BUFFER="$saved_buffer"
  CURSOR="$saved_cursor"
}
zle -N tmux_sessionizer_widget
bindkey '^G' tmux_sessionizer_widget

# zshaddhistory: skip commands that aren't found in PATH (keeps output clean)
zshaddhistory() { whence ${${(z)1}[1]} >| /dev/null || return 1 }

# ================================ Aliases =================================
# Pager/cat
if command -v batcat >/dev/null 2>&1; then
  alias cat='batcat'
  alias cap='batcat --plain'
elif command -v bat >/dev/null 2>&1; then
  alias cat='bat --plain'
fi

# eza (single source of truth)
alias ls="eza --icons --group-directories-first"
alias ll="eza --icons --group-directories-first -l"
alias la='ls -a'
alias lal='ls -al'

# Editors
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# Grep family (simple, consistent)
alias grep='rg --color=auto'
alias egrep='rg -E --color=auto'
alias fgrep='rg -F --color=auto'

# Safer rm
alias rm='rm -iv'

# Misc
alias c='clear'
alias cl='clear; ll'
alias cla='clear; lal'
alias d='dirs -v'
alias ..='cd ..'; alias ..2='cd ../..'; alias ..3='cd ../../..'
alias ..4='cd ../../../..'; alias ..5='cd ../../../../..'
alias ..6='cd ../../../../../..'; alias ..7='cd ../../../../../../..'
alias win='explorer.exe .'
alias act='source ./.venv/bin/activate'
alias glog='git log --oneline'
alias grv='git remote -v'
alias gog="git log  --abbrev-commit --name-status --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias gml="git log --stat --color --decorate --all --oneline"
alias ggr="git log --graph --full-history --all --pretty=format:\"%h%x09%d%x20%s\""
alias gdw='git diff --word-diff=color'
alias gds='git diff --word-diff=color --staged'
alias gs='git status'
alias gu='git add -u'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push origin $(git rev-parse --abbrev-ref HEAD)'

# Git convenience + completions for aliases
alias gco='git checkout'
alias gsw='git switch'

# Housekeeping
alias cdir='find . \( -name "*.o" -or -name "*.so" \) -exec rm {} \;'

# ============================= Local includes =============================
[ -d "$HOME/bin" ] && path=($HOME/bin $path)
[[ -f "$HOME/.zsh_functions" ]] && source "$HOME/.zsh_functions"
[[ -f "$HOME/.zsh_rclocal"   ]] && source "$HOME/.zsh_rclocal"
[[ -f "$HOME/.zsh_exports"   ]] && source "$HOME/.zsh_exports"
[[ -f "$HOME/.zsh_aliases"   ]] && source "$HOME/.zsh_aliases"

# Emacs shell integration (if applicable)
if [[ -n "$INSIDE_EMACS" ]]; then
  chpwd() { print -P "\033AnSiTc %d" }
  print -P "\033AnSiTu %n"
  print -P "\033AnSiTc %d"
fi

