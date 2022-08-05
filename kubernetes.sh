#! /bin/bash

if [ -f "$(dirname $0)/_shared.bashrc" ]; then
    source "$(dirname $0)/_shared.bashrc"
fi

# Install and setup kubernetes
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add &&
    sudo echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee -a /etc/apt/sources.list.d/kubernetes.list &&
    sudo apt-get update &&
    sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni

# kubernetes swap fail bypass
sudo cat >/etc/systemd/system/kubelet.service.d/20-allow-swap.conf <<'EOF'
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
" >/opt/kube-setup/config.yaml

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
sudo systemctl daemon-reload &&
    systemctl restart kubelet
