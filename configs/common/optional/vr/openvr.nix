{ config, pkgs, lib, ... }:
let
  inherit (lib) mkOption types;

  cfg = config.tayouflake.openvr;
in
{
  options.tayouflake.openvr = {
    runtime = mkOption {
      type = types.str;
      default = "opencomposite";
      example = "opencomposite|xrizer|steamvr";
      description = "Selects the active OpenVR Runtime";
    };
  };

  config = {
    nixpkgs.overlays = [(final: prev: {
      xrizer-patched = final.xrizer.overrideAttrs rec {
        patches = [
          # ./patching/patches/xrizer/68.patch
          ./patching/patches/xrizer/69.patch
          ./patching/patches/xrizer/82.patch
          # ./patching/patches/xrizer/rin_xdevs.patch
        ];
        doCheck = false;
      };
    })];

    hm.xdg.configFile."openvr/openvrpaths.vrpath".text =
      let
        runtimePath =
          if cfg.runtime == "opencomposite" then "${pkgs.opencomposite}/lib/opencomposite"
          else if cfg.runtime == "steamvr" then "${config.hm.xdg.dataHome}/Steam/steamapps/common/SteamVR"
          else "${pkgs.xrizer-patched}/lib/xrizer";
      in
    ''
      {
        "config" :
        [
          "${config.hm.xdg.dataHome}/Steam/config"
        ],
        "external_drivers" : null,
        "jsonid" : "vrpathreg",
        "log" :
        [
          "${config.hm.xdg.dataHome}/Steam/logs"
        ],
        "runtime" :
        [
          "${runtimePath}"
        ],
        "version" : 1
      }
    '';

    environment.systemPackages =
      (if cfg.runtime == "opencomposite" then [ pkgs.opencomposite ] else []) ++
      (if cfg.runtime == "xrizer" then [ pkgs.xrizer-patched ] else []);
  };
}