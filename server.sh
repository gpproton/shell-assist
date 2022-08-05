#! /bin/bash
(
    chmod +x ./general.sh
    ./general.sh
)

## debian-server essentials
apt update &&
    apt install -y sudo openssh-server

# Setup openssh server
sudo echo 'PermitRootLgin no' | sudo tee -a /etc/ssh/sshd_configs &&
    sudo systemctl enable sshd && sudo systemctl restart sshd

# Start upgrade and common util install.
sudo apt -y upgrade &&
    sudo apt install -y molly-guard net-tools \
        curl wget python3-pip build-essential qemu-guest-agent \
        software-properties-common dirmngr apt-transport-https lsb-release ca-certificates \
        libssl-dev libffi-dev python3-dev python3-venv golang-go \
        iptables-persistent fail2ban psad

## Set group permission
sudo /sbin/usermod -aG sudo $(id -un)

# Reload services config and restart kube service.
sudo systemctl daemon-reload &&
    # Enable iptables persist automatically
    sudo systemctl enable netfilter-persistent &&
    sudo systemctl enable fail2ban &&
    sudo systemctl enable psad
