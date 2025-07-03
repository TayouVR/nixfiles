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

      # update when PR is merged: https://github.com/NixOS/nixpkgs/pull/367614
      local.darkly

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
    ];

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
