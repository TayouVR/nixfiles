{ deps, ... }:

{
  flake.nixosConfigurations = deps.mkSystem {
    hostname = "tayou-gw";
    username = "tayou";
    modules = [
      ../common/required
      ../common/graphics/nvidia.nix

      ./hardware-configuration.nix

      ./configuration.nix

      ../../starship/starship.nix
    ];
  };
}
