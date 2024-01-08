#!/bin/bash

# Specifies which kernel and rogue-enemy version to download
KERNEL_URL="https://github.com/jlobue10/ALLY_Nobara_fixes/releases/download/v2.4.0/kernel-6.6.10-200.fsync.ally.fc39.x86_64.tar.gz"
ROGUE_ENEMY_URL="https://github.com/jlobue10/ALLY_Nobara_fixes/releases/download/v2.4.0/rogue-enemy-2.1.1-1.fc39.x86_64.rpm"
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

# Start & Enable Rogue Enemy Service
sudo systemctl start rogue-enemy.service
sudo systemctl enable rogue-enemy.service

# Adjust Rogue Enemy config to use Dualsense Edge (to enable back paddles)
echo "enable_qam = true;
ff_gain = 255;
nintendo_layout = false;
default_gamepad = 1;
rumble_on_mode_switch = true;
gamepad_rumble_control = true;
gamepad_leds_control = true;
m1m2_mode = 0;
gyro_to_analog_mapping = 5;
gyro_to_analog_activation_treshold = 1;
touchbar = false;
controller_bluetooth = true;
dualsense_edge = true;
swap_y_z = true;
enable_thermal_profiles_switching = true;
default_thermal_profile = -1;
enable_leds_commands = true;" | sudo tee /etc/ROGueENEMY/config.cfg > /dev/null

sudo systemctl restart rogue-enemy.service

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

# Install SimpleDeckyTDP
curl -L https://github.com/aarron-lee/SimpleDeckyTDP/raw/main/install.sh | sh

# Wifi speed improvement
echo "@nClientDownloadEnableHTTP2PlatformLinux 0" | sudo tee -a ~/.steam/steam/steam_dev.cfg > /dev/null
echo "@fDownloadRateImprovementToAddAnotherConnection 1.0" | sudo tee -a ~/.steam/steam/steam_dev.cfg > /dev/null

# KDE Virtual Keyboard Fix
sudo mkdir -p ~/.config/plasma_mobile-workspace/env/ && sudo echo -e '#!/bin/bash\nunset GTK_IM_MODULE\nunset QT_IM_MODULE' > ~/.config/plasma_mobile-workspace/env/immodule_temp_fix.sh && sudo chmod +x ~/.config/plasma_mobile-workspace/env/immodule_temp_fix.sh && sudo sh ~/.config/plasma_mobile-workspace/env/immodule_temp_fix.sh

# Fingerprint sensor power drain issue fix
sudo bash -c 'echo "ACTION==\"add\", SUBSYSTEM==\"usb\", TEST==\"power/control\", ATTR{idVendor}==\"1c7a\", ATTR{idProduct}==\"0588\", ATTR{power/control}=\"auto\"" > /etc/udev/rules.d/50-fingerprint.rules'

if [ -e "/etc/systemd/logind.conf" ]; then
    # Update HandlePowerKey line whether it's commented or not, regardless of the following value
    sudo sed -i 's/^#\?HandlePowerKey=.*/HandlePowerKey=suspend-then-hibernate/' /etc/systemd/logind.conf
    echo "HandlePowerKey updated to 'suspend-then-hibernate'"

    # Check if 'Sleep=suspend-then-hibernate' and 'HibernateDelaySec=3h' already exist
    if ! grep -q "Sleep=suspend-then-hibernate" /etc/systemd/logind.conf; then
        if ! grep -q "HibernateDelaySec=3h" /etc/systemd/logind.conf; then
            # Add sleep-to-hibernate functionality
            sudo awk '/^\[Login\]/{print; print "Sleep=suspend-then-hibernate"; print "HibernateDelaySec=3h"; next}1' /etc/systemd/logind.conf > temp.txt && sudo mv temp.txt /etc/systemd/logind.conf
            echo "Added 'Sleep=suspend-then-hibernate' and 'HibernateDelaySec=3h' under [Login]"
        else
            echo "'HibernateDelaySec=15s' already set, not adding."
        fi
    else
        echo "'Sleep=suspend-then-hibernate' already set, not adding."
    fi

else
    echo "The configuration file '/etc/systemd/logind.conf' does not exist."
fi

# Set grub order to proper kernel as the curren Nobara installation uses 1 version newer than patched kernel
sudo awk 'NR==1 {$0="GRUB_DEFAULT=0"} {print}' /etc/default/grub > temp_file && sudo mv temp_file /etc/default/grub
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

# Reboot the system
read -p "Are you ready to reboot your Ally? (y/n): " ready_reboot
if [[ $ready_reboot == "y" || $ready_reboot == "Y" ]]; then
    reboot
fi