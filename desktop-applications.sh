#!/usr/bin/env bash

# Script to install some basic necessities.

cd
set -x

## apt tools already in the ubuntu repositories

# common system utilities are best installed with apt
# these are already included in the package repos of ubuntu
sudo apt update
sudo apt upgrade
sudo apt install \
	apt-transport-https wget curl net-tools build-essential git \
	tmux vim xclip terminator ufw htop lm-sensors gnome-tweaks \
	lsb-release fortune cowsay linux-tools-common linux-tools-generic

## 3rd party tools installble via apt

# 3rd party stuff is installable with apt but you need to
# point it to the repositories. The below commands are given
# on the websites of the various tools.
# Note: some of this is also installable using `snap install` (which is what
# the software centre app does) ... however I think apt is the preferred method
# if it's available.

# Brave: Excellent ad-blocking webbrowser
# https://brave.com/linux/
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# https://code.visualstudio.com/docs/setup/linux
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

# https://www.sublimetext.com/docs/linux_repositories.html
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Insync: google drive sync client
# https://www.insynchq.com/downloads (linux -> repositories)
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
echo "deb http://apt.insync.io/ubuntu $(lsb_release -c -s) non-free contrib" | sudo tee /etc/apt/sources.list.d/insync.list

# Above installs the 3rd party repositories and security keys.
# This step installs the software itself, now that apt knows about it.
sudo apt update
sudo apt install brave-browser sublime-text code insync

## 3rd party tools distributed as appimages

# Yet another install method: appimage!
# This adds the appimage daemon so that appimages are recognised by the desktop,
# so that when workflowy + bitwarden are added below, you get launcher icons.
# https://github.com/probonopd/go-appimage/blob/master/src/appimaged/README.md
if [ ! -f ~/Applications/appimaged*x86_64.AppImage ]; then
	systemctl --user stop appimaged.service || true
	sudo apt-get -y remove appimagelauncher || true
	rm -f "$HOME"/.local/share/applications/appimage*
	mkdir -p ~/Applications
	wget -c https://github.com/$(wget -q https://github.com/probonopd/go-appimage/releases -O - | grep "appimaged-.*-x86_64.AppImage" | head -n 1 | cut -d '"' -f 2) -P ~/Applications/
	chmod +x ~/Applications/appimaged-*.AppImage
	~/Applications/appimaged-*.AppImage
fi

# Workflowy
if [ ! -f ~/Applications/WorkFlowy-x86_64.AppImage ]; then
	wget https://github.com/workflowy/desktop/releases/download/v1.3.7-2795/WorkFlowy-x86_64.AppImage
	chmod a+x WorkFlowy-x86_64.AppImage
	mv WorkFlowy-x86_64.AppImage ~/Applications
fi

# Bitwarden
if [ ! -f ~/Applications/Bitwarden-x86_64.AppImage ]; then
	curl -O -J -L 'https://vault.bitwarden.com/download/?app=desktop&platform=linux'
	chmod a+x Bitwarden-*x86_64.AppImage
	mv Bitwarden-*x86_64.AppImage ~/Applications/Bitwarden-x86_64.AppImage
fi
