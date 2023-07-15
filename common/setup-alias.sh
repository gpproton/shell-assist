#!/bin/bash

function register_profile_alias() {
	alias_configured=$(cat $shell_profile_file | grep -c "shell-assist")
	if [[ $alias_configured -eq 0 ]]; then
		cat >>"$shell_profile_file" <<SHELL

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
	else
		echo "alias already configured..."
	fi
}
