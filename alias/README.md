# Variuos unix alias helpers

### Docker, compose and swarm commands

Copy to newly created directory

```bash
mkdir -p ~/.bashrc.d/ && \
rm -rf ~/.bashrc.d/*.bashrc && \
cp -r ./alias/*.bashrc ~/.bashrc.d/

```

Add alias to preffered terminal
```bash
export ALIAS_HELPER_DIR=~/.bashrc.d/
cat >> ~/.bashrc << EOF
## Docker, docker compose and docker stack commands
[[ -f $ALIAS_HELPER_DIR/docker-shared.bashrc ]] && . $ALIAS_HELPER_DIR/docker-shared.bashrc
[[ -f $ALIAS_HELPER_DIR/docker.bashrc ]] && . $ALIAS_HELPER_DIR/docker.bashrc
[[ -f $ALIAS_HELPER_DIR/docker-compose.bashrc ]] && . $ALIAS_HELPER_DIR/docker-compose.bashrc
[[ -f $ALIAS_HELPER_DIR/docker-stack.bashrc ]] && . $ALIAS_HELPER_DIR/docker-stack.bashrc
EOF
```

## Use loop to source aliases

```bash
# If using ZSH
if [ -f "$HOME/.bashrc" ]; then
. "$HOME/.bashrc"
fi

# Load user specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*.bashrc; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi
```