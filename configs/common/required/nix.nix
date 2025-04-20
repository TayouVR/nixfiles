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

  cfg = config.tayouflake.nix;
in

{
  options.tayouflake.nix = {
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

    #nixpkgs.overlays = [ self.overlays.default ];
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

    system = {
      autoUpgrade = {
        enable = true;
        dates = "02:00";
        randomizedDelaySec = "45min";
        persistent = true;
      };

      activationScripts.report-changes = ''
        PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
        echo " ---  Changes since boot  ---"
        nvd diff /run/booted-system $(ls -dv /nix/var/nix/profiles/system-*-link | tail -1)
        echo " --- Changes from rebuild ---"
        nix --extra-experimental-features 'nix-command' store diff-closures /run/current-system "$systemConfig"
        nvd diff /run/current-system $(ls -dv /nix/var/nix/profiles/system-*-link | tail -1)
        echo " ____________________________"
      '';
    };

    environment.variables.FLAKE_DIR = cfg.flakeDir;

    environment.systemPackages = with pkgs; [
      nixfmt-rfc-style
      nixd

      # NixOS configuration editor
      inputs.nixos-conf-editor.packages.${system}.nixos-conf-editor
    ];

    programs.direnv.enable = true;
  };
}
