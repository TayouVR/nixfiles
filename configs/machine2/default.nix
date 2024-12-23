{ deps, ... }:

{
  flake.nixosConfigurations = deps.mkSystem {
    hostname = "tayou-gw";
    username = "tayou";
    modules = [
      #../common

      ./hardware-configuration.nix

      ./configuration.nix

      ../../starship/starship.nix
    ];
  };
}
