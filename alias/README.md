# Terminal alias setup

```bash
cd $HOME
if [[ ! -d $HOME/shell-assist/alias ]]; then
git clone https://github.com/gpproton/shell-assist.git
else
	echo "repository already cloned"
fi
```

## Setup alias
```bash
./setup.sh alias
```

## If using ZSH

```bash
if [ -f "$HOME/.bashrc" ]; then
. "$HOME/.bashrc"
fi
