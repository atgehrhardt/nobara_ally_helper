#!/bin/bash

# Specifies which kernel and rogue-enemy version to download
KERNEL_URL="https://github.com/jlobue10/ALLY_Nobara_fixes/releases/download/v2.5.0/kernel-6.7.3-201.fsync.ally.fc39.x86_64.tar.gz"
KERNEL_FILE="${KERNEL_URL##*/}"
KERNEL_NAME="${KERNEL_FILE%.tar.gz}"

# Obtain elevated priviledges
password=$(kdialog --password "Enter your sudo password")

if [ -z "$password" ]; then
    kdialog --error "No password entered. Exiting."
    exit 1
fi

# Pass the password to sudo -v
echo "$password" | sudo -Sv

# Check if the password was correct
if [ $? -eq 0 ]; then
    kdialog --msgbox "Sudo authenticated successfully."
else
    kdialog --error "Sudo authentication failed."
fi

# Install decky loader
curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh | sh

# Install HHD
curl -L https://github.com/hhd-dev/hhd-decky/raw/main/install.sh | sh

# Install CSS Loader and Semakusut's ROG Ally Controller theme
cd ~/homebrew/plugins && git clone https://github.com/DeckThemes/SDH-CssLoader.git
cd $HOME/homebrew/themes && git clone https://github.com/semakusut/SBP-ROG-Ally.git

# Download and extract kernel
cd ~/Downloads
wget $KERNEL_URL --content-disposition
tar xvf $KERNEL_FILE

# Change into RPM directory and install RPMs
cd RPM
sudo dnf install -y *.rpm

# Clean up file
cd ~/Downloads
rm -rf RPM
rm $KERNEL_FILE

# Install SimpleDeckyTDP
curl -L https://github.com/aarron-lee/SimpleDeckyTDP/raw/main/install.sh | sh

# Reboot the system
read -p "Are you ready to reboot your Ally? (y/n): " ready_reboot
if [[ $ready_reboot == "y" || $ready_reboot == "Y" ]]; then
    reboot
fi