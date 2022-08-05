#! /bin/bash

if [ -f "$(dirname $0)/_shared.bashrc" ]; then
    source "$(dirname $0)/_shared.bashrc"
fi

# Install and setup docker
sudo apt install -y docker.io docker-compose &&
    sudo systemctl enable docker.service --now &&
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
