{ inputs, deps, ... }:

{
  flake.nixosConfigurations = deps.mkSystem {
    hostname = "tayou-berlin";
    username = "tayou";
    modules = [
      inputs.home-manager.nixosModules.home-manager
      ../common/required
      ../common/graphics/amd.nix

      ./hardware-configuration.nix
      ./mounts.nix
      ./configuration.nix

      ../../starship/starship.nix
    ];
  };
}
