export TERM="xterm-256color"
# =============================================================================
#                                   Functions
# =============================================================================
powerlevel9k_random_color(){
	local code
	#for code ({000..255}) echo -n "$%F{$code}"
	#code=$[${RANDOM}%11+10]    # random between 10-20
	code=$[${RANDOM}%211+20]    # random between 20-230
	printf "%03d" $code
}

# Greps process list for some string
pps()
{
    ps aux | grep --color=auto "$@" | grep -v 'grep';
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

_ssh()
{
    ARCH=$1
    MACH=$2
    echo $MACH
    dev "${ARCH}${MACH}"
}

ssh_sd()
{
    _ssh "sundev" $1
}

ssh_lx()
{
    _ssh "nylxdev" $1
}

# =============================================================================
#                                   Variables
# =============================================================================
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export FZF_DEFAULT_OPTS='--height 40% --reverse --border --inline-info --color=dark,bg+:235,hl+:10,pointer:5'

export ENHANCD_FILTER="fzf:peco:percol"
export ENHANCD_COMMAND='c'
export EDITOR="emacs -nw -q"
export VISUAL="emacs -nw -q"

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
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

setopt autocd                   # Allow changing directories without `cd`
setopt append_history           # Dont overwrite history
setopt extended_history         # Also record time and duration of commands.
setopt share_history            # Share history between multiple shells
setopt hist_expire_dups_first   # Clear duplicates when trimming internal hist.
setopt hist_find_no_dups        # Dont display duplicates during searches.
setopt hist_ignore_dups         # Ignore consecutive duplicates.
setopt hist_ignore_all_dups     # Remember only one unique copy of the command.
setopt hist_reduce_blanks       # Remove superfluous blanks.
setopt hist_save_no_dups        # Omit older commands in favor of newer ones.
setopt hist_ignore_space        # Ignore commands that start with space.

# Changing directories
#setopt auto_pushd
setopt pushd_ignore_dups        # Dont push copies of the same dir on stack.
setopt pushd_minus              # Reference stack entries with "-".

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

# Directory management
alias la='ls -a'
alias ll='ls -l'
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

# Navigation
alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'
alias ..6='cd ../../../../../..'
alias ..7='cd ../../../../../../..'

# Networking
alias sd="ssh_sd $1"
alias lin="ssh_lx $1"

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

alias ccat="source-highlight --out-format=esc256 -o STDOUT -i"
export VAGRANT_DISABLE_RESOLV_REPLACE=1
export PATH="/usr/local/opt/ruby/bin:$PATH"

autoload -U promptinit; promptinit
prompt pure
export PATH="/usr/local/opt/python@3.8/bin:$PATH"
export PATH="/Users/gbrostedt1/Library/Python/3.8/bin:$PATH"
