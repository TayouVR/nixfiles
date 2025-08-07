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

#      package = pkgs.steam.override {
#        extraProfile = ''
#          export OXR_VIEWPORT_SCALE_PERCENTAGE=70
#          export PRESSURE_VESSEL_FILESYSTEMS_RW="$XDG_RUNTIME_DIR/monado_comp_ipc"
#          export XRIZER_CUSTOM_BINDINGS_DIR="/mnt/linuxApps/SteamLibrary/steamapps/common/VRChat/OpenComposite/"
#          unset TZ
#        '';
#      };
    };

    # Enable Waydroid for Android app support
    virtualisation.waydroid.enable = true;

    # Gaming-related packages
    environment.systemPackages = with pkgs; [
      # Game launchers
      prismlauncher
      modrinth-app
      lutris
      protonup-qt
      rare
      minigalaxy
      heroic

      # Gaming utilities
      gamemode
      mangohud
      waydroid-helper

      # Games
      superTux
      superTuxKart
      extremetuxracer
      chromium-bsu
      openarena
      xonotic
      gzdoom
      osu-lazer

      # XR
      #overte

      # BeatSaber
      bs-manager

      # emulators
      # suyu
      ryujinx-greemdev
      dolphin-emu
      cemu
    ];
  };
}
