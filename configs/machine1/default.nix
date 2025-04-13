{ deps, ... }:

{
  flake.nixosConfigurations = deps.mkSystem {
    hostname = "tayou-berlin";
    username = "tayou";
    modules = [
      #../common

      ./home.nix

      ./hardware-configuration.nix
      ./mounts.nix
      ./configuration.nix

      ../../starship/starship.nix
    ];
  };
}
