# dotnet related tops and tricks

## un-proviledged setup script

```bash
mkdir -p $HOME/.dotnet
curl "https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh" -o $HOME/.dotnet/dotnet-install
chmod +x $HOME/.dotnet/dotnet-install
$HOME/.dotnet/dotnet-install -c LTS --install-dir $HOME/.dotnet

cat >>"$HOME/.bashrc" <<SHELL
## start dotnet
export DOTNET_ROOT=\$HOME/.dotnet
export PATH=\$PATH:\$DOTNET_ROOT
export PATH=\$PATH:\$DOTNET_ROOT/tools
## end dotnet
SHELL
# source $HOME/.profile
## or
## source $HOME/.zshrc
dotnet --info
```

## import certificates

```bash
dotnet dev-certs https --clean --import $HOME/localhost.pfx -p ""
dotnet dev-certs https --trust
```