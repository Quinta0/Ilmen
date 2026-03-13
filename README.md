# Ilmen (NixOS Edition)

A beautifully adapted Wayland desktop UI for **NixOS**, originally predicated on **Quickshell** and **Niri**. 
This repository contains a full Declarative system configuration and a clean, responsive desktop shell tailored precisely for NixOS users.

## ✨ Features
- **NixOS Native System Build**: `configuration.nix` is fully patched to pull down Quickshell, necessary QML modules, Wayland components, fonts, and icon packs.
- **Dynamic Styling**: Integrated with Qt6, Kvantum, and standard Icon themes.
- **Clean Interface**: Adjusted search bars, auto-hiding dock, fixed `kill` binds, and removed legacy Arch-based clunkiness.
- **Persistent Wi-Fi**: Proper initialization of NetworkManager without needing `sudo`.

## 🚀 Installation 

Make sure you're on a fresh or configurable NixOS machine. We provide a 1-step installation script that:
1. Replaces your `/etc/nixos/configuration.nix` with the curated Ilmen config.
2. Runs a `nixos-rebuild switch`.
3. Copies all necessary Quickshell module/component files directly to your user folder (`~/.config/quickshell/ii`).

```bash
git clone https://github.com/Quinta0/Ilmen.git
cd Ilmen
chmod +x install.sh
./install.sh
```

*(Warning: Running the script will overwrite `/etc/nixos/configuration.nix`. Please back it up if you want to keep your existing hardware configuration and modularize it instead!).*

After the installation completes:
Reboot to let the Qt-Themes, Environment variables, and Nix overlays establish themselves cleanly!

---
*Derived originally from "iNiR" and extensively modified to work cleanly via Declarative config.*
