if [ -f "$(dirname $0)/_docker.bashrc" ]; then
  source "$(dirname $0)/_docker.bashrc"
fi

function dsd() {
  unset ddir
  ddir=${2:-${PWD##*/}}
  fn-get-file $ddir $1
  (
    [ -f $env_file ] && export $(sed '/^#/d' $env_file)
    docker stack deploy --prune --compose-file $compose_file $stack
  )
}

alias dsrm="docker stack rm"
alias dsps="docker stack ps"
alias dsls="docker stack ls"
alias dss="docker service"
alias dssls="dss ls"
alias dsslog="dss logs -f"
alias dssi="dss inspect"
alias dssps="dss ps"
alias dssrm="dss rm"
