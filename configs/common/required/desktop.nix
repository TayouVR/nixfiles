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

    hm.xdg.portal.config = {
      common.default = [ "kde" ];
    };
    environment.variables = {
      XDG_DESKTOP_PORTAL_BACKEND = "kde";
      GTK_USE_PORTAL = 1;
      GDK_DEBUG_PORTALS = 1;
    };

    # Common desktop packages
    environment.systemPackages = with pkgs; [
      kdePackages.sddm-kcm # sddm configuration in kde settings

      kdePackages.kweather
      kdePackages.kdeconnect-kde

      # File management
      kdePackages.kate
      kdePackages.filelight
      qdirstat
      kdePackages.partitionmanager
      kdePackages.calligra
      kdePackages.kdiagram
      gparted
      gnome-disk-utility
      kdePackages.dolphin
      kdePackages.dolphin-plugins
      kdePackages.kconfig
      kdePackages.kclock
      kdePackages.konqueror
      kdePackages.marble
      amarok
      kdePackages.wallpaper-engine-plugin
      # systemdgenie
      fsearch

      # Remote desktop
      kdePackages.krdc
      kdePackages.krdp
      freerdp3
      zenity # for password prompt with freerdp
      remmina

      # Office and productivity
      libreoffice
      obsidian

      qalculate-qt

      # Graphics and media
      gimp3
      inkscape
      krita
      vlc
      haruna
      kdePackages.kolourpaint
      darktable
      grayjay

      unzip
      p7zip

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


    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    };

    # firmware update service
    services.fwupd.enable = true;

    # not sure this isn't already on because of something else,
    #  but it might help with the SteamVR admin prompt not working?
    security.polkit.enable = true;

    hm.xdg.desktopEntries.freerdp-work-laptop = {
      name = "FreeRDP - Work Laptop";
      comment = "Starts freerdp with pre-configured options, prompts for user and password";
      exec = "${pkgs.writeShellScriptBin "freerdp-work-laptop-exec" ''
${pkgs.freerdp3}/bin/xfreerdp /u:$(${pkgs.kdePackages.kdialog}/bin/kdialog \
  --geometry=400x100 \
  --title "Username - FreeRDP" \
  --inputbox "Enter your Username:") \
/p:$(${pkgs.kdePackages.kdialog}/bin/kdialog \
  --geometry=400x100 \
  --title "Password - FreeRDP" \
  --password "Enter your Password:") \
/v:192.168.178.20 \
/multimon /mic /sound /microphone:sys:pulse \
/clipboard /dvc:urbdrc,dev:12d1:4321 /kbd:layout:0x407
      ''}/bin/freerdp-work-laptop-exec";
      icon = "gnome-rdp";
      categories = [
        "Utility"
      ];
      terminal = false;
    };
  };
}
