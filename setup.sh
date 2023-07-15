#!/bin/bash

os_defaults="$(dirname $0)/util/os-defaults.sh"
setup_alias="$(dirname $0)/setup/setup-alias.sh"

# Load OS information
if [ -f "$os_defaults" ]; then source $os_defaults && load_os_info; fi
## Load alias setup functions
if [ -f $setup_alias ]; then source $setup_alias; fi

function help_content() {
    cat <<-EOF
========================================================
OS TYPE: $os_type
OS VARIANT: $os_variant
========================================================
===================== SHELL-ASSIST =====================

usage: ./play [-h] [--help]

options:

--help, -h, help:  Get help content

-------------------------------------------------------
alias:  Setup shell alias usage
usage: ./setup alias


-------------------------------------------------------
docker:  Setup docker environment
usage: ./setup docker


-------------------------------------------------------
kubernetes:  Setup kubernetes environment
usage: ./setup kubernetes

EOF
}

case $1 in
"alias")
    echo "starting alias setup..."
    load_alias_script
    ;;
"docker")
    echo "Starting docker setup..."
    ;;
"dev")
    echo "Starting  development work station setup..."
    ;;
"kubernetes")
    echo "Starting kubernetes setup..."
    ;;
"-h" | "--help" | "help")
    help_content
    ;;
*)
    help_content
    ;;
esac
