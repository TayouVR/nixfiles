{ config, pkgs, lib, ... }:
let
  inherit (lib) mkOption types;

  cfg = config.tayouflake.openvr;
in
{
  options.tayouflake.openvr = {
    runtime = mkOption {
      type = types.enum [ "opencomposite" "steamvr" "xrizer" ];
      default = "opencomposite";
      example = "opencomposite | xrizer | steamvr";
      description = "Selects the active OpenVR Runtime. Must be one of: opencomposite, steamvr, xrizer.";
    };
  };

  config = {
    hm.xdg.configFile."openvr/openvrpaths.vrpath".text =
      let
        runtimePath =
          if cfg.runtime == "opencomposite" then "${pkgs.opencomposite}/lib/opencomposite"
          else if cfg.runtime == "steamvr" then "${config.hm.xdg.dataHome}/Steam/steamapps/common/SteamVR"
          else if cfg.runtime == "xrizer" then "${pkgs.local.xrizer}/lib/xrizer"
          else builtins.throw "Invalid value for tayouflake.openvr.runtime: ${cfg.runtime}. Expected one of: 'opencomposite', 'steamvr', 'xrizer'.";
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
      (if cfg.runtime == "xrizer" then [ pkgs.local.xrizer ] else []);
  };
}