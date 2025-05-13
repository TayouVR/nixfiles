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

      # Gaming utilities
      gamemode
      mangohud

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
    ];
  };
}
