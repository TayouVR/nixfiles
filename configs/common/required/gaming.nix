{
  pkgs,
  ...
}:

{
  config = {
    # Steam configuration
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      gamescopeSession.enable = true;

#      package = pkgs.steam.override {
#        extraProfile = ''
#          export OXR_VIEWPORT_SCALE_PERCENTAGE=70
#          export PRESSURE_VESSEL_FILESYSTEMS_RW="$XDG_RUNTIME_DIR/monado_comp_ipc"
#          export XRIZER_CUSTOM_BINDINGS_DIR="/mnt/linuxApps/SteamLibrary/steamapps/common/VRChat/OpenComposite/"
#          unset TZ
#        '';
#      };
    };
    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    # Enable Waydroid for Android app support
    virtualisation.waydroid.enable = true;

    # Gaming-related packages
    environment.systemPackages = with pkgs; [
      # Game launchers
      prismlauncher
      # modrinth-app # broken due to build failure in rust dependency turbo
      lutris
      protonup-qt
      rare
      minigalaxy
      heroic

      # Gaming utilities
      gamemode
      mangohud
      waydroid-helper

      # Wine
      wineWowPackages.stable
      winetricks
      bottles

      # Games
      superTux
      superTuxKart
      extremetuxracer
      chromium-bsu
      openarena
      xonotic
      gzdoom
      osu-lazer
      enigma
      space-cadet-pinball
      kdePackages.kpat # solitaire card games
      apotris
      mindustry

      # XR
      #overte

      # BeatSaber
      bs-manager

      # emulators
      # suyu              # switch
      ryubing           # switch
      dolphin-emu       # gamecube wii
      cemu              # wii u
      ruffle            # flash games
      scummvm           # tons of random stuff?
      dosbox
      # TODO: install EKA2L1 https://github.com/EKA2L1/EKA2L1
      # TODO: install freej2me https://github.com/hex007/freej2me

      shipwright        # zelda: ocarina of time pc port
      _2ship2harkinian  # zelda: majoras mask
    ];
  };
}
