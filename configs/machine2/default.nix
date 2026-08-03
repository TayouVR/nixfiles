{ deps, ... }:

{
  flake.nixosConfigurations = deps.mkSystem {
    hostname = "tayou-gw";
    username = "tayou";
    modules = [
      ../common/required
      ../common/optional/graphics
      ../common/optional/vr

      ./hardware-configuration.nix

      ./configuration.nix

      # Configure to use NVIDIA graphics
      {
        tayouflake.graphics.driver = "nvidia";
      }

      ../../starship/starship.nix
    ];
  };
}
