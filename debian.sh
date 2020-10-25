
## debian-server essentials
apt update && \
apt install -y sudo && \
sudo echo 'PermitRootLgin yes' | sudo tee -a /etc/ssh/sshd_configs && \
sudo systemctl restart ssh && \
sudo apt -y upgrade && \
sudo apt install -y molly-guard net-tools \
curl wget python3-pip build-essential qemu-guest-agent \
software-properties-common dirmngr apt-transport-https lsb-release ca-certificates \
libssl-dev libffi-dev python3-dev python3-venv && \
sudo apt install -y golang-go docker.io && \
sudo systemctl enable docker.service --now && \
sudo apt autoremove && rm -rf /etc/apt/sources.list.d/* && \
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add && \
sudo echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee -a /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update && \
sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni

## Small swap space creation, not recommended.
sudo swapoff -a && \
sudo fallocate -l 8G /swapfile && \
sudo chmod 600 /swapfile && \
sudo mkswap /swapfile && \
sudo swapon /swapfile && \
sudo swapon --show && \
sudo free -h && \
sudo cp /etc/fstab /etc/fstab.bak && \
sudo echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab && \

## Docker memory limit fix for debian based distro
sudo cat > /etc/default/grub <<'EOF'
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
GRUB_CMDLINE_LINUX_DEFAULT="maybe-ubiquity"
EOF
sudo update-grub && \

## To increase the available limit to say 999999
sudo cat > /etc/sysctl.conf <<'EOF'
fs.file-max = 999999
vm.swappiness=15
vm.vfs_cache_pressure=50
vm.max_map_count = 999999
net.ipv4.ip_local_port_range = 1024 65535
EOF

# run this to refresh with new config
sudo sysctl -p

# add to increase file and system limits
sudo cat > /etc/security/limits.conf <<'EOF'
* soft     nproc          999999
* hard     nproc          999999
* soft     nofile         999999
* hard     nofile         999999
root soft     nproc          999999
root hard     nproc          999999
root soft     nofile         999999
root hard     nofile         999999
EOF

# edit the following file
sudo echo 'session required pam_limits.so' | sudo tee -a /etc/pam.d/common-session

# edit the following file
sudo echo 'session required pam_limits.so' | sudo tee -a /etc/pam.d/common-session-noninteractive

## Start kubernetes setup

# kubernetes swap fail bypass
sudo cat > /etc/systemd/system/kubelet.service.d/20-allow-swap.conf <<'EOF'
[Service]
Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"
EOF

kubeadm reset 
echo 'Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"' | sudo tee -a /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

# Change docker default 
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

sudo systemctl daemon-reload &&systemctl restart kubelet

# Start Kubernetes initialization process
# TODO:Place a parameter condition here.
#sudo echo "$(sudo kubeadm init –ignore-preflight-errors Swap)" | sudo tee -a ~/kube-join-instructions.txt && \
#mkdir -p ~/.kube && \
#sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config && \
#sudo chown $(id -u):$(id -g) ~/.kube/config && \

# logout and login and try the following command
ulimit -n && \
echo -ne "$(hostname -f)\n" | sudo /sbin/reboot
