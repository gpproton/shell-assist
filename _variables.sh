os_type=$(uname -s)
if [ $os_type == "Darwin" ]; then
    os="osx"
    os_variant=$os
elif [ $os_type == "Linux" ]; then
    os=$(cat /etc/os-release | grep "^ID=")
    # os_variant=$(echo $os | sed 's/"//g' | sed 's/ID=//g')
    os_variant=$(cat /etc/*-release | tr [:upper:] [:lower:] | grep -Poi '(debian|ubuntu|red hat|centos|fedora)' | uniq)
    if [ -z $os_variant ]; then
        os_variant='unknown'
    fi
else
    echo "OS not supported"
    exit 1
fi

os_base=""

function package_install() {
    if [ $os_variant == "osx" ]; then
        brew install $*
    elif [ $os_variant == "ubuntu" || $os_variant == "debian" ]; then
        sudo apt install -y $*
    elif [ $os_variant == "centos" || $os_variant == "rocky" || $os_variant == "fedora" ]; then
        sudo dnf install -y $*
    else
        echo "Distribution not supported"
        exit 1
    fi
}

echo "Detected Linux distribution: $os_variant"
