# ~/.bashrc: executed by bash(1) for interactive non-login shells.

# Personal customizations and optimizations

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History configuration
HISTCONTROL=ignoreboth  # Ignore duplicate commands and commands starting with space
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend    # Append to history file, don't overwrite

# Shell options
shopt -s checkwinsize  # Update window size after each command
shopt -s autocd        # Type directory name to cd into it
shopt -s cdspell       # Autocorrect minor typos in cd command

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Color aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Commonly used aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# System management aliases
alias update='sudo apt update && sudo apt upgrade -y'
alias clean='sudo apt autoremove && sudo apt autoclean'

# Safety aliases
alias rm='rm -I'  # Prompt before removing more than 3 files
alias cp='cp -i'  # Confirm before overwriting
alias mv='mv -i'  # Confirm before overwriting

# Networking aliases
alias ports='netstat -tuln'
alias myip='curl ifconfig.me'

# Development aliases
alias py='python3'
alias pip='pip3'

# Improved tab completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Custom functions

# Create and enter directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick process finder
psgrep() {
    ps aux | grep -v grep | grep "$1"
}

# Enable programmable completion features
complete -cf sudo

# Optional: Load local customizations
if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi
