#!/bin/bash
## Copy to newly created directory
mkdir -p ~/.bashrc.d/ &&
    cp -r ./alias/*.bashrc ~/.bashrc.d/

## Add alias to preffered terminal
# export ALIAS_HELPER_DIR=~/.bashrc.d
# cat >>~/.bashrc <<EOF
# #########################################
# ########## Helper unix alias ############
# ## General and system command alias
# [[ -f $ALIAS_HELPER_DIR/general.bashrc ]] && . $ALIAS_HELPER_DIR/general.bashrc
# [[ -f $ALIAS_HELPER_DIR/system.bashrc ]] && . $ALIAS_HELPER_DIR/system.bashrc
# ## Docker, docker-compose and docker-stack command alias
# [[ -f $ALIAS_HELPER_DIR/docker.bashrc ]] && . $ALIAS_HELPER_DIR/docker.bashrc
# [[ -f $ALIAS_HELPER_DIR/docker-compose.bashrc ]] && . $ALIAS_HELPER_DIR/docker-compose.bashrc
# [[ -f $ALIAS_HELPER_DIR/docker-stack.bashrc ]] && . $ALIAS_HELPER_DIR/docker-stack.bashrc
# #########################################
# EOF
