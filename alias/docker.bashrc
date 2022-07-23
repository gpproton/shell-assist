## Docker command aliases

function dnames-fn {
  for ID in $(docker ps | awk '{print $1}' | grep -v 'CONTAINER'); do
    docker inspect $ID | grep Name | head -1 | awk '{print $2}' | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
  done
}

function dip-fn {
  echo "IP addresses of all named running containers"
  for DOC in $(dnames-fn); do
    IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "$DOC")
    OUT+=$DOC'\t'$IP'\n'
  done
  echo -e $OUT | column -t
  unset OUT
}

function dexec-fn {
  docker exec -it $1 ${2:-bash}
}

function di-fn {
  docker inspect $1
}

function dl-fn {
  docker logs -f $1
}

function drun-fn {
  docker run -it $1 $2
}

function dstp-fn {
  docker stop $1
  docker rm $1
}

function drmc-fn {
  docker rm $(docker ps --all -q -f status=exited)
}

function drmid-fn {
  imgs=$(docker images -q -f dangling=true)
  [ ! -z "$imgs" ] && docker rmi "$imgs" || echo "no dangling images."
}

alias dexec=dexec-fn
alias di=di-fn
alias dim="docker images"
alias dip=dip-fn
alias dl=dl-fn
alias dnames=dnames-fn
alias dps="docker ps"
alias dpsa="docker ps -a"
alias drmc=drmc-fn
alias drmid=drmid-fn
alias drun=drun-fn
alias dsp="docker system prune --all"
alias dstp=dstp-fn
alias dpull='docker pull'
