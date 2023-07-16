#!/bin/bash

os_defaults="$(dirname $0)/util/defaults.sh"

# Load OS information
if [ -f "$os_defaults" ]; then
    source $os_defaults && load_os_information
    load_environment_variables
    load_shell_properties
fi

function help_content() {
    cat <<-EOF
========================================================
OS TYPE: $os_type
OS VARIANT: $os_variant
========================================================
===================== SHELL-ASSIST =====================

usage: ./setup [-h] [--help]

options:

--help, -h, help:  Get help content

-------------------------------------------------------
alias:  Setup shell alias usage
usage: ./setup alias

-------------------------------------------------------
certificate:  Setup self signed certificate
usage: ./setup certificate


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
    setup_alias="$(dirname $0)/common/setup-alias.sh"
    if [ -f $setup_alias ]; then
        source $setup_alias
        register_profile_alias
    fi

    ;;
"docker")
    echo "Starting docker setup..."
    ;;
"cert")
    echo "Starting self signed certificate setup..."
    certificate="$(dirname $0)/certificate/setup.sh"
    if [ -f $certificate ]; then source $certificate && setup_certificate; fi
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
