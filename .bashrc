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

# Slate-themed bash prompt with system information

# Color definitions (slate-inspired palette)
SLATE_GRAY='\[\033[38;5;246m\]'
SLATE_BLUE='\[\033[38;5;67m\]'
SLATE_DARK='\[\033[38;5;240m\]'
SLATE_LIGHT='\[\033[38;5;252m\]'
BATTERY_GREEN='\[\033[38;5;40m\]'
ATTERY_YELLOW='\[\033[38;5;220m\]'
BATTERY_RED='\[\033[38;5;196m\]'
RESET='\[\033[0m\]'

# Function to get Git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Function to get battery percentage
get_battery_status() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        BATTERY_PCT=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux (works on most systems)
        BATTERY_PCT=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null)
    else
        BATTERY_PCT=""
    fi

    if [[ -n "$BATTERY_PCT" ]]; then
        # Color code battery percentage
        if [[ $BATTERY_PCT -gt 50 ]]; then
            BATTERY_COLOR=$BATTERY_GREEN
        elif [[ $BATTERY_PCT -gt 20 ]]; then
            BATTERY_COLOR=$BATTERY_YELLOW
        else
            BATTERY_COLOR=$BATTERY_RED
        fi
        echo -e "$BATTERY_COLOR[$BATTERY_PCT%]$RESET"
    fi
}

# Prompt construction
PS1="${SLATE_DARK}[${SLATE_BLUE}\u${SLATE_DARK}@${SLATE_BLUE}\h${SLATE_DARK}]" # User and Host
PS1+=" ${SLATE_GRAY}\D{%Y-%m-%d %H:%M}${RESET}" # Date and Time
PS1+=" ${SLATE_LIGHT}\w${SLATE_BLUE}\$(parse_git_branch)${RESET}" # Current Directory and Git Branch
PS1+=" \$(get_battery_status)" # Battery Status
PS1+="\n$ " # New line with prompt symbol

export PS1

export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# Optional: Load local customizations
if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi

manaslab-update() {
    cp /home/manas/.bashrc /home/manas/manaslab/.bashrc
    cp /home/manas/.config/nvim/init.vim /home/manas/manaslab/init.vim
    cp /home/manas/.config/nvim/spell/en.utf-8.add /home/manas/manaslab/en.utf-8.add
    cp /home/manas/.config/nvim/snippets/go.snippets /home/manas/manaslab/go.snippets
    cd /home/manas/manaslab && git add . && git commit && git push && cd -
}
