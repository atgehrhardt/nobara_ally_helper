#!/bin/bash
sudo -v

# Change to Downloads directory
cd ~/Downloads

# Download files using wget
wget https://github.com/jlobue10/ALLY_Nobara_fixes/releases/download/v2.1.0/kernel-6.6.4-205.fsync.ally.fc38.x86_64.tar.gz --content-disposition
wget https://github.com/jlobue10/ALLY_Nobara_fixes/releases/download/v2.1.0/rogue-enemy-1.5.0-1.fc38.x86_64.rpm --content-disposition

# Extract tar.gz file
tar xvf kernel-6.6.4-205.fsync.ally.fc38.x86_64.tar.gz

# Move rogue-enemy into RPM directory
mv rogue-enemy-1.5.0-1.fc38.x86_64.rpm RPM/rogue-enemy-1.5.0-1.fc38.x86_64.rpm

# Change into RPM directory and install RPMs
cd RPM
sudo dnf install *.rpm

# Install Corando98's Steam Patch fork
curl -L https://github.com/corando98/steam-patch/raw/main/install.sh | sh

# Install asusctl package
sudo dnf install asusctl

# Reboot the system
reboot
