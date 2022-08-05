alias gst='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gp='git push'
alias gpm='git push origin master'
alias gd='git diff'
alias gout='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'
function gco {
    git commit -m "$(echo "$*" | sed -e 's/^./\U&\E/g')"
}
