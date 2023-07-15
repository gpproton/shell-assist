#!/bin/bash

function load_environment_variables() {
    echo 'loading enviroment varibles from file...'
    env_file='.env'
    if [ -f $PWD/$env_file ]; then
        env_file='.env.sample'
    fi
    set -a
    source <(cat $env_file | sed -e '/^#/d;/^\s*$/d' -e "s/'/'\\\''/g" -e "s/=\(.*\)/='\1'/g")
    set +a

    unset $env_file
}

function load_os_info() {
    os_type=$(uname -s)
    if [ $os_type == "Darwin" ]; then
        os_variant=$os_type
    elif [ $os_type == "Linux" ]; then
        if [[ -x "$(command -v lsb_release)" ]]; then
            os_variant=$(lsb_release -is)
        else
            os_variant=$(uname -s)
            if [ $os_variant == "Linux" ]; then
                os_variant=$(cat /etc/*-release | tr [:upper:] [:lower:] | grep -Poi '(debian|ubuntu|red hat|centos|fedora)' | uniq)
                if [ -z $os_variant ]; then
                    os_variant=""
                fi
            fi
        fi
    else
        echo "OS not supported"
        exit 1
    fi
}

function load_shell_properties() {
    shell_profile_file="$HOME/.bashrc"
    active_shell="bash"
    case $SHELL in
    "*zsh*")
        shell_profile_file="$HOME/.zshrc"
        active_shell="zsh"
        ;;
    "*bash*")
        if [[ $os_type == "Darwin" ]]; then
            shell_profile_file="$HOME/.profile"
        fi
        ;;
    esac
}
