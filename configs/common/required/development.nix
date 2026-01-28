{
  pkgs,
  username,
  ...
}:

{
  config = {
    # Development-related packages
    environment.systemPackages = with pkgs; [
      # JetBrains IDEs
      jetbrains.rider
      jetbrains.clion
      jetbrains.goland
      jetbrains.webstorm
      jetbrains.rust-rover
      jetbrains.idea
      jetbrains.pycharm
      jetbrains-toolbox # for fleet primarily, and any other jb app without native package

      #zed-editor

      # Programming languages and tools
      gcc
      gpp

      # .NET
      dotnetCorePackages.sdk_10_0
      dotnetPackages.Nuget
      mono
      msbuild

      # Unity
      unityhub

      # Godot
      godot-mono

      # Other development tools
      git
      kicad
      sqlitebrowser
      qtcreator
      kdePackages.qttools
      gtk3 # for gtk-icon-browser
      kdePackages.plasma-sdk # cuttlefish icon viewer

      # microcontrollers
      esptool
      espflash
    ];

    # serial device access, e.g. ESP32, for tasmota web flasher, esptool, etc.
    users.users.${username}.extraGroups = [ "dialout" ];

    # Fix for JetBrains Rider desktop entry
    home-manager.users.${username}.home.file = {
      ".local/share/applications/jetbrains-rider.desktop".source =
        let
          desktopFile = pkgs.makeDesktopItem {
            name = "jetbrains-rider";
            desktopName = "Rider";
            exec = "\"${pkgs.jetbrains.rider}/bin/rider\"";
            icon = "rider";
            type = "Application";
            # Don't show desktop icon in search or run launcher
            extraConfig.NoDisplay = "true";
          };
        in
        "${desktopFile}/share/applications/jetbrains-rider.desktop";
    };

    # Insecure packages that are needed
    nixpkgs.config.permittedInsecurePackages = [
      "dotnet-sdk-6.0.428"
      "dotnet-runtime-6.0.36"
    ];
  };
}
