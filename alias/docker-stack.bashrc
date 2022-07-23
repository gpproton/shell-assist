## Docker stack aliases
source ~/.bashrc.d/docker-shared.bashrc

function dsd-fn() {
  unset ddir
  unset n-get-file
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

function dsrm-fn() {
  fn-get-file $1
  docker stack rm $stack
}

function dsps-fn() {
  fn-get-file $1
  docker stack ps $stack
}

function dss-fn() {
  fn-get-file $1
  docker stack services $stack
}

alias dsd=dsd-fn
alias dsrm=dsrm-fn
alias dsps=dsps-fn
alias dss=dss-fn
alias dsls='docker stack ls'
alias dslog="docker service logs -f $*"
