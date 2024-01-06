#!/bin/bash

# Specifies which kernel and rogue-enemy version to download
KERNEL_URL="https://github.com/jlobue10/ALLY_Nobara_fixes/releases/download/v2.4.0/kernel-6.6.10-200.fsync.ally.fc39.x86_64.tar.gz"
ROGUE_ENEMY_URL="https://github.com/jlobue10/ALLY_Nobara_fixes/releases/download/v2.4.0/rogue-enemy-1.5.4-1.fc39.x86_64.rpm"
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

# Optional install of auto-cpu freq set variable
echo "OPTIONAL INSTALL: THIS HAS THE POTENTIAL TO CAUSE DAMAGE TO YOUR DEVICE"
echo "If you do not know whether to install this or not, please select N, this is for advanced users."
echo " "
echo "wo you want to install auto-cpu freq? This tool will override certain controls associated with Power Control."
echo "wf you enable this tool, please do not adjust any of the Power Control specific settings in Decky Loader."
echo "we still install Power Control as this unlocks the full TDP slider in GameScope which you CAN still use, however,"
echo "it is highly recommended to NOT install this package if you intend to use Power Control"
read -p "Do you want to install this package? (y/n): " auto_cpu_freq

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

# Check the user input for auto-cpu freq install
if [[ $auto_cpu_freq == "y" || $auto_cpu_freq == "Y" ]]; then
    cd ~/Downloads
    git clone https://github.com/AdnanHodzic/auto-cpufreq.git
    cd auto-cpufreq && sudo ./auto-cpufreq-installer
    rm ~/Downloads/auto-cpufreq
    sudo cpu-autofreq --install
fi

# Wifi speed improvement
echo "@nClientDownloadEnableHTTP2PlatformLinux 0" | sudo tee -a ~/.steam/steam/steam_dev.cfg > /dev/null
echo "@fDownloadRateImprovementToAddAnotherConnection 1.0" | sudo tee -a ~/.steam/steam/steam_dev.cfg > /dev/null

# KDE Virtual Keyboard Fix
mkdir -p ~/.config/plasma_mobile-workspace/env/ && echo -e '#!/bin/bash\nunset GTK_IM_MODULE\nunset QT_IM_MODULE' > ~/.config/plasma_mobile-workspace/env/immodule_temp_fix.sh && chmod +x ~/.config/plasma_mobile-workspace/env/immodule_temp_fix.sh && sh ~/.config/plasma_mobile-workspace/env/immodule_temp_fix.sh

# Fingerprint sensor power drain issue fix
sudo bash -c 'echo "ACTION==\"add\", SUBSYSTEM==\"usb\", TEST==\"power/control\", ATTR{idVendor}==\"1c7a\", ATTR{idProduct}==\"0588\", ATTR{power/control}=\"auto\"" > /etc/udev/rules.d/50-fingerprint.rules'

# Fix power key not triggering sleep
if [ -e "/etc/systemd/logind.conf.d/00-handheld-power.conf" ]; then
    sudo sed -i 's/^HandlePowerKey=.*/HandlePowerKey=suspend/' /etc/systemd/logind.conf.d/00-handheld-power.conf
    echo "HandlePowerKey updated to 'suspend'"
else
    echo "The configuration file '/etc/systemd/logind.conf.d/00-handheld-power.conf' does not exist."
fi

# Set grub order to proper kernel as the curren Nobara installation uses 1 version newer than patched kernel
sudo awk 'NR==1 {$0="GRUB_DEFAULT=0"} {print}' /etc/default/grub > temp_file && sudo mv temp_file /etc/default/grub
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

# Reboot the system
read -p "Are you ready to reboot your Ally? (y/n): " ready_reboot
if [[ $ready_reboot == "y" || $ready_reboot == "Y" ]]; then
    reboot
fi