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
      # Override the original xrizer package
      xrizer-patched = prev.xrizer.overrideAttrs (oldAttrs: {
        # Set the source to the specific GitHub fork and branch
        src = final.fetchFromGitHub {
          owner = "openglfreak";
          repo = "xrizer";
          rev = "feat-tracker-list-update";
          # Replace this with the actual hash after the first build attempt
          sha256 = "sha256-XQk0nB+5R4LQGRtTvSjXy30cLjmSZqpvvLqV9LrNNJc=";
          # You can also use lib.fakeSha256 instead of the zeroes:
          # sha256 = lib.fakeSha256;
        };
        # Remove the patches attribute, as they are presumably included in the fork
        patches = [];
        # Keep this if checks still fail or are unwanted, otherwise remove it.
        doCheck = false;
        # Optionally, update the version string if desired
        version = "${oldAttrs.version}-feat-tracker-list-update";
      });
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