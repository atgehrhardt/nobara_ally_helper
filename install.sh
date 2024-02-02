#!/bin/bash

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

# Install SimpleDeckyTDP
curl -L https://github.com/aarron-lee/SimpleDeckyTDP/raw/main/install.sh | sh

# Reboot the system
read -p "Are you ready to reboot your Ally? (y/n): " ready_reboot
if [[ $ready_reboot == "y" || $ready_reboot == "Y" ]]; then
    reboot
fi