{
  lib,
  lib',
  username,
  self,
  inputs,
  config,
  ...
}:

let
  inherit (inputs) home-manager;
in

{
  imports = [
    home-manager.nixosModules.home-manager
    (lib.modules.mkAliasOptionModule
      [ "hm" ]
      [
        "home-manager"
        "users"
        username
      ]
    )
  ];

  home-manager = {
    backupFileExtension = "home-bac";
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = { inherit lib'; };
    sharedModules = [
      self.homeManagerModules.symlinks
    ];
  };

  hm = {
    programs.home-manager.enable = true;

    home = {
      inherit username;
      homeDirectory = "/home/${username}";
      stateVersion = lib.mkDefault (
        builtins.trace "Home manager state version not set. Defaulting to system.stateVersion" config.system.stateVersion
      );

      shell.enableZshIntegration = true;

      preferXdgDirectories = true;
    };

    xdg = {
      enable = true;
      autostart.enable = true;
    };
  };
}
