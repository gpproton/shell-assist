#!/bin/bash

function load_alias_script() {
	## Copy to newly created directory
	cat >>"$HOME/.bashrc" <<SHELL
## Load all bash alias from path
alias_path="\$HOME/shell-assist/alias"
if [ -d "\$alias_path/" ]; then
	for rc in "\$alias_path/*"; do
		if [ -f "\$rc" ]; then
			. "\$rc"
		fi
	done
fi
SHELL

	## reload shell environment
	echo "reloading shell environment.."
	source "$HOME/.bashrc"
}
