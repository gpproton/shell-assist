#!/bin/bash

## Setup custom extension repo
sudo dnf copr enable fin-ger/cpupower -y
sudo dnf copr enable mjakeman/system76-scheduler -y

## Setup tools and system extensions
sudo dnf install -y pyhton3-pip git gnome-tweaks \
    gnome-extensions-app gnome-shell-extension-common \
    gnome-shell-extension-caffeine gnome-shell-extension-appindicator \
    gnome-shell-extension-dash-to-dock gnome-shell-extension-gsconnect \
    gnome-shell-extension-openweather gnome-shell-extension-pop-shell \
    gnome-shell-extension-sound-output-device-chooser \
    gnome-shell-extension-user-theme \
    gnome-shell-extension-native-window-placement

## Setup custom repo extensions
sudo dnf install -y system76-scheduler libgtop2-devel lm_sensors
sudo systemctl enable --now com.system76.Scheduler.service
sudo systemctl start com.system76.Scheduler.service
sudo dnf install -y gnome-shell-extension-cpupower

APPS_PATH="$HOME/apps"
EXTENSION_TEMP_PATH="$APPS_PATH/extension"

## Setup envycontrol
mkdir -p $APPS_PATH &&
    git clone https://github.com/geminis3/envycontrol.git &&
    cd $APPS_PATH &&
    sudo pip install .

mkdir -p $EXTENSION_TEMP_PATH
cd $EXTENSION_TEMP_PATH
array=(s76-scheduler@mattjakeman.com Vitals@CoreCoding.com blur-my-shell@aunetx GPU_profile_selector@lorenzo9904.gmail.com gnome-ui-tune@itstime.tech arcmenu@arcmenu.com notification-position@drugo.dev autoselectheadset@josephlbarnett.github.com)
for i in "${array[@]}"; do
    VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=${i}" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')
    wget -O "${i}.zip" "https://extensions.gnome.org/download-extension/${i}.shell-extension.zip?version_tag=$VERSION_TAG"
    gnome-extensions install --force "${EXTENSION_ID}.zip"
    if ! gnome-extensions list | grep --quiet "${i}"; then
        busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s "${i}"
    fi
    gnome-extensions enable "${i}"
    rm "${EXTENSION_ID}.zip"
done

## Return home
cd $HOME
