#!/bin/bash
## Docker command aliases

alias dim="docker images"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dsp="docker system prune --all"
alias dpull='docker pull'

function dnames {
  for ID in $(docker ps | awk '{print $1}' | grep -v 'CONTAINER'); do
    docker inspect $ID | grep Name | head -1 | awk '{print $2}' | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
  done
}

function dip {
  echo "IP addresses of all named running containers"
  for DOC in $(dnames); do
    IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "$DOC")
    OUT+=$DOC'\t'$IP'\n'
  done
  echo -e $OUT | column -t
  unset OUT
}

function dexec {
  docker exec -it $1 ${2:-bash}
}

function di {
  docker inspect $1
}

function dl {
  docker logs -f $1
}

function drun {
  docker run -it $1 $2
}

function dstp {
  docker stop $1
  docker rm $1
}

function drmc {
  docker rm $(docker ps --all -q -f status=exited)
}

function drmid {
  imgs=$(docker images -q -f dangling=true)
  [ ! -z "$imgs" ] && docker rmi "$imgs" || echo "no dangling images."
}

function dprune() {
  docker rm -f $(docker ps -q) &&
    docker rmi $(docker images -q) &&
    echo y | docker system prunealias dim="docker images"
  alias dps="docker ps"
  alias dpsa="docker ps -a"
  alias dsp="docker system prune --all"
  alias dpull='docker pull'
}
