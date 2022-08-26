# Fedora development workstation setup

## NOTE: OS installation option for drives

Ensure to set root and home as follows.
A BTRFS volume for easy management and timeshift backup setup.
btrfs-vol: no label or size.
sub-vol-0:- name: @, mount-point: /
sub-vol-1:- name: @home, mount-point: /home
efi: size: 512M mount-point: /boot/efi
boot: size: 2048M mount-point: /boot

## Resource links

https://fedoramagazine.org/hibernation-in-fedora-36-workstation/
https://mutschler.dev/linux/ubuntu-post-install/
https://www.if-not-true-then-false.com/2015/fedora-nvidia-guide/

## Setup hostname

```bash
sudo hostnamectl set-hostname <host-name>
```

## Extra settings

- Switch to dark mode
- Tweak multi tasking options
- Enable tap to click
- Disable removable media prompt
- Change power options
- Update night light
- Update nautilus options

## Optimize dnf package manager

```bash
echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf
cat /etc/dnf/dnf.conf
```

## Third party repos

```basg
sudo dnf install -y  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf groupupdate core
sudo dnf copr enable kwizart/fedy
sudo dnf update -y
sudo dnf install fedy -y
```

## Installs from fedy package manager

For apps and resources that need full system access.

- Arduino IDE
- Android Studio
- JetsBrains Toolbox
- Firefox Developer Edition
- Docker Community
- Github CLI
- OneDrive
- VsCode
- IntelliJ Community Edition
- Intel Legacy VAAPI Drivers
- Intel Media Drivers
- Numix Theme
- Microsoft TrueType Fonts

## Enable flatpak and extension manager

```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update
flatpak install com.mattjakeman.ExtensionManager
```

## Install Essential dependencies

```bash
sudo dnf install -y wget curl caffeine \
timeshift google-chrome-stable dnf-plugins-core
## Setup network display feature
sudo dnf -y install gstreamer1-vaapi && \
flatpak install -y flathub org.gnome.NetworkDisplays
```

## Start general extensions setup

```bash
chmod +x gnome-extension-install.sh
./gnome-extension-install.sh
```

## Apply extensions

```bash
sudo reboot
```

## Activate installed system extensions

```bash
gnome-extensions enable pop-shell@system76.com
gnome-extensions enable dash-to-dock@micxgx.gmail.com
gnome-extensions enable gsconnect@andyholmes.github.io
gnome-extensions enable sound-output-device-chooser@kgshank.net
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable openweather-extension@jenslody.de
gnome-extensions enable caffeine@patapon.info
gnome-extensions enable native-window-placement@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable cpupower@mko-sl.de
```

# Some development and build tools

``bash
sudo dnf install -y gcc gcc-g++ boost-devel make autoconf automake redhat-rpm-config golang
sudo dnf erase -y java-latest-openjdk-devel java-17-openjdk-devel java-1.8.0-openjdk-devel
sudo dnf install -y java-11-openjdk-devel

````

## Modify ZRAM auto swap generation
```bash
## For default swap
echo '[zram0]' >> /etc/systemd/zram-generator.conf
## Assign half of installed RAM
echo 'zram-size = ram/2' >> /etc/systemd/zram-generator.conf
````

## Optimize system limits

```bash
## Switch to root
sudo -i

## Set optons
echo 'fs.inotify.max_user_watches = 1000000' >> /etc/sysctl.conf
echo 'fs.file-max = 1024000' >> /etc/sysctl.conf
echo 'vm.max_map_count = 1024000' >> /etc/sysctl.conf
echo 'net.ipv4.ip_local_port_range = 1024 65535' >> /etc/sysctl.conf
sysctl -p
```

```bash
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
```

## Enable docker memory limit

```bash
sudo nano /etc/default/grub
## Add below for docker memory to line:GRUB_CMDLINE_LINUX
## cgroup_enable=memory swapaccount=1
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
```

## Setup docker options

```bash
Switch to root
sudo -i

## Create config
cat >/etc/docker/daemon.json <<'JSON'
{
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    },
    "storage-driver": "overlay2"
}
JSON

sudo dnf install -y docker-compose
sudo systemctl restart docker
```

## Assign user to required group

```bash
sudo usermod -aG docker <username>
sudo usermod -aG sudo <username>
```

## Setup media codec and compat programs

```bash
sudo dnf install -y vlc
sudo dnf groupupdate sound-and-video
sudo dnf install -y libdvdcss
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,ugly-\*,base} gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg
sudo dnf install -y lame\* --exclude=lame-devel
sudo dnf group upgrade --with-optional Multimedia
sudo dnf config-manager --set-enabled fedora-cisco-openh264
sudo dnf install -y gstreamer1-plugin-openh264 mozilla-openh264
```

## ZSH setup

```bash
sudo dnf install -y zsh util-linux-user
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

## Install fonts manually

```bash
cd ~/Downloads
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
cd ~
```

## Setup power level

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

## Change ZSH_THEME to below

```
## ZSH_THEME="powerlevel10k/powerlevel10k"

## and run

source ~/.zshrc
```

## To reconfigure

```bash
p10k configure
```

## Fix shopt error when extending .bashrc

