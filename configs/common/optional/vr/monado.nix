{
  lib,
  pkgs,
  config,
  packages,
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
  nixpkgs.overlays = [(final: prev: {
    monado-patched = prev.monado.overrideAttrs (oldAttrs: {
      # Set the source to the specific GitLab repo and branch
      src = final.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "openglfreak";
        repo = "monado";
        rev = "dyndev";
        # Replace this with the actual hash after the first build attempt
        sha256 = "sha256-esI5Ne6tZe8mZ2rTC7npA2QtPsvfD/DLFjM6BMNg400=";
        # You can also use lib.fakeSha256:
        # sha256 = lib.fakeSha256;
      };
      # Optionally, update the version string if desired
      version = "${oldAttrs.version}-dyndev";
      # Add any other overrides needed for this specific version,
      # for example, disabling checks if they fail:
      # doCheck = false;
    });
  })];

  hm.xdg.configFile."openxr/1/active_runtime.json".source =
    "${pkgs.monado-patched}/share/openxr/1/openxr_monado.json";

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
    package = pkgs.monado-patched;
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
}
