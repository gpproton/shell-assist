function fn-get-file() {
    unset env_file
    unset stack
    unset compose_file
    env_file=".env"
    stack=${1:-${PWD##*/}}
    compose_file=${2:-docker-compose.yaml}
    if [ ! -f $compose_file ]; then
        compose_file="docker-compose.yml"
    fi
    if [ ! -f $env_file ]; then
        env_file=".env.sample"
    fi
    [ -f $env_file ] && export $(sed '/^#/d' $env_file)
    ## Env and compose file validation
    if [ ! -f $compose_file ] || [ ! -f $env_file ]; then
        echo "Missing compose or env file" >&2
        echo "Compose: $compose_file"
        echo "File: $env_file"
        return 1
    fi
}
