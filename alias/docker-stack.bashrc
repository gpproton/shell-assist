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
    ## Alternate method
    # docker stack deploy --prune --env-file $env_file \
    # --compose-file <(docker-compose --file $compose_file config) $stack
  )
}

function dsrm() {
  fn-get-file $1
  docker stack rm $stack
}

function dsps() {
  fn-get-file $1
  docker stack ps $stack
}

function dss() {
  fn-get-file $1
  docker stack services $stack
}

alias dsls='docker stack ls'
alias dslog="docker service logs -f $*"
