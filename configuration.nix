# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "NixPad"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Bluetooth stuff
  hardware.bluetooth.enable = true;
  # services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs.gnome; [
    pkgs.epiphany # web browser
    pkgs.totem # video player
    pkgs.geary # email client
    pkgs.gnome-contacts
    pkgs.gnome-maps
    pkgs.gnome-console
  ];

  # Enable the gnome-keyring secrets vault. 
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  # enable Sway window manager
  # programs.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true;
  # };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # AppImage
  # programs.appimage.enable = true;
  # programs.appimage.binfmt = true;

  # Configure console keymap
  console.keyMap = "uk";

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
  users.users.pebble = {
    isNormalUser = true;
    description = "Pebble";
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxusers" "libvirtd" ];
    packages = with pkgs; [
      # Regular Packages
      thunderbird
      vesktop
      gimp3
      krita
      vlc
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
          bbenoist.nix
          ms-python.python
          llvm-vs-code-extensions.vscode-clangd
          ms-vscode.cpptools
          zainchen.json
          formulahendry.code-runner
        ];
      })
      spotify
      gnome-boxes
      classicube
      rogue
      kdePackages.kdenlive
      tor-browser
      teams-for-linux
      # brightnessctl
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # XWayland
  # programs.xwayland.enable = true;

  # xdg-desktop-portal stuffs
  # programs.xdg-desktop-portal.enable = true;
  # programs.xdg-desktop-portal-gtk.enable = true;
  # programs.xdg-desktop-portal-wlr.enable = true;

  # Thunar Stuffs
  # programs.thunar.enable = true;
  # programs.xfconf.enable = true;

  # programs.thunar.plugins = with pkgs.xfce; [
  #   thunar-archive-plugin # Requires an Archive manager like file-roller, ark, etc
  #   thunar-volman
  # ];

  # services.gvfs.enable = true; # Mount, trash, and other functionalities
  # services.tumbler.enable = true; # Thumbnail support for images


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    fastfetch
    cmatrix
    python3
    htop
    mc
    cmatrix
    git
    gcc
    alacritty
    gnome-tweaks
    distcc
    # grim
    # slurp
    # wl-clipboard
    # mako
    network-manager-applet
    # i3status
    # xdg-desktop-portal
    # xdg-desktop-portal-gtk
    # xdg-desktop-portal-wlr
  ];

  # Steam Stuff
  programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.steam.gamescopeSession.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Power Management stuff
  services.logind.lidSwitch = "suspend";
  services.logind.lidSwitchExternalPower = "lock";
  services.logind.lidSwitchDocked = "ignore";

  powerManagement.enable = true;
  services.thermald.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 50;

      # Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80;  # 80 and above it stops charging
    };
  };

  powerManagement.powertop.enable = true;

  services.power-profiles-daemon.enable = false;

  # List services that you want to enable:
  # services.flatpak.enable = true;

  # Virtualisationstuffs
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Experimental stuffs
  #### nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  ## services.xserver.videoDrivers = ["nvidia"];

  ## hardware.nvidia = {

    # Modesetting is required.
    ## modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    ## powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    ## powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    ## open = false;

    # Enable the Nvidia settings menu,
    ## nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    ## package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

}

