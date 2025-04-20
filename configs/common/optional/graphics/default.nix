{ lib, config, pkgs, ... }:

let
  cfg = config.tayouflake.graphics;
in
{
  options.tayouflake.graphics = {
    driver = lib.mkOption {
      type = lib.types.enum [ "amd" "nvidia" ];
      default = "amd";
      description = "Graphics driver to use (amd or nvidia)";
    };
  };

  # Import the appropriate graphics configuration based on the selected driver
  imports = [
    ./amd.nix
    ./nvidia.nix
  ];

  config = {
    # Configure the appropriate Blender package based on the selected driver
    environment.systemPackages = with pkgs; [
      # Use mkIf to conditionally include `blender-hip` or `blender`
      (lib.mkIf (cfg.driver == "amd") blender-hip)
      (lib.mkIf (cfg.driver == "nvidia") blender)
    ];
  };
}