```bash
## Switch to root
sudo -i

## Create executable
sudo cat > /usr/bin/shopt <<'SHELL'
#!/bin/bash
args='';
for item in $@
  do
    args="$args $item";
  done
shopt $args;
SHELL
sudo chmod +x /usr/bin/shopt
exit

## Add to profile
echo "alias shopt='/usr/bin/shopt'" >> ~/.zshrc
cat >> "$HOME/.zshrc" <<'SHELL'
if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi
SHELL
```

## Setup shell aliases

```bash
mkdir -p ~/apps/ && cd ~/apps/
git clone https://github.com/gpproton/unix-assist.git
cd unix-assist && chmod +x alias.sh
## ./alias.sh or
mkdir -p "$HOME/.bashrc.d/"
cp -r ./alias/*.bashrc "$HOME/.bashrc.d/"
cd ~
```

## Pop GTK theme

```bash
sudo dnf install -y sassc meson glib2-devel
git clone https://github.com/pop-os/gtk-theme /home/$USER/fedora/pop-theme/gtk-theme
cd /home/$USER/fedora/pop-theme/gtk-theme
meson build && cd build
ninja
sudo ninja install
```

## Pop icon theme

```bash
git clone https://github.com/pop-os/icon-theme /home/$USER/fedora/pop-theme/icon-theme
cd /home/$USER/fedora/pop-theme/icon-theme
meson build
sudo ninja -C "build" install
```

## Pop fonts

```bash
sudo dnf install -y fira-code-fonts 'mozilla-fira*' 'google-roboto*'
```

## Activate POP options

```bash
gsettings set org.gnome.desktop.interface gtk-theme "Pop"
gsettings set org.gnome.desktop.interface icon-theme "Pop"
gsettings set org.gnome.desktop.interface cursor-theme "Pop"

## Gnome Tweaks font options
## Interface Text: Fira Sans Book 9
## Document Text: Roboto Slab Regular 9
## Monospace Text: Fira Mono Regular 9
## Legacy Window Titles: Fira Sans SemiBold 9
## Hinting: Slight
## Antialiasing: Standard (greyscale)
## Scaling Factor: 0.82
```

## Reset with this if result is undesired

```bash
gsettings reset org.gnome.desktop.interface monospace-font-name
gsettings reset org.gnome.desktop.interface document-font-name
gsettings reset org.gnome.desktop.interface font-name
gsettings reset org.gnome.desktop.wm.preferences titlebar-font
```

sudo reboot

```bash
git config --global user.name "radioActive DROID"
git config --global user.email "me@godwin.dev"
```

## Easy cli login with github cli

```bash
gh auth login
```

## Setup initial backup before graphic driver

```bash
## Manually
sudo timeshift-gtk

## Or

sudo timeshift --create --comments "Before graphic drivers"
```

## General auto driver install

```bash
sudo dnf upgrade --refresh -y
sudo dnf check
sudo dnf autoremove -y
sudo fwupdmgr get-devices
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates
sudo fwupdmgr update
sudo reboot now
```

## Optional Nvidia auto installer tool

```bash
dnf copr enable t0xic0der/nvidia-auto-installer-for-fedora -y
dnf install nvautoinstall -y
sudo nvautoinstall cheksu
sudo nvautoinstall compat
sudo nvautoinstall rpmadd
sudo nvautoinstall nvrepo
sudo nvautoinstall driver
sudo nvautoinstall plcuda
sudo nvautoinstall primec
```

## Optional Nvidia driver install

```bash
sudo dnf install akmod-nvidia -y
sudo dnf install xorg-x11-drv-nvidia-cuda
```

## Install required flatpak apps

```bash
flatpak install --or-update --assumeyes flathub \
org.mozilla.Thunderbird io.dbeaver.DBeaverCommunity \
com.discordapp.Discord com.boxy_svg.BoxySVG \
org.gaphor.Gaphor io.github.shiftey.Desktop \
org.gnome.NetworkDisplays com.heroicgameslauncher.hgl \
com.icons8.Lunacy io.github.Figma_Linux.figma_linux \
nl.hjdskes.gcolor3 org.gimp.GIMP org.gnome.meld \
org.inkscape.Inkscape rest.insomnia.Insomnia \
com.getpostman.Postman com.microsoft.Edge \
com.mongodb.Compass org.musicbrainz.Picard \
com.notepadqq.Notepadqq md.obsidian.Obsidian \
org.raspberrypi.rpi-imager app.resp.RESP \
com.transmissionbt.Transmission org.kde.umbrello \
com.github.sdv43.whaler net.davidotek.pupgui2 \
net.lutris.Lutris com.skype.Client fr.handbrake.ghb \
org.freedownloadmanager.Manager
```

## dotnet setup

```bash
cd ~ && rm -rf ~/dotnet-install.sh && \
curl 'https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh' -o ~/dotnet-install.sh && \
chmod +x dotnet-install.sh && ./dotnet-install.sh -c LTS
```

## NodeJs setup

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash &&
curl -fsSL https://get.pnpm.io/install.sh | sh - && \
source ~/.zshrc && nvm install --lts && \
pnpm i -g npm yarn pnpm typescript ts-node rimraf
```

## Setup onedrive sync

```bash
## Initial authentication
onedrive

onedrive --synchronize --resync

sudo systemctl --user start onedrive

```
