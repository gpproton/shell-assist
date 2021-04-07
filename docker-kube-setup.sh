#!/bin/bash

# Determine OS platform
case $(uname | tr '[:upper:]' '[:lower:]') in
  linux*) export UNAME=linux
    ;;
  darwin*) export UNAME=osx
    ;;
  bsd*) export UNAME=bsd
    ;;
  msys*) export UNAME=windows
    ;;
  *) export UNAME=unknown
    ;;
esac

# If Linux, try to determine specific distribution
if [[ "$UNAME" == linux ]]; then
  export DISTRO=null
  ################################
  ######  Check distro type ######
  ################################
    if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
        export DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
    # Otherwise, use release info file
    else
        export DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
    fi
    echo "OS is $UNAME, while distro is $DISTRO"

  ## debian-server essentials
  apt update && \
  apt install -y sudo openssh-server

  # Setup openssh server
  sudo echo 'PermitRootLgin no' | sudo tee -a /etc/ssh/sshd_configs && \
  sudo systemctl enable sshd && sudo systemctl restart sshd

  # Start upgrade and common util install.
  sudo apt -y upgrade && \
  sudo apt install -y molly-guard net-tools \
  curl wget python3-pip build-essential qemu-guest-agent \
  software-properties-common dirmngr apt-transport-https lsb-release ca-certificates \
  libssl-dev libffi-dev python3-dev python3-venv golang-go \
  iptables-persistent fail2ban psad

  # Install and setup docker
  sudo apt install -y docker.io docker-compose && \
  sudo systemctl enable docker.service --now

  # Change docker default cgroup driver
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

  # Clear old custom repos.
  sudo apt autoremove && rm -rf /etc/apt/sources.list.d/*

  # Install and setup kubernetes
  sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add && \
  sudo echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee -a /etc/apt/sources.list.d/kubernetes.list && \
  sudo apt-get update && \
  sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni

  # kubernetes swap fail bypass
  sudo cat > /etc/systemd/system/kubelet.service.d/20-allow-swap.conf <<'EOF'
  [Service]
  Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"
EOF

  echo -ne "y\n" | sudo kubeadm reset 
  sudo sed -i '9s/^/Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"\n/' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

  sudo echo "
  kind: MasterConfiguration
  apiVersion: kubeadm.k8s.io/v1alpha1
  api:
    bindPort: ${K8S_API_PORT}
  apiServerCertSANs: ${K8S_API_EXTRA_HOSTS}
  " > /opt/kube-setup/config.yaml
  
  ## Start cluster initialization
  #kubeadm init --config /opt/kube-setup/config.yaml --ignore-preflight-errors Swap
  ## make possible to run workload on master
  #kubectl taint nodes --all node-role.kubernetes.io/master-

  # Allows network bridging.
  sudo cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
  net.bridge.bridge-nf-call-ip6tables = 1
  net.bridge.bridge-nf-call-iptables = 1
EOF

  # Reload system limit configs
  sudo sysctl --system

  # Reload services config and restart kube service.
  sudo systemctl daemon-reload && systemctl restart kubelet \
  # Enable iptables persist automatically
  && sudo systemctl enable netfilter-persistent \
  && sudo systemctl enable fail2ban \
  && sudo systemctl enable psad

  ## Set group permission
  sudo /sbin/usermod -aG docker $(id -un)
  sudo /sbin/usermod -aG sudo $(id -un)

  ## Small swap space creation, crucial if RAM is limited.
  sudo swapoff -a && \
  sudo fallocate -l 8G /swapfile && \
  sudo chmod 600 /swapfile && \
  sudo mkswap /swapfile && \
  sudo swapon /swapfile && \
  sudo swapon --show && \
  sudo free -h && \
  sudo cp /etc/fstab /etc/fstab.bak && \
  sudo echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab && \

  ## Add alias and paths
  sudo cat > ~/.bashrc <<'EOF'
  alias python='python3'
  alias pip='pip3'

  export PATH=/usr/local/sbin:$PATH
  export PATH=/usr/sbin:$PATH
  export PATH=/sbin:$PATH
EOF

  ## Docker memory limit fix for debian based distro
  sudo cat > /etc/default/grub <<'EOF'
  GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
  GRUB_CMDLINE_LINUX_DEFAULT="maybe-ubiquity"
EOF
  sudo update-grub && \

  ## To increase the available limit to say 999999
  sudo cat > /etc/sysctl.conf <<'EOF'
  fs.file-max = 1024000
  vm.swappiness=15
  vm.vfs_cache_pressure=50
  vm.max_map_count = 999999
  net.ipv4.ip_local_port_range = 1024 65535
  net.ipv4.ip_forward = 1
EOF

  # Update system limit with new config
  sudo sysctl -p

  # add to increase file and system limits
  sudo cat > /etc/security/limits.conf <<'EOF'
  * soft     nproc          1024000
  * hard     nproc          1024000
  * soft     nofile         1024000
  * hard     nofile         1024000
  root soft     nproc          1024000
  root hard     nproc          1024000
  root soft     nofile         1024000
  root hard     nofile         1024000
EOF

  # edit the following file
  sudo echo 'session required pam_limits.so' | sudo tee -a /etc/pam.d/common-session
  sudo echo 'session required pam_limits.so' | sudo tee -a /etc/pam.d/common-session-noninteractive

  # Unset distro tag
  unset DISTRO

  # logout and login and try the following command
  ulimit -n && \
  echo -ne "$(hostname -f)\n" | sudo /sbin/reboot
else
  echo "$UNAME is an incompatible OS.."
fi
unset UNAME
