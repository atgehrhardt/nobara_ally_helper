# Nobara Ally Helper
This is a simple script to simplify installation of the latest needed tools to get Nobara tuned up correctly on the ROG Ally. None of these are my patches or my work, so all credit goes to the community and the creators of these tools.

This should result in an installation with functional side and back buttons, as well as all necessary patches and optimizations for Nobara and the Gamescope interface. If you are noticing your Ally freeze when rebooting, simply reboot with it unplugged. Once it boots you can plug it back in.

# Note about TDP
I highly recommend activating the TDP limit and setting it to 11 watts outside of games as this will provide a very smooth experience with extremely low wattage. If you leave the wattage uncapped, the governor, even on powersave or balanced mode will tend to use maximum wattage. Implementing an 11 watt limit solves this problem nicely and doesn't affect games as you can always set a different wattage per game.

# Note about Rogue Enemy
This tool configures Rogue Enemy to utilize custom settings which:
1) Enable the back paddles
2) Disable touch bar emulation

This should work in most games, but can cause issues in certain games (we believe Sony ports). If you would like to revert to the defsult 
settings which emulate the touch bar and map the back paddles to touch bar presses (this should work with ALL games), simply run the below 
command. THIS IS ALL ONE SINGLE COMMAND; COPY AND PASTE THE ENTIRE THING:

```
echo "enable_qam = true;
ff_gain = 255;
nintendo_layout = false;
default_gamepad = 1;
rumble_on_mode_switch = true;
gamepad_rumble_control = true;
gamepad_leds_control = true;
m1m2_mode = 1;
gyro_to_analog_mapping = 5;
gyro_to_analog_activation_treshold = 1;
touchbar = true;
controller_bluetooth = true;
dualsense_edge = false;
swap_y_z = true;
enable_thermal_profiles_switching = true;
default_thermal_profile = -1;
enable_leds_commands = true;" | sudo tee /etc/ROGueENEMY/config.cfg > /dev/null && sudo systemctl restart rogue-enemy.service
```

***IMPORTANT*** 
Rogue Enemy 2 may not install due to missing dependencies if your system is not up to date. If you run into this UPDATE YOUR SYSTEM. If you want an
easy way to update to Nobara 39 you can run this script: `curl -sSL https://raw.githubusercontent.com/TaitTechMedia/nobara_ally_helper/master/upgrade_39.sh`

## This script does a few things
1) Installs kernel 6.6.10-200 from Jlobue10 repo
2) Installs rougenemy 2.1.1-1 from Jlobue10 repo
3) Installs Deckyloader
4) Install Asusctl
5) Reboots ROG Ally

## Installation
Open a terminal and run this simple command. It will ask you for your password. Enter this and press 'enter'. It is normal that you do not see your password while typing.
    `bash <(curl -sSL https://raw.githubusercontent.com/TaitTechMedia/nobara_ally_helper/master/install.sh)`

***IMPORTANT:*** *If you do not have back padals working (You see a DualShock 4 and NOT a DualSense controller in Steam), simply switch to desktop mode, restart the device, and then switch back to game mode and it will show up correctly. You should only ever have to do this if your system dies or you do a full restart.*

## Reference
Jlobue10 for his packaging and patching efforts for Nobara: https://github.com/jlobue10/ALLY_Nobara_fixes
NeroReflex for rouge-enemy: https://github.com/NeroReflex/ROGueENEMY
Corando98 for his Steam Patch fork: https://github.com/corando98/steam-patch