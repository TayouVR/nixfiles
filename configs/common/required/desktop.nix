{
  pkgs,
  ...
}:

{
  config = {
    # Enable the X11 windowing system
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Enable Wayland support
    environment.sessionVariables = {
      NIXOS_OZONE_WL = 1;
    };

    # Common desktop packages
    environment.systemPackages = with pkgs; [
      kdePackages.sddm-kcm # sddm configuration in kde settings
      kdePackages.sddm

      # File management
      kdePackages.kate
      kdePackages.filelight
      kdePackages.partitionmanager
      kdePackages.calligra
      kdePackages.kdiagram
      gparted
      gnome-disk-utility

      # Remote desktop
      kdePackages.krdc
      kdePackages.krdp
      freerdp3

      # Office and productivity
      libreoffice
      obsidian

      # Graphics and media
      gimp
      inkscape
      krita
      vlc
      obs-studio

      # System utilities
      htop
      smartmontools
      pciutils
      xwayland

      # For plasma desktop info center
      glxinfo
      vulkan-tools
      clinfo
      wayland-utils
    ];
  };
}
