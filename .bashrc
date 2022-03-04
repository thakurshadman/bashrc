#!/bin/bash

# if not running interactively, dont do anything
[[ "$-" != *i* ]] && return

# echo
echo '~/.bashrc has run'

# Set up command prompt
if [[ -f ~/.bash/git-prompt.sh ]]; then
    source ~/.bash/git-prompt.sh # Show git branch name at command prompt
    export GIT_PS1_SHOWCOLORHINTS=true # Option for git-prompt.sh to show branch name in color
    echo 'sourced ~/.bash/git-prompt.sh'
fi
PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\] \[\e[36m\]$(__git_ps1)\[\e[0m\]\n\$ '

# ignore some pattern in history
export HISTIGNORE=$'[ \t]*:&:fg:bg:exit:clear:clc:ls'
export HISTCONTROL=ignoredups:erasedups

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# the pattern "**" used in a pathname expansion context will match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
if [[ -x /usr/bin/lesspipe ]]; then
    eval "$(SHELL=/bin/sh lesspipe)"
fi

# use arrow keys to search history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# tab completion
shopt -s no_empty_cmd_completion            # dont complete empty input
bind 'set completion-ignore-case on'        # case insensitive completion
bind 'set show-all-if-ambiguous on'         # one tab to complete ambiguous
bind 'set colored-completion-prefix on'     # show partial match in color
bind 'set colored-stats on'                 # colored completion
bind 'set visible-stats on'                 # symbols on completion
bind 'set completion-map-case on'           # '-' and '_' are equivalent
bind 'set mark-symlinked-directories on'    # add '/' to symlink directory completion
bind 'set skip-completed-text on'           # if completing on middle of word try to match end as well

# no bell
bind 'set bell-style none'

# blink opening paranthesis when closing paranthesis is inserted
bind 'set blink-matching-paren on'

# reload .bashrc
alias loadrc='source ~/.bashrc'

# append my bin/ to PATH
PATH="~/.bin:$PATH"
[[ -f ~/.bin/completions.sh ]] && source ~/.bin/completions.sh

# display ls and tree etc with colors and symbols
if [[ -f ~/.dircolors ]]; then
    eval "$(dircolors ~/.dircolors)"
fi
alias ls='ls -hF --color=tty'
alias tree='tree -CFl'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# clear screen and scroll buffer
alias clc="clear; printf '\033[3J'"

# make parallel
alias make="make -j"

# grant execute privledge to all users
alias gx='chmod a+x'

# Pythonstuff
if [[ $(command -v python3.7) ]]; then
    alias py="python3.7"
fi
if [[ $(command -v python3.7) ]]; then
    alias pyt="pytest3.7"
fi

# Git stuff
alias gits='git status'

gitp() {
    # (push) add, commit and push everything with provided message
    local branch_name=$(git branch | grep \* | cut -d ' ' -f2)
    local message="$1"
    shift

    git add "$@"
    if [[ -z $message ]]; then
        git commit
    else
        git commit -m "$message"
    fi

    git push -u origin $branch_name
}

gitdb() {
    # (delete branch) delete current local and remote branch
    local branch_name
    if [[ -z $1 ]]; then
        branch_name=$(git branch | grep \* | cut -d ' ' -f2)
    else
        branch_name=$1
    fi
    git checkout master &&
    git pull upstream master &&
    git branch -d $branch_name &&
    git push origin --delete $branch_name
}
complete -W '$(git branch | tr -d '\'' *'\'')' gitdb

gitb() {
    # (branch) make new tracking branch
    local branch_name=$1
    git checkout -b $branch_name
    git push -u origin $branch_name 
}
complete -W '' gitb

# Getopts example
my_getopts () {
    local opt
    local OPTARG
    local OPTIND
    while getopts ":h:tb" opt; do
        case ${opt} in 
            h)
                echo h with value $OPTARG
                ;;
            t)
                echo t
                ;;
            b)
                echo b
                ;;
            \?)
                echo def
                ;;
        esac
    done
    shift $((OPTIND-1));
    echo ARGS are "$@"
}

###############################################################################################
#####################################     Home Stuff     ######################################
###############################################################################################
win='/mnt/c/Users/Shadman'


clear

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
##############################       FLUTTER      #################################################
###################################################################################################
export PATH="$PATH:/home/shadman/flutter/bin"

