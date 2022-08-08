#!/bin/bash
## Copy to newly created directory
mkdir -p ~/.bashrc.d/ && rm -rf ~/.bashrc.d/* &&
    cp -r ./alias/*.bashrc ~/.bashrc.d/
cat >>~/.bashrc <<EOF
## Load all bash alias from path
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

EOF

## Optional usage.
# alias_path="~/.bashrc.d"
# cat >>~/.bashrc <<EOF
# ########## Helper unix alias #######
# ## General and system command alias
# [[ -f $alias_path/general.bashrc ]] && . $alias_path/general.bashrc
# [[ -f $alias_path/system.bashrc ]] && . $alias_path/system.bashrc
# [[ -f $alias_path/git.bashrc ]] && . $alias_path/git.bashrc
# [[ -f $alias_path/util.bashrc ]] && . $alias_path/util.bashrc
# ## Docker, docker-compose and docker-stack command alias
# [[ -f $alias_path/_docker.bashrc ]] && . $alias_path/_docker.bashrc
# [[ -f $alias_path/docker.bashrc ]] && . $alias_path/docker.bashrc
# [[ -f $alias_path/docker-compose.bashrc ]] && . $alias_path/docker-compose.bashrc
# [[ -f $alias_path/docker-stack.bashrc ]] && . $alias_path/docker-stack.bashrc
# EOF
