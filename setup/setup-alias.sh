#!/bin/bash

function load_alias_script() {
	if [[ -x "$(command -v grep "shell-assist" -q $HOME/.bashrc)" ]]; then
		## copy to newly created directory
		cat >>"$HOME/.bashrc" <<SHELL

## start shell-assist
ALIAS_PATH="\$HOME/shell-assist/alias"
if [ -d \$ALIAS_PATH ]; then
	for rc in \$ALIAS_PATH/*.sh; do
		if [ -f \$rc ]; then
			source \$rc
		fi
	done
fi
## end shell-assist
SHELL
	fi
	## reload shell environment
	echo "reloading shell environment.."
	source "$HOME/.bashrc"
}
