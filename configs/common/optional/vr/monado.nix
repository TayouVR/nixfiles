{
  lib,
  pkgs,
  config,
  ...
}:

let
  lighthouseScript =
    state:
    pkgs.writeShellScript "preStart" ''
      if ${lib.getExe' pkgs.bluez "bluetoothctl"} list | grep -q "Controller" 
      then 
        ${lib.getExe pkgs.lighthouse-steamvr} -s ${state}
      else
        exit 0
      fi
    '';
  inherit (lib) mkOption types;

  cfg = config.tayouflake.openxr;

  monadoPackage = pkgs.patched.monado; # patched
  # monadoPackage = pkgs.monado; # upstream
in

# https://wiki.nixos.org/wiki/VR#Monado
{
  options.tayouflake.openxr = {
    compositorScale = mkOption {
      type = types.int;
      default = 140;
      example = 140;
      description = "140% is SteamVR default, 100% is native resolution. Multiplicative with viewport scale.";
    };

    # FIXME: this might need to be set for each game in e.g. steam launch args due to pressure vessel, test!
    viewportScale = mkOption {
      type = types.int;
      default = 100;
      example = 100;
      description = "Affects only scene applications. Multiplicative with compositor scale.";
    };
  };

  config = {
    environment.variables = {
      OXR_VIEWPORT_SCALE_PERCENTAGE = cfg.viewportScale;
    };

    hm.xdg.configFile."openxr/1/active_runtime.json".source =
      "${monadoPackage}/share/openxr/1/openxr_monado.json";

    hm.xdg.dataFile."monado/hand-tracking-models".source = pkgs.fetchgit {
      url = "https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models.git";
      fetchLFS = true;
      hash = "sha256-x/X4HyyHdQUxn3CdMbWj5cfLvV7UyQe1D01H93UCk+M=";
    };

    # Make sure to `sudo renice -20 -p $(pgrep monado)`
    services.monado = {
      enable = true;
      defaultRuntime = true;
      highPriority = true;
      package = monadoPackage;
    };

    systemd.user.services.monado = {
  #    serviceConfig = {
  #      ExecStartPre = lighthouseScript "ON";
  #      ExecStopPost = lighthouseScript "OFF";
  #    };

      environment = {
        STEAMVR_PATH = "${config.hm.xdg.dataHome}/Steam/steamapps/common/SteamVR";
        XR_RUNTIME_JSON = "${config.hm.xdg.configHome}/openxr/1/active_runtime.json";
        STEAMVR_LH_ENABLE = "1";
        XRT_COMPOSITOR_COMPUTE = "1";
        #WMR_HANDTRACKING = "1";
        #XRT_DEBUG_GUI = "1";
        #OXR_DEBUG_GUI = "1";
        XRT_COMPOSITOR_SCALE_PERCENTAGE = toString cfg.compositorScale;
        SURVIVE_GLOBALSCENESOLVER = "0";
        SURVIVE_TIMECODE_OFFSET_MS = "-6.94";
        OXR_DEBUG_IPD_MM = "62";
        LH_STICK_DEADZONE = "0.25";
        OXR_PARALLEL_VIEWS = "1";
      };
    };

    hm.xdg.desktopEntries.monado = {
      name = "Monado";
      comment = "Starts the Monado OpenXR service";
      exec = lib.getExe (
        pkgs.local.writeSystemdToggle.override {
          service = "monado";
          isUserService = true;
        }
      );
      icon = "${pkgs.catppuccin-papirus-folders}/share/icons/Papirus/64x64/apps/steamvr.svg";
      categories = [
        "Game"
        "Graphics"
        "3DGraphics"
      ];
      terminal = false;
    };
  };
}
