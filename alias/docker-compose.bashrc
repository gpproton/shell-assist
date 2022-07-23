## Docker compose aliases
source ~/.bashrc.d/docker-shared.bashrc

function help-info() {
  echo ""
  echo "Usage: $0 -f parameterA -n parameterB"
  echo -e "\t-f Specify an alternate compose file"
  echo -e "\t-n Specify an alternate project name"
  exit 1 # Exit script
}
## Directory!!!
function get-params() {
  ## Clear existing variables
  unset arg_file_name arg_proj_name arg_proj_path
  unset proj_path project_name
  project_name=${PWD##*/}
  while getopts "f:p:d:" opt; do
    case "${opt}" in
    f) arg_file_name="$OPTARG" ;;
    p) arg_proj_name="$OPTARG" ;;
    d) arg_proj_path="$OPTARG" ;;
    ?) help-info ;; # Print help
    esac
  done
  ## Get compose_file, stack, proj_path and env_file
  arg_proj_name=${arg_proj_name:-$project_name}
  fn-get-file $arg_proj_name $arg_file_name
  proj_path="$arg_proj_path"
  if [ ! -d "$proj_path" ]; then
    proj_path=${PWD}
  fi

  unset args opts cur_opt
  for a; do
    if [[ $a == [-]* ]]; then
      opts+=("$a")
      cur_opt="$a"
    elif [[ -z "$cur_opt" ]]; then
      args+=("$a")
      unset cur_opt
    else
      opts+=("$a")
      unset cur_opt
    fi
  done
}

function get-root-fn {
  get-params $*
  unset doc cmd_options full_options

  doc="docker-compose"
  cmd_options="--project-name $stack --file $proj_path/$compose_file --env-file $proj_path/$env_file --project-directory $proj_path"
  full_options="$cmd_options $args"
}

function dc-fn() {
  get-root-fn $*
  eval "$doc $full_options"
}

function dcu-fn() {
  get-root-fn $*
  eval "$doc $full_options up"
}

function dcud-fn() {
  get-root-fn $*
  eval "$doc $full_options up -d"
}

function dcd-fn() {
  get-root-fn $*
  eval "$doc $full_options down"
}

function dcdv-fn() {
  get-root-fn $*
  eval "$doc $full_options down -v"
}

function dcps-fn() {
  get-root-fn $*
  eval "$doc $full_options ps"
}

alias dc=dc-fn
alias dcu=dcu-fn
alias dcud=dcud-fn
alias dcd=dcd-fn
alias dcdv=dcdv-fn
alias dcps=dcps-fn

function dcst-fn() {
  get-root-fn $*
  eval "$doc $cmd_options start $args"
}

function dcstp-fn() {
  get-root-fn $*
  eval "$doc $cmd_options stop $args"
}

function dcrst-fn() {
  get-root-fn $*
  eval "$doc $cmd_options restart $args"
}

function dcpull-fn() {
  get-root-fn $*
  eval "$doc $cmd_options pull $args"
}

function dcbuild-fn() {
  get-root-fn $*
  eval "$doc $cmd_options build $args"
}

alias dcst=dcst-fn
alias dcstp=dcstp-fn
alias dcrst=dcrst-fn
alias dcpull=dcpull-fn
alias dcbuild=dcbuild-fn
