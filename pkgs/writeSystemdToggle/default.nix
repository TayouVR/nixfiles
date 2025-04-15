{
  lib,
  writeShellScriptBin,
  service ? "",
  isUserService ? false,
}:

writeShellScriptBin "${service}-systemd-toggle" (
  let
    systemdCmd = "systemctl ${lib.optionalString isUserService "--user"}";
  in
  ''
    if ${systemdCmd} is-active ${service}.service --quiet; 
    then ${systemdCmd} stop ${service}.service; 
    else ${systemdCmd} start ${service}.service; 
    fi
  ''
)
