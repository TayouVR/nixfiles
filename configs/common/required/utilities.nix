{
  pkgs,
  ...
}:

{
  config = {
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji

        twemoji-color-font

        # monospace
        nerd-fonts.jetbrains-mono
        nerd-fonts.caskaydia-mono
      ];

#      fontconfig = {
#        defaultFonts = {
#          serif = [ "Noto Serif" "Liberation Serif" "Vazirmatn" ];
#          sansSerif = [ "Noto Sans" "Ubuntu" "Vazirmatn" ];
#          monospace = [ "CaskaydiaMono Nerd Font Mono" "CaskaydiaCove Nerd Font" "CaskaydiaMono NF" ];
#        };
#      };
    };

    # System utilities
    environment.systemPackages = with pkgs; [
      # System information and monitoring
      fastfetch
      hyfetch

      # Fun utilities
      sl
      lolcat

      # File management
      fuse3 # was this for AppImage? Not sure...

      # Hardware utilities
      pciutils

      # System management
      home-manager

      # Diagramming
      dia

      # Custom packages
      # update when PR is merged: https://github.com/NixOS/nixpkgs/pull/318772
      #local.klassy

      darkly

      obsidian
      nextcloud-client

      freecad-qt6

      scrcpy
      qtscrcpy

      just
      nvtopPackages.amd
      btop
      lact
      corectrl

      tailscale
      #sweethome3d

      # telephony
      twinkle

      # 3D printing
      #cura # build failure due to broken python dependency
      prusa-slicer
      #orca-slicer # build failure due to old libsoup dependency

      kdePackages.discover
      msedit

      # android debugging
      android-tools

      # backups
      kopia
      kopia-ui
    ];

    services.flatpak.enable = true;
    services.tailscale.enable = true;

    systemd.packages = with pkgs; [ lact ];
    systemd.services.lactd.wantedBy = ["multi-user.target"];

    programs.ausweisapp = {
      enable = true;
      openFirewall = true;
    };

    # Enable Bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
