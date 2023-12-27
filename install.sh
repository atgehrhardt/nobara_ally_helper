#!/bin/bash

# Specifies which kernel and rogue-enemy version to download
KERNEL_URL="https://github.com/jlobue10/ALLY_Nobara_fixes/releases/download/v2.3.0/kernel-6.6.7-205.fsync.ally.fc38.x86_64.tar.gz"
ROGUE_ENEMY_URL="https://github.com/jlobue10/ALLY_Nobara_fixes/releases/download/v2.3.0/rogue-enemy-1.5.3-1.fc38.x86_64.rpm"
KERNEL_FILE="${KERNEL_URL##*/}"
KERNEL_NAME="${KERNEL_FILE%.tar.gz}"
ROGUE_ENEMY_FILE="${ROGUE_ENEMY_URL##*/}"

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

# Change to Downloads directory
cd ~/Downloads

# Download files using wget
wget $KERNEL_URL --content-disposition
wget $ROGUE_ENEMY_URL --content-disposition

# Extract tar.gz file
tar xvf $KERNEL_FILE

# Update Rogue Enemy
sudo rpm -e rogue-enemy
sudo dnf install --assumeyes ~/Downloads/$ROGUE_ENEMY_FILE

# Change into RPM directory and install RPMs
cd RPM
sudo dnf install -y *.rpm

# Clean up file
cd ~/Downloads
rm -rf RPM
rm $KERNEL_FILE
rm $ROGUE_ENEMY_FILE

# Install asusctl package
sudo dnf install -y asusctl 

# Install decky loader
curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh | sh

# Install Corando98's Steam Patch
curl -L https://github.com/corando98/steam-patch/raw/main/install.sh | sh

# Remove rogue-enemy.service and re-create with ExecStartPre sleep of 10 seconds
sudo rm /etc/systemd/system/rogue-enemy.service

sudo bash -c 'cat << 'EOF' > /etc/systemd/system/rogue-enemy.service
[Unit]
Description=ROGueENEMY service

[Service]
Type=simple
Nice=-5
IOSchedulingClass=best-effort
IOSchedulingPriority=0
Restart=always
RestartSec=5
WorkingDirectory=/usr/bin
ExecStartPre=/bin/sleep 10
ExecStart=/usr/bin/rogue-enemy

[Install]
WantedBy=multi-user.target
EOF'

# Wifi speed improvement
echo "@nClientDownloadEnableHTTP2PlatformLinux 0" | sudo tee -a ~/.steam/steam/steam_dev.cfg > /dev/null
echo "@fDownloadRateImprovementToAddAnotherConnection 1.0" | sudo tee -a ~/.steam/steam/steam_dev.cfg > /dev/null

# Set grub order to second kernel as the curren Nobara installation uses 1 version newer than patched kernel
sudo awk 'NR==1 {$0="GRUB_DEFAULT=0"} {print}' /etc/default/grub > temp_file && sudo mv temp_file /etc/default/grub
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

# Reboot the system
read -p "Are you ready to reboot your Ally? (y/n): " ready_reboot
if [[ $ready_reboot == "y" || $ready_reboot == "Y" ]]; then
    reboot
fi