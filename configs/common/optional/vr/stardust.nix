{ pkgs, ... }:
{
  config.environment.systemPackages = with pkgs; [
    stardust-xr-kiara
    stardust-xr-server
    stardust-xr-flatland
    stardust-xr-protostar
  ];
}