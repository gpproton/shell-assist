# Variuos unix alias helpers

```bash
cd $HOME
if [[ ! -d $HOME/shell-assist/alias ]]; then
git clone https://github.com/gpproton/shell-assist.git
else
	echo "repository already cloned"
fi
```

## Use loop to source aliases
```bash
alias="$HOME/shell-assist/alias"
if [ -d $alias/ ]; then
	for rc in $alias/*.sh; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi
```

## If using ZSH

```bash
if [ -f "$HOME/.bashrc" ]; then
. "$HOME/.bashrc"
fi
