#!/bin/bash

# Specifies which kernel and rogue-enemy version to download
KERNEL_URL="https://github.com/jlobue10/ALLY_Nobara_fixes/releases/download/v2.5.0/kernel-6.7.0-201.fsync.ally.fc39.x86_64.tar.gz"
ROGUE_ENEMY_URL="https://github.com/jlobue10/ALLY_Nobara_fixes/releases/download/v2.5.0/rogue-enemy-2.2.1-1.fc39.x86_64.rpm"
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

# User prompt for choosing the application to install
echo "Select the application to install:"
echo "1. HDD"
echo "2. Rogue Enemy"
echo "3. Neither"
read -p "Enter your choice (1, 2, or 3): " app_choice

# Change to Downloads directory
cd ~/Downloads

# Install decky loader
curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh | sh

# Execution based on user choice
case $app_choice in
    1)
        sudo dnf remove rogue-enemy -y || {
        echo "Rogue Enemy was not installed or failed to uninstall."
    }
        curl -L https://github.com/hhd-dev/hhd/raw/master/install.sh | sh
        curl -L https://github.com/hhd-dev/hhd-decky/raw/main/install.sh | sh
        ;;
    2)
        wget $ROGUE_ENEMY_URL --content-disposition
        sudo curl -L https://github.com/hhd-dev/hhd/raw/master/uninstall.sh | sh || {
        echo "HHD was not installed as it was not on your system."
    }
        sudo dnf install --assumeyes ~/Downloads/$ROGUE_ENEMY_FILE
        sudo systemctl start rogue-enemy.service
        sudo systemctl enable rogue-enemy.service
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
        default_thermal_profile = 1;
        enable_leds_commands = true;" | sudo tee /etc/ROGueENEMY/config.cfg > /dev/null
        sudo systemctl restart rogue-enemy.service
        rm $ROGUE_ENEMY_FILE
        ;;
    3)
        echo "Skipping installation of HDD and Rogue Enemy."
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

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

sudo systemctl disable steam-patch

# KDE Virtual Keyboard Fix
mkdir -p ~/.config/plasma_mobile-workspace/env/
echo -e '#!/bin/bash\nunset GTK_IM_MODULE\nunset QT_IM_MODULE' | sudo tee ~/.config/plasma_mobile-workspace/env/immodule_temp_fix.sh
sudo chmod +x ~/.config/plasma_mobile-workspace/env/immodule_temp_fix.sh
bash ~/.config/plasma_mobile-workspace/env/immodule_temp_fix.sh

# Fix power key not triggering sleep
if [ -e "/etc/systemd/logind.conf" ]; then
    sudo sed -i 's/^#HandlePowerKey=poweroff.*/HandlePowerKey=suspend/' /etc/systemd/logind.conf
    echo "HandlePowerKey updated to 'suspend'"
else
    echo "The configuration file '/etc/systemd/logind.conf' does not exist."
fi

# Fingerprint sensor power drain issue fix
sudo bash -c 'echo "ACTION==\"add\", SUBSYSTEM==\"usb\", TEST==\"power/control\", ATTR{idVendor}==\"1c7a\", ATTR{idProduct}==\"0588\", ATTR{power/control}=\"auto\"" > /etc/udev/rules.d/50-fingerprint.rules'

# Set grub order to proper kernel as the curren Nobara installation uses 1 version newer than patched kernel
sudo awk 'NR==1 {$0="GRUB_DEFAULT=1"} {print}' /etc/default/grub > temp_file && sudo mv temp_file /etc/default/grub
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

# Reboot the system
read -p "Are you ready to reboot your Ally? (y/n): " ready_reboot
if [[ $ready_reboot == "y" || $ready_reboot == "Y" ]]; then
    reboot
fi