# Nobara Ally Helper
This is a simple script to simplify installation of the latest needed tools to get Nobara tuned up correctly on the ROG Ally. None of these are my patches or my work, so all credit goes to the community and the creators of these tools.

This should result in an installation with functional side and back buttons, as well as all necessary patches and optimizations for Nobara and the Gamescope interface. If you are noticing your Ally freeze when rebooting, simply reboot with it unplugged. Once it boots you can plug it back in.

## This script does a few things
1) Installs kernel 6.6.7-202 from Jlobue10 repo
2) Installs rougenemy 1.5.1-1 from Jlobue10 repo
3) Installs Deckyloader
4) Installs mengmeet's Power Control
5) Install Asusctl
6) Reboots ROG Ally

## Installation
Open a terminal and run this simple command. It will ask you for your password, then just follow the prompts and enter "y" when prompted and "1" if you are presented with any options. Once the script is done it will reboot. After reboot, your Ally is ready to rock: 
    `curl -sSL https://raw.githubusercontent.com/TaitTechMedia/nobara_ally_helper/master/install.sh | sh`

## Credit
Jlobue10 for his packaging and patching efforts for Nobara: https://github.com/jlobue10/ALLY_Nobara_fixes
NeroReflex for rouge-enemy: https://github.com/NeroReflex/ROGueENEMY
mengmeet for his Power Control deckyloader plugin: https://github.com/mengmeet/PowerControl
Corando98 for his Steam Patch fork: https://github.com/corando98/steam-patch