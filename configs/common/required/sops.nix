{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:

let
  inherit (lib) mkOption types;
  inherit (lib.modules) mkAliasOptionModule;
  inherit (inputs) sops-nix;

  cfg = config.nanoflake.sopsFile;

  sopsCfg = {
    defaultSopsFile = cfg;
    defaultSopsFormat = "yaml";

    age.keyFile = "${config.hm.xdg.configHome}/sops/age/keys.txt";
  };
in

{
  options.nanoflake.sopsFile = mkOption {
    type = types.pathInStore;
    default = ./. + "../../../${config.networking.hostName}/secrets.yaml";
    example = lib.literalExpression "./secrets.yaml";
    description = "The default sops file for the system";
  };

  imports = [
    sops-nix.nixosModules.sops
    (mkAliasOptionModule
      [ "sec" ]
      [
        "sops"
        "secrets"
      ]
    )
  ];

  config = {
    sops = sopsCfg;

    home-manager.sharedModules = [
      sops-nix.homeManagerModules.sops
    ];
    hm.imports = [
      (mkAliasOptionModule
        [ "sec" ]
        [
          "sops"
          "secrets"
        ]
      )
    ];
    hm.sops = sopsCfg;

    environment.systemPackages = [ pkgs.sops ];
  };
}
