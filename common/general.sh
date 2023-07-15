#! /bin/bash
if [ -f "$(dirname $0)/_shared.bashrc" ]; then
    source "$(dirname $0)/_shared.bashrc"
fi

function fn-setup-essentials() {
    sudo apt-get install \
        ca-certificates \
        wget \
        curl \
        gnupg \
        lsb-release
}
