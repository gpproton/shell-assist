function install() {
    if [ $os_variant == "osx" ]; then
        brew install $*
    elif [ $os_variant == "ubuntu" || $os_variant == "debian" ]; then
        sudo apt install -y $*
    elif [ $os_variant == "centos" || $os_variant == "rocky" || $os_variant == "fedora" ]; then
        sudo dnf install -y $*
    elif [ $os_variant == "opensuse" ]; then
        sudo zypper install -y $*
    else
        echo "OS distribution not supported"
        exit 1
    fi
}

echo "Detected Linux distribution: $os_variant"
