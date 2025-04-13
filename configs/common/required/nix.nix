{
  self,
  lib,
  inputs,
  pkgs,
  config,
  ...
}:

let
  inherit (lib) mkOption types;

  cfg = config.nanoflake.nix;
in

{
  options.nanoflake.nix = {
    flakeDir = mkOption {
      type = types.str;
      default = "$HOME/flake";
      example = "/etc/nixos/configuration";
      description = "The location of this flake";
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.flakeDir != "";
        message = "Flake path must not be empty";
      }
    ];

    nixpkgs.overlays = [ self.overlays.default ];
    nixpkgs.config.allowUnfree = true;

    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      settings.auto-optimise-store = true;
      optimise.automatic = true;
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 30d";
        persistent = true;
      };

      registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
      nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    };

    environment.variables.FLAKE_DIR = cfg.flakeDir;

    environment.systemPackages = with pkgs; [
      nixfmt-rfc-style
      nixd
    ];

    programs.direnv.enable = true;
  };
}
