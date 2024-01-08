#!/bin/bash

# Obtain elevated priviledges
password=$(kdialog --password "Enter your sudo password")

if [ -z "$password" ]; then
    kdialog --error "No password entered. Exiting."
    exit 1
fi

# Install compilation dependencies
sudo dnf update
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo dnf groupinstall "Development Tools"
sudo dnf install glibc-static