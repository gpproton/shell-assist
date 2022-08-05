## System command aliases

## shortcut  for iptables and pass it via sudo#
alias ipt='sudo /sbin/iptables'

# display all rules #
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist

## pass options to free ##
alias mem='free -m -l -t'
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
## Get server cpu info ##
alias cpu='lscpu'
## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##
## get GPU ram on desktop / laptop##
alias gpumem='grep -i --color memory /var/log/Xorg.0.log'

## set some other defaults ##
alias df='df -H'
alias du='du -ch'

# top is atop, just like vi is vim
alias top='atop'

# if user is not root, pass all commands via sudo #
if [ $UID -ne 0 ]; then
  # reboot / halt / poweroff
  alias reboot='sudo /sbin/reboot'
  alias poweroff='sudo /sbin/poweroff'
  alias halt='sudo /sbin/halt'
  alias shutdown='sudo /sbin/shutdown'
  ## distrp specifc RHEL/CentOS ##
  alias update='sudo dnf update'
  alias updatey='sudo dnf -y update'
  alias upgrade='sudo dnf upgrade'
  alias upgradey='sudo dnf -y upgrade'
  # become root #
  alias root='sudo -i'
  alias su='sudo -i'
fi

function basic-auth {
  echo $(htpasswd -nb $1 $2)
}

function basic-authi {
  echo $(htpasswd -iB $1 $2)
}
