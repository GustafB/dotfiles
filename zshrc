#!/bin/zsh

export TERM="xterm-256color"
# =============================================================================
#                                   Functions
# =============================================================================
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

si()
{
    user="gustaf"
    pem="/home/cafebabe/.ssh/gustaf_dev.pem"
    choice=$(tailscale status --json | jq -r '.Peer[] | .HostName' | fzf --preview 'tailscale status --json | jq -r \".Peer[] | select(.HostName == \"{}\") | .\"')
    echo "$pem $user@$choice"
    ssh -i $pem $user@$choice
}

dev() {
    user="gustaf"
    pem="/home/cafebabe/.ssh/$user.pem"
    choice=$(tailscale status --json | jq -r '.Peer[] | .HostName' | fzf --preview "tailscale status --json | jq -r '.Peer[] | select(.HostName == \"{}\") | .'")
    echo "$choice"
    echo "$pem" "$user@$choice.saporo.net"
    ssh -i "$pem" "$user@$choice.saporo.net"
}

# Greps process list for some string
pps()
{
    ps aux | grep --color=auto "$@" | grep -v 'grep';
}

gfd() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}

# Returns the current git branch
parse_git_branch()
{
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

mygrep()
{
    $(which -p grep) --color=auto "$@"
}

myegrep()
{
    $(which -p egrep) --color=auto "$@"
}


# =============================================================================
#                                   Variables
# =============================================================================
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export FZF_DEFAULT_OPTS='--height 40% --reverse --border --inline-info --color=dark,bg+:235,hl+:10,pointer:5'

export ENHANCD_FILTER="fzf:peco:percol"
export ENHANCD_COMMAND='c'
export EDITOR="emacs -nw"
export VISUAL="emacs -nw"

if [ -n "$INSIDE_EMACS" ]; then
  chpwd() { print -P "\033AnSiTc %d" }
  print -P "\033AnSiTu %n"
  print -P "\033AnSiTc %d"
fi

# =============================================================================
#                                   Options
# =============================================================================

# improved less option
#export LESS="--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS"
export LESS="-CQaix4"

# Watching other users
#WATCHFMT="%n %a %l from %m at %t."
watch=(notme)         # Report login/logout events for everybody except ourself.
LOGCHECK=60           # Time (seconds) between checks for login/logout activity.
REPORTTIME=5          # Display usage statistics for commands running > 5 sec.

# Key timeout and character sequences
KEYTIMEOUT=1
WORDCHARS='*?_-[]~=./&;!#$%^(){}<>'

# History
export HISTFILE="/home/cafebabe/.zsh_history"
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
export HISTIGNORE="pwd:ls:cd"
alias hist="history 1"
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.



bindkey "^R" history-incremental-search-backward

# Changing directories
#setopt auto_pushd
setopt pushd_ignore_dups        # Dont push copies of the same dir on stack.
setopt pushd_minus              # Reference stack entries with "-".
setopt autocd                   # Allow changing directories without `cd`

setopt extended_glob
CASE_SENSITIVE="true"

# =============================================================================
#                                   Aliases
# =============================================================================

# In the definitions below, you will see use of function definitions instead of
# aliases for some cases. We use this method to avoid expansion of the alias in
# combination with the globalias plugin.

# Directory coloring
if [[ $OSTYPE = (darwin|freebsd)* ]]; then
	export CLICOLOR="YES" # Equivalent to passing -G to ls.
	export LSCOLORS="exgxdHdHcxaHaHhBhDeaec"

	[ -d "/opt/local/bin" ] && export PATH="/opt/local/bin:$PATH"

	# Prefer GNU version, since it respects dircolors.
	if (( $+commands[gls] )); then
		alias ls='() { $(whence -p gls) -Ctr --file-type --color=auto $@ }'
	else
		alias ls='() { $(whence -p ls) -CFtr $@ }'
	fi
else
	alias ls='() { $(whence -p ls) -Ctr --file-type --color=auto $@ }'
fi

# Set editor preference to nvim if available.
if (( $+commands[nvim] )); then
	alias vim='() { $(whence -p nvim) $@ }'
else
	alias vim='() { $(whence -p vim) $@ }'
fi

# Generic command adaptations
alias grep='() { $(whence -p grep) --color=auto $@ }'
alias egrep='() { $(whence -p egrep) --color=auto $@ }'

# Custom helper aliases
alias ccat='highlight -O ansi'
alias rm='rm -v'
alias cat='batcat $@'

# Directory management
alias ls="eza --icons --group-directories-first"
alias ll="eza --icons --group-directories-first -l"
alias la='ls -a'
alias lal='ls -al'
alias d='dirs -v'
alias 1='pu'
alias 2='pu -2'
alias 3='pu -3'
alias 4='pu -4'
alias 5='pu -5'
alias 6='pu -6'
alias 7='pu -7'
alias 8='pu -8'
alias 9='pu -9'
alias pu='() { pushd $1 &> /dev/null; dirs -v; }'
alias po='() { popd &> /dev/null; dirs -v; }'

# Housekeeping
alias cdir='find . \( -name "*.o" -or -name "*.so" \) -exec rm {} \;'

zshaddhistory() { whence ${${(z)1}[1]} >| /dev/null || return 1 }

[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"

# Source defined functions.
[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions

# Source local customizations.
[[ -f ~/.zsh_rclocal ]] && source ~/.zsh_rclocal

# Source exports and aliases.
[[ -f ~/.zsh_exports ]] && source ~/.zsh_exports
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Git commands
alias glog='git log --oneline'
alias grv='git remote -v'
alias gpcb='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias gog="git log  --abbrev-commit --name-status --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias gml="git log --stat --color --decorate --all --oneline"
alias gdw="git diff --word-diff=color"
alias gds="git diff --word-diff=color --staged"
alias gs="git status"
alias gau="git add -u"
alias gaa="git add ."
alias gc="git commit"
alias ggr="git log --graph --full-history --all --pretty=format:\"%h%x09%d%x20%s\""

# Navigation
alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'
alias ..6='cd ../../../../../..'
alias ..7='cd ../../../../../../..'
alias win='explorer.exe .'

# Generic command adaptions
alias ll="ls -lh"
alias lal="ls -lha"
alias la="ls -a"
alias rm="rm -iv"
alias c="clear"
alias cl="clear; ll"
alias cla="clear; lal"
alias grepdir="find . -type f -print0 | xargs -0 grep -nHi --color=auto"
alias grep="mygrep $@"
alias egrep="myegrep $@"

# Housekeeping
alias cdir='find . \( -name "*.o" -or -name "*.so" \) -exec rm {} \;'
alias klast="kill %1"
alias dk="kill -9 $(docker ps -q)"

alias ccat="source-highlight --out-format=esc256 -o STDOUT -i"

# sql
dsql() {
    docker exec $(docker ps -q -f "name=psql") psql -U postgres main -c "${1}"
}

isql() {
    docker exec -it $(docker ps -q -f "name=psql") psql -U postgres main
}

mg() {
    docker exec -it $(docker ps -q -f "name=mg") mgconsole
}

# start app
alias eg="setsid emacs &"

export PATH="${PATH}:/home/cafebabe/.cargo/bin"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi


source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
# zinit light-mode for \
#     zdharma-continuum/zinit-annex-as-monitor \
#     zdharma-continuum/zinit-annex-bin-gem-node \
#     zdharma-continuum/zinit-annex-patch-dl \
#     zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
# zsh-fzf-history-search
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search
plugins=(… zsh-fzf-history-search docker)

# # check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
else
    source ~/.zplug/init.zsh
fi

# # Self-manage
zplug "zplug/zplug", hook-build:"zplug --self-manage"

zplug check || zplug install
zplug clean --force

# Initialize plugins
zplug "woefe/wbase.zsh"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "so-fancy/diff-so-fancy", as:command, use:bin/git-dsf
zplug load

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure


