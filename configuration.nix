# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos> 
    ];

  programs.hyprland.enable = true;
  programs.niri.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ch";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "sg";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.quinta = {
    isNormalUser = true;
    description = "Pietro Quintavalle";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      thunderbird
      vscode
      git
      obsidian
      kitty
      fastfetch      
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    networkmanagerapplet
    niri
    kdePackages.qwt
    
    # Core dependencies for iNiR/Quickshell
    bc coreutils cliphist curl ripgrep jq python311 python311Packages.pillow python311Packages.evdev 
    xdg-user-dirs xdg-utils rsync wl-clipboard libnotify wlsunset 
    wireplumber playerctl pavucontrol mpv yt-dlp socat cava easyeffects
    grim slurp swappy tesseract wf-recorder imagemagick ffmpeg
    wtype ydotool brightnessctl ddcutil geoclue2 swayidle swaylock blueman fprintd libqalculate
    fuzzel glib translate-shell libsForQt5.qtstyleplugin-kvantum matugen qt6Packages.qt6ct
        xwayland-satellite gum foot papirus-icon-theme kdePackages.breeze-icons adwaita-icon-theme
    
    (pkgs.symlinkJoin {
      name = "quickshell-with-qml";
      paths = [ pkgs.quickshell ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/quickshell \
          --run 'ulimit -s 65536' \
          --prefix QML2_IMPORT_PATH : "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml:${pkgs.kdePackages.syntax-highlighting}/lib/qt-6/qml" \
          --prefix NIXPKGS_QT6_QML_IMPORT_PATH : "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml:${pkgs.kdePackages.syntax-highlighting}/lib/qt-6/qml" \
          --prefix PATH : "${pkgs.lib.makeBinPath [ pkgs.coreutils pkgs.findutils pkgs.procps pkgs.curl pkgs.gawk pkgs.imagemagick pkgs.socat pkgs.glib pkgs.fish pkgs.mpv pkgs.yt-dlp ]}"
          
        ln -sf $out/bin/quickshell $out/bin/qs
      '';
    })
    
    # Qt6 and KDE packages
    qt6.qtdeclarative qt6.qtbase qt6.qtsvg qt6.qtwayland qt6.qt5compat qt6.qtimageformats 
    qt6.qtmultimedia qt6.qtpositioning qt6.qtquicktimeline qt6.qtsensors qt6.qttools 
    qt6.qttranslations qt6.qtvirtualkeyboard
    kdePackages.kirigami kdePackages.kdialog kdePackages.breeze-icons kdePackages.plasma-integration
    # kdePackages.knewstuff kdePackages.kdeclarative kdePackages.kconfig
  ];

  # Fonts
  fonts.packages = with pkgs; [
    fontconfig dejavu_fonts liberation_ttf nerd-fonts.jetbrains-mono material-symbols roboto-flex
    rubik twemoji-color-font capitaine-cursors
  ];

  programs.fish.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.upower.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  
  environment.variables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_STYLE_OVERRIDE = "kvantum";
  };
  system.stateVersion = "25.11"; # Did you read the comment?
  
  home-manager.users.quinta = { pkgs, ... }: {
   home.packages = [ pkgs.atool pkgs.httpie ];
   programs.bash.enable = true;

   # This value determines the Home Manager release that your configuration is
   # compatible with. This helps avoid breakage when a new Home Manager release
   # introduces backwards incompatible changes.
   #
   # You should not change this value, even if you update Home Manager. If you do
   # want to update the value, then make sure to first check the Home Manager
   # release notes.
   home.stateVersion = "25.11"; # Please read the comment before changing. 
   
   home.enableNixpkgsReleaseCheck = false;

  };

}
