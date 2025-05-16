{
  pkgs,
  ...
}:

{
  config = {
    # System utilities
    environment.systemPackages = with pkgs; [
      # System information and monitoring
      fastfetch
      hyfetch

      # Fun utilities
      sl
      lolcat

      # Fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-mono

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
    ];

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
