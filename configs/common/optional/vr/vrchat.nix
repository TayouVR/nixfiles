{
  lib,
  pkgs,
  config,
  ...
}:

let
  vrcSwitch = pkgs.writeShellScriptBin "vrcSwitch" ''
    if systemctl --user is-active monado.service --quiet;
    then PRESSURE_VESSEL_FILESYSTEMS_RW="$XDG_RUNTIME_DIR/monado_comp_ipc" ${lib.getExe pkgs.startvrc} "$@";
    else ${lib.getExe pkgs.startvrc} "$@";
    fi
  '';
in

{
  environment.systemPackages = with pkgs; [
    startvrc
    vrcSwitch
    vrcx
    vrc-get
    unityhub
    blender
    alcom
  ];

  xdg.mime.defaultApplications."x-scheme-handler/vcc" =
    "${pkgs.alcom}/share/applications/ALCOM.desktop";

  hm.home.symlinks."${config.hm.xdg.dataHome}/Steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/Pictures/VRChat" =
    "${config.hm.xdg.userDirs.pictures}/VRChat";

  environment.sessionVariables.GSETTINGS_SCHEMA_DIR = "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";

  hm.xdg.autostart.entries = [ "${pkgs.vrcx}/share/applications/VRCX.desktop" ];
}
