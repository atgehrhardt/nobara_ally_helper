# Nobara Ally Helper
This is a simple script to simplify installation of the latest needed tools to get Nobara tuned up correctly on the ROG Ally. None of these are my patches or my work, so all credit goes to the community and the creators of these tools.

This should result in an installation with functional side and back buttons, as well as all necessary patches and optimizations for Nobara and the Gamescope interface.

## This script does a few things
1) wgets kernel 6.6.4-205 from Jlobue10 repo
2) wgets rougenemy 1.5 from Jlobue10 repo
3) Installs Corando98's Steam Patch
4) Install Asusctl
5) Reboots ROG Ally

## Installation
Open a terminal and run this simple command. It will ask you for your password, then just sit back for a few minutes. After reboot, your Ally is ready to rock: 
    `curl -sSL https://raw.githubusercontent.com/TaitTechMedia/nobara_ally_helper/master/install.sh | sh`

## Credit
Jlobue10 for his packaging and patching efforts for Nobara: https://github.com/jlobue10/ALLY_Nobara_fixes
NeroReflex for rouge-enemy: https://github.com/NeroReflex/ROGueENEMY
orando98 for his Steam Patch fork: https://github.com/corando98/steam-patch