os_type=$(uname -s)
if [ $os_type == "Darwin" ]; then
    os="osx"
    os_variant=$os
elif [ $os_type == "Linux" ]; then
    os=$(cat /etc/os-release | grep "^ID=")
    os_variant=$(echo $os | sed 's/"//g' | sed 's/ID=//g')
else
    echo "OS not supported"
    exit 0
fi

echo $os_variant
