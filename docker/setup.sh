#! /bin/bash

if [ -f "$(dirname $0)/_shared.bashrc" ]; then
    source "$(dirname $0)/_shared.bashrc"
fi

## Debian remove
sudo apt-get remove docker docker-engine docker.io containerd runc

## Setup repo and keys for selected OS
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

# Install and setup docker
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose &&
    sudo systemctl enable docker.service --now

# Change docker default cgroup driver
cat >/etc/docker/daemon.json <<EOF
{
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    },
    "storage-driver": "overlay2"
}
EOF

## Set group permission
sudo /sbin/usermod -aG docker $(id -un)

## Docker memory limit fix for debian based distro
sudo cat >/etc/default/grub <<'EOF'
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
EOF
sudo update-grub
