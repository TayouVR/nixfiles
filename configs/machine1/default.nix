{ deps, ... }:

{
  flake.nixosConfigurations = deps.mkSystem {
    hostname = "tayou-berlin";
    username = "tayou";
    modules = [
      ../common/required
      ../common/optional/graphics
      ../common/optional/vr

      ./hardware-configuration.nix
      ./mounts.nix
      ./configuration.nix

      # Configure to use AMD graphics
      {
        tayouflake = {
          graphics.driver = "amd";
          openvr.runtime = "xrizer";
          openxr.viewportScale = 50;
        };
      }
      (
        { pkgs, prismlauncher, ... }:
        {
          environment.systemPackages = [ prismlauncher.packages.${pkgs.system}.prismlauncher ];
        }
      )

      ../../starship/starship.nix
    ];
  };
}
