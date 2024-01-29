#!/bin/bash

# Specifies which kernel and rogue-enemy version to download
KERNEL_URL="https://github.com/jlobue10/ALLY_Nobara_fixes/releases/download/v2.5.0/kernel-6.7.2-200.fsync.ally.fc39.x86_64.tar.gz"
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

# Change to Downloads directory
cd ~/Downloads

# Install decky loader
curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh | sh

# Install HHD
curl -L https://github.com/hhd-dev/hhd/raw/master/install.sh | sh
curl -L https://github.com/hhd-dev/hhd-decky/raw/main/install.sh | sh

# Download and extract kernel
wget $KERNEL_URL --content-disposition
tar xvf $KERNEL_FILE

# Change into RPM directory and install RPMs
cd RPM
sudo dnf install -y *.rpm

# Clean up file
cd ~/Downloads
rm -rf RPM
rm $KERNEL_FILE

# Install asusctl package
sudo dnf install -y asusctl 

# Install SimpleDeckyTDP
curl -L https://github.com/aarron-lee/SimpleDeckyTDP/raw/main/install.sh | sh

# KDE Virtual Keyboard Fix
mkdir -p ~/.config/plasma_mobile-workspace/env/
echo -e '#!/bin/bash\nunset GTK_IM_MODULE\nunset QT_IM_MODULE' | sudo tee ~/.config/plasma_mobile-workspace/env/immodule_temp_fix.sh
sudo chmod +x ~/.config/plasma_mobile-workspace/env/immodule_temp_fix.sh
bash ~/.config/plasma_mobile-workspace/env/immodule_temp_fix.sh

# Fingerprint sensor power drain issue fix
sudo bash -c 'echo "ACTION==\"add\", SUBSYSTEM==\"usb\", TEST==\"power/control\", ATTR{idVendor}==\"1c7a\", ATTR{idProduct}==\"0588\", ATTR{power/control}=\"auto\"" > /etc/udev/rules.d/50-fingerprint.rules'

# Set grub order to proper kernel as the curren Nobara installation uses 1 version newer than patched kernel
sudo awk 'NR==1 {$0="GRUB_DEFAULT=0"} {print}' /etc/default/grub > temp_file && sudo mv temp_file /etc/default/grub
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

# Reboot the system
read -p "Are you ready to reboot your Ally? (y/n): " ready_reboot
if [[ $ready_reboot == "y" || $ready_reboot == "Y" ]]; then
    reboot
fi