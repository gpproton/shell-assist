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
export ASPNETCORE_Kestrel__Certificates__Default__Password=""
export ASPNETCORE_Kestrel__Certificates__Default__Path="\$HOME/localhost.pfx"
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
dotnet dev-certs https -ep $HOME/certificate/localhost.crt --format PEM
dotnet dev-certs https -ep $HOME/certificate/localhost.crt -p "" --trust --format PEM
```

```bash
## setup nss-tools or mozilla-nss-tools
cert_path=$HOME/certificate
cert_name="localhost"

## Chromium-based Browsers
certutil -d sql:$HOME/.pki/nssdb -A -t "P,," -n ${cert_name} -i ${cert_path}/${cert_name}.crt
certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n ${cert_name} -i ${cert_path}/${cert_name}.crt

## Mozilla Firefox
firefox_profile=""
certutil -d sql:$HOME/.mozilla/firefox/${firefox_profile}/ -A -t "P,," -n ${cert_name} -i ${cert_path}/${cert_name}.crt
certutil -d sql:$HOME/.mozilla/firefox/${firefox_profile}/ -A -t "C,," -n ${cert_name} -i ${cert_path}/${cert_name}.crt


## Fix corrupted store
mv ~/.pki/nssdb ~/.pki/nssdb.corrupted
mkdir ~/.pki/nssdb
chmod 700 ~/.pki/nssdb
certutil -d sql:$HOME/.pki/nssdb -N
```