{
  pkgs,
  packages,
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
      bat
      fuse3

      # Hardware utilities
      pciutils

      # System management
      home-manager

      # Diagramming
      dia

      # Custom packages
      # update when PR is merged: https://github.com/NixOS/nixpkgs/pull/318772
      #packages.klassy

      # update when PR is merged: https://github.com/NixOS/nixpkgs/pull/367614
      packages.darkly
    ];

    # Enable Bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
