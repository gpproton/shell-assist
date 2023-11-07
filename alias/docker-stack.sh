# source "$(dirname $0)/../util/docker-utils.sh"
function dsd() {
  stack=${2:-${PWD##*/}}
  compose_file=${1:-docker-compose.yaml}
  docker stack deploy -c <(echo -e "version: '3.9'"; docker compose -f "$compose_file" config | (sed "/published:/s/\"//g") | (sed "/^name:/d")) "$stack"
  unset compose_file stack_name
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
