#!/bin/bash

function setup_certificate() {
    mkdir -p $HOME/certificate
    certificate_root="$HOME/certificate"
    certificate_config="certificate/localhost.conf"

    if [[ -d $HOME/certificate ]]; then
        rm -rf $certificate_root/*
        cp "$(dirname $0)/$certificate_config" $HOME/$certificate_config

        if [[ -f $HOME/$certificate_config ]]; then
            echo "generating certificate keys"
            openssl req -x509 -nodes -days 3650 -newkey rsa:4096 \
                -keyout $certificate_root/localhost.key \
                -out $certificate_root/localhost.crt \
                -config $certificate_root/localhost.conf
            echo "converting crt file to pem"
            openssl x509 -inform pem -in $certificate_root/localhost.crt -out $certificate_root/localhost.pem
        fi

        if [[ $os_type -eq "linux" ]]; then
            if [[ $os_variant -eq "opensuse" ]]; then
                echo "apply private key for $os_variant"
                sudo cp $certificate_root/localhost.crt /etc/pki/trust/anchors
                sudo update-ca-certificates
            fi

            if [[ -f $certificate_root/localhost.crt ]]; then
                echo "======================================"
                echo "verifing generated certificate.."
                openssl verify -CAfile $certificate_root/localhost.pem $certificate_root/localhost.crt

                echo "genrtate combined certificate file"
                rm -rf $HOME/localhost.pfx
                openssl pkcs12 -export \
                    -passout 'pass:' \
                    -out $HOME/localhost.pfx \
                    -inkey $certificate_root/localhost.key \
                    -in $certificate_root/localhost.crt
            fi
        fi
    fi
}
