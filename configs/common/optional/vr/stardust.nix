{ pkgs, ... }:
{
  config.environment.systemPackages = with pkgs; [
    stardust-xr-gravity
    stardust-xr-server
    stardust-xr-flatland
    stardust-xr-protostar
  ];
}