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
      prismlauncher  # Minecraft launcher
      lutris         # Game launcher
      protonup-qt    # Proton GE manager
      rare           # Epic Games Store launcher

      # Gaming utilities
      gamemode       # Optimize system performance for gaming

      # Games
      superTux
      superTuxKart
      extremetuxracer
      chromium-bsu
      openarena
      xonotic
      gzdoom

      # XR
      #overte

      # BeatSaber
      bs-manager

      gamemode
      mangohud
    ];
  };
}
