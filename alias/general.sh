## General command aliases

alias c='clear'
alias ls='ls --color=auto'
alias ll='ls -la'
alias cls='clear;ls'
## Show hidden files ##
alias l.='ls -d .* --color=auto'
## get rid of command not found ##
alias cd..='cd ..'
## a quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

## Create directory and move into it.
function mcd() {
  mkdir -p $1
  cd $1
}
## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Force remove files and directories
alias rmf='rm -rf'
# Clear build files for some dev envs
function rmdev() {
  dev_build_dirs=(build bin venv env dist .quasar .output .next .nuxt node_modules .composer)
  for dir in "${dev_build_dirs[@]}"; do
    echo "Trying deletion for $dir/*"
    if (rm -rf ./**/$dir/ &>/dev/null); then
      echo "Deletion for $dir/* successfully completed"
    fi
  done
  unset dev_build_dirs
}
# do not delete / or prompt if deleting more than 3 files at a time #
alias rm='rm -I --preserve-root'

# confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'

# Parenting changing perms on / #
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

alias bc='bc -l'
alias sha1='openssl sha1'
alias sha1='openssl sha1'
# install  colordiff package :)
alias diff='colordiff'
alias h='history'
alias j='jobs -l'

alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

# Stop after sending count ECHO_REQUEST packets #
alias ping='ping -c 5'
# Do not wait interval 1 second, go fast #
alias fastping='ping -c 100 -s.2'
# alias ports='netstat -tulanp'
alias ports='netstat -tulanp'

alias wget='wget -c'

export DEV_BOX="$HOME/personal"
export SANDBOX="$HOME/sandbox"

mkdir -p "$HOME/sandbox/"
mkdir -p "$HOME/personal/"

alias dev="cd $DEV_BOX"
alias box="cd $DEV_BOX"
alias sand="cd $SANDBOX"
alias sandbox="cd $SANDBOX"
alias media="cd $HOME/media/"
