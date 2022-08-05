function fn-setup-swap() {
    defaut_swap_size=${1:"8G"}
    ## Small swap space creation, crucial if RAM is limited.
    sudo swapoff -a &&
        sudo fallocate -l $defaut_swap_size /swapfile &&
        sudo chmod 600 /swapfile &&
        sudo mkswap /swapfile &&
        sudo swapon /swapfile &&
        sudo swapon --show &&
        sudo free -h &&
        sudo cp /etc/fstab /etc/fstab.bak &&
        sudo echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
}

function fn-add-system-limits() {
    ## To increase the available limit to say 999999
    sudo cat >/etc/sysctl.conf <<'EOF'
fs.file-max = 1024000
vm.swappiness=15
vm.vfs_cache_pressure=50
vm.max_map_count = 999999
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.ip_forward = 1
EOF
    ## Add to profile
    sudo echo 'session required pam_limits.so' | sudo tee -a /etc/pam.d/common-session
    sudo echo 'session required pam_limits.so' | sudo tee -a /etc/pam.d/common-session-noninteractive
    ## Update system limit with new config
    sudo sysctl -p
}
