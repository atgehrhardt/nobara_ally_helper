# Nobara Ally Helper
This is a simple script to simplify installation of the latest needed tools to get Nobara tuned up correctly on the ROG Ally. None of these are my patches or my work, so all credit goes to the community and the creators of these tools.

This should result in an installation with functional side and back buttons, as well as all necessary patches and optimizations for Nobara and the Gamescope interface. If you are noticing your Ally freeze when rebooting, simply reboot with it unplugged. Once it boots you can plug it back in.

## This script does a few things
1) ~~Installs kernel 6.7.0-204 from Jlobue10 repo~~
2) Installs HHD or rougenemy 2.2.1-1 from Jlobue10 repo
3) Installs Deckyloader and DeckySimpleTDP
4) Installs Asusctl
5) Installs Extest - WIP
6) Reboots ROG Ally

## Installation
Open a terminal and run this command. It will ask you for your password.
    `bash <(curl -sSL https://raw.githubusercontent.com/TaitTechMedia/nobara_ally_helper/master/install.sh)`

***IMPORTANT:*** *If you do not have back padals working (You see a DualShock 4 and NOT a DualSense controller in Steam), simply switch to desktop mode, restart the device, and then switch back to game mode and it will show up correctly. You should only ever have to do this if your system dies or you do a full restart.*

# Note about SimpleDeckyTDP
SET THE TDP LIMITS IN SIMPLEDECKYTDP THEN CHECK THE OPTION: "Fix Steam Hardware Controls".
- Doing this will allow you to utilize the built in TDP slider as normal

I highly recommend activating the TDP limit and setting it to 11 watts outside of games as this will provide a very smooth experience with extremely low wattage. If you leave the wattage uncapped, the governor, even on powersave or balanced mode will tend to use maximum wattage. Implementing an 11 watt limit solves this problem nicely and doesn't affect games as you can always set a different wattage per game.

Additionally set the lower limit to 11 watts and upper limit to 30 watts. I would REALLY not recommend going above 30 watts as this has the
potential to cause permenant damage.

# Note about refresh rate and VRR
If you only see 60hz, you need to go into Settings > Display > Enable Unified Frame Limit Management and disable this (it's at the very bottom
of the menu).

Once done you can set the refresh rate to 120hz (if this doesn't happen automatically). You should also go ahead and enable VRR now as well.

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

## Reference
Jlobue10 for his packaging and patching efforts for Nobara: https://github.com/jlobue10/ALLY_Nobara_fixes
hhd-dev for HHD: https://github.com/hhd-dev/hhd
NeroReflex for rouge-enemy: https://github.com/NeroReflex/ROGueENEMY
Corando98 for his Steam Patch fork: https://github.com/corando98/steam-patch
Supreeeme for his Extest tool: https://github.com/Supreeeme/extest