# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  username,
  xr-pkgs,
  ...
}:

# remove when PR is merged: https://github.com/NixOS/nixpkgs/pull/318772
#let
#  nixpkgs-klassy =
#    import (fetchTarball "https://github.com/pluiedev/nixpkgs/archive/init/klassy.tar.gz")
#      {
#        inherit (pkgs) system config;
#        overlays = [ ];
#      };
#in
{

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;
  #boot.loader.grub.memtest86.enable = true;
  boot.loader.grub.default = "saved";

  # Use latest linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # TODO: remove EDID QUIRK from patch as beyond seems to provide correct Display ID 2.0 data to the kernel
  # patch doesn't work for nvidia, so don't bother
#  boot.kernelPatches = [
#    {
#      name = "bigscreen beyond";
#      patch = ../beyondKernel.patch;
#    }
#  ];
  boot.kernelParams = [ "nvidia_drm.fbdev=1" ];

  # nix commands and flakes enabled
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # GPU driver
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    #nvidiaPersistenced = true;
    forceFullCompositionPipeline = false;
  };

  # networking.hostName = "${username}-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  #programs.home-manager.enable = true;

  #services.wayland.windowManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services = {
    pipewire = {
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
    monado = {
      enable = true;
      defaultRuntime = true;
    };
  };

  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = 1;
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
    envision.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${username}" = {
    isNormalUser = true;
    description = "Tayou";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
      thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    discord
    vesktop
    #quodlibet
    blender
    unityhub
    vlc
    kid3
    wine
    gparted
    #libsForQt5.kpmcore # For kde partition manager, as it seems to be missing this dependency
    partition-manager
    htop
    gnome-disk-utility
    smartmontools
    sl
    lolcat
    xwayland
    jetbrains.rider
    jetbrains.clion
    jetbrains.goland
    jetbrains.webstorm
    jetbrains.rust-rover
    jetbrains.idea-ultimate
    jetbrains.pycharm-professional
    prismlauncher-unwrapped
    lightly-boehs
    gimp
    inkscape
    krita
    libreoffice
    fastfetch
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-mono
    hyfetch
    git
    gitkraken
    fuse3
    obsidian
    filelight
    superTux
    superTuxKart
    extremetuxracer
    pciutils
    opencomposite
    qpwgraph
    obs-studio
    # for plasma desktop info center
    glxinfo
    vulkan-tools
    clinfo
    wayland-utils
    # end
    chromium
    gcc
    gpp
    nixd
    protonup-qt
    kicad
    gamemode
    lutris
    #xr-pkgs.wlxoverlay-s

    # update when PR is merged: https://github.com/NixOS/nixpkgs/pull/318772
    #nixpkgs-klassy.klassy

  ];

#  nixpkgs.config.permittedInsecurePackages = with pkgs; [
#    "electron-25.9.0"
#  ];

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
  system.stateVersion = "23.11"; # Did you read the comment?
}
