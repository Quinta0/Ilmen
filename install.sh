#!/usr/bin/env bash

set -e

echo "=== Installing Ilmen for NixOS ==="

echo "1) Copying configuration.nix to /etc/nixos/ ..."
sudo cp ./configuration.nix /etc/nixos/configuration.nix

echo "2) Applying system configuration (this may take a while)..."
sudo nixos-rebuild switch

echo "3) Setting up user directories..."
mkdir -p ~/.config/quickshell/ii
mkdir -p ~/.config/illogical-impulse

echo "4) Copying Quickshell and Dotfiles data..."
cp -r ./* ~/.config/quickshell/ii/

# Copy all the extra user dotfiles and configs (like kitty, niri, kvantum, etc)
if [ -d "dots/.config" ]; then
    cp -r dots/.config/* ~/.config/
fi

mkdir -p ~/.config/illogical-impulse
cp ./defaults/config.json ~/.config/illogical-impulse/config.json

echo "Done! You maps may require a reboot or log out to take effect."
echo "If Quickshell complains about missing values, restart it."
