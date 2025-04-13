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
in

# https://wiki.nixos.org/wiki/VR#Monado
{
  hm.xdg.configFile."openvr/openvrpaths.vrpath".text = ''
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
        "${pkgs.opencomposite}/lib/opencomposite"
      ],
      "version" : 1
    }
  '';

  hm.xdg.configFile."openxr/1/active_runtime.json".source =
    "${pkgs.monado}/share/openxr/1/openxr_monado.json";

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
    package = pkgs.monado;
  };

  systemd.user.services.monado = {
    serviceConfig = {
      ExecStartPre = lighthouseScript "ON";
      ExecStopPost = lighthouseScript "OFF";
    };

    environment = {
      STEAMVR_PATH = "${config.hm.xdg.dataHome}/Steam/steamapps/common/SteamVR";
      XR_RUNTIME_JSON = "${config.hm.xdg.configHome}/openxr/1/active_runtime.json";
      STEAMVR_LH_ENABLE = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
      WMR_HANDTRACKING = "1";
      XRT_COMPOSITOR_SCALE_PERCENTAGE = "130";
      SURVIVE_GLOBALSCENESOLVER = "0";
      SURVIVE_TIMECODE_OFFSET_MS = "-6.94";
    };
  };

  hm.xdg.desktopEntries.monado = {
    name = "Monado";
    comment = "Starts the Monado OpenXR service";
    exec = lib.getExe (
      pkgs.writeSystemdToggle.override {
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
}
