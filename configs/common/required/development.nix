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
      jetbrains.idea-ultimate
      jetbrains.pycharm-professional
      jetbrains-toolbox # for fleet primarily, and any other jb app without native package

      zed-editor

      # Programming languages and tools
      gcc
      gpp

      # .NET
      dotnetCorePackages.sdk_9_0
      dotnetCorePackages.sdk_10_0-bin
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
      gtk3 # for gtk-icon-browser
      kdePackages.plasma-sdk # cuttlefish icon viewer
    ];

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
