# Nobara Ally Helper
This is a simple script to simplify installation of the latest needed tools to get Nobara tuned up correctly on the ROG Ally. None of these are my patches or my work, so all credit goes to the community and the creators of these tools.

This should result in an installation with functional side and back buttons, as well as all necessary patches and optimizations for Nobara and the Gamescope interface. If you are noticing your Ally freeze when rebooting, simply reboot with it unplugged. Once it boots you can plug it back in.

## This script does a few things
1) Installs kernel 6.6.7-202 from Jlobue10 repo
2) Installs rougenemy 1.5.1-1 from Jlobue10 repo
3) Adjusts rogue-enemy.service to add a 15 second delay to allow MCU to initialize properly
4) Installs Deckyloader
5) Installs mengmeet's Power Control
6) Install Asusctl
7) Optionally install auto-cpufreq
8) Reboots ROG Ally

## Installation
Open a terminal and run this simple command. It will ask you for your password. Enter this and press 'enter'. It is normal that you do not see your password while typing.
    `bash <(curl -sSL https://raw.githubusercontent.com/TaitTechMedia/nobara_ally_helper/master/install.sh)`

***IMPORTANT:*** *If you do not have back padals working (You see a DualShock 4 and NOT a DualSense controller in Steam), simply switch to desktop mode and then back to game mode and it will show up correctly. You should only ever have to do this if your system dies or you do a full restart.*

## Credit
Jlobue10 for his packaging and patching efforts for Nobara: https://github.com/jlobue10/ALLY_Nobara_fixes
NeroReflex for rouge-enemy: https://github.com/NeroReflex/ROGueENEMY
mengmeet for his Power Control deckyloader plugin: https://github.com/mengmeet/PowerControl
Corando98 for his Steam Patch fork: https://github.com/corando98/steam-patch