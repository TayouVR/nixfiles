{
  pkgs,
  username,
  ...
}:

{
  config = {
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji

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

      # appimages
      gearlever
#      fuse3
#      webkitgtk_4_1 # for tauri
#      harfbuzz
#      glib-networking

      # Hardware utilities
      pciutils

      # System management
      home-manager

      # Diagramming
      dia

      # Custom packages
      # update when PR is merged: https://github.com/NixOS/nixpkgs/pull/318772
      local.klassy

      darkly

      obsidian
      nextcloud-client

      freecad-qt6

      scrcpy
      qtscrcpy

      just
      nvtopPackages.amd
      btop
      corectrl

      tailscale
      #sweethome3d

      # 3D printing
      # cura # broken
      prusa-slicer
      orca-slicer

      kdePackages.discover
      msedit

      # android debugging
      android-tools

      # backups
      kopia
      kopia-ui

      docker-compose

      rustdesk
      imhex

      keepassxc

      unrar
    ];

    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    services.flatpak.enable = true;
    services.tailscale.enable = true;
    virtualisation.docker.enable = true;
    users.users.${username}.extraGroups = [ "docker" ];

    services.lact.enable = true;
    hardware.amdgpu.overdrive.enable = true;

    programs.ausweisapp = {
      enable = true;
      openFirewall = true;
    };

    services.grafana = {
      enable = true;
      settings.security = {
        admin_user = "admin";
        admin_password = "1234";
        admin_email = "local-grafana@tayou.org";
      };
    };
  };
}
