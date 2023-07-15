#!/bin/bash

function setup_certificate() {
    mkdir -p $HOME/certificate
    certificate_root="$HOME/certificate"
    certificate_config="certificate/localhost.conf"

    if [[ -d $HOME/certificate ]]; then
        echo "$(dirname $0)/$certificate_config"
        cp "$(dirname $0)/$certificate_config" $HOME/$certificate_config

        if [[ -f $HOME/$certificate_config ]]; then
            echo "generating certificate keys"
            openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
                -keyout $certificate_root/localhost.key \
                -out $certificate_root/localhost.crt \
                -config $certificate_root/localhost.conf
        fi

        if [[ $os_variant == "openSUSE" ]]; then
            echo "apply private key for $os_variant"
            sudo cp $certificate_root/localhost.crt /usr/share/pki/trust/anchors
            sudo update-ca-certificates
        fi

        if [[ -f $certificate_root/localhost.crt ]]; then
            echo verifing generated certificate..
            openssl verify $certificate_root/localhost.crt
        fi

    fi

}
