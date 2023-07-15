docker_utils="$(dirname $0)/../docker-utils.sh"
if [ -f "$docker_utils" ]; then
  source $docker_utils
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
