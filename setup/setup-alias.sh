#!/bin/bash

function register_profile_alias() {
	active_shell=$(echo $SHELL | sed -E 's/^.*\/([aA-zZ]+$)/\1/g')
	
	if [[ $active_shell == "bash" && $os_type == "Darwin" ]]; then
		shell_file="$HOME/.profile"
	elif [[ $active_shell == "zsh" ]]; then
		shell_file="$HOME/.zshrc"
	else shell_file="$HOME/.bashrc"
	fi
	
	## TODO: fix condition
	if grep -Fxq "shell-assist" $shell_file; then
		echo "alias already configured..."
	else
		## copy to newly created directory
		cat >>"$shell_file" <<SHELL

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
		echo "alias configuration successful..."
	fi
}
