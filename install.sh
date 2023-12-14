#!/bin/bash

# Specifies which kernel and rogue-enemy version to download
KERNEL_FILE="kernel-6.6.6-200.fsync.ally.fc38.x86_64.tar.gz"
KERNEL_URL="https://github.com/jlobue10/ALLY_Nobara_fixes/releases/download/v2.2.0/kernel-6.6.6-200.fsync.ally.fc38.x86_64.tar.gz"
ROGUE_ENEMY_FILE="rogue-enemy-1.5.1-1.fc38.x86_64.rpm"
ROGUE_ENEMY_URL="https://github.com/jlobue10/ALLY_Nobara_fixes/releases/download/v2.2.0/rogue-enemy-1.5.1-1.fc38.x86_64.rpm"

# Obtain elevated privileges
sudo -v

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

# Download Corando98's Steam Patch install script
curl -L -o steam-patch-install.sh https://github.com/corando98/steam-patch/raw/main/install.sh
chmod +x steam-patch-install.sh

# Use expect to run the Steam Patch install script
set timeout -1  # Wait indefinitely for a prompt
# This loop will match any output and respond with Enter
expect {
    -re .* { send "\r"; exp_continue }
}
EOF

# Install asusctl package
sudo dnf install -y asusctl 

# Clean up files
cd ~/Downloads
rm -rf RPM
rm $KERNEL_FILE
rm $ROGUE_ENEMY_FILE

# Reboot the system
reboot