{ lib, username, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  networking.useDHCP = lib.mkDefault true;

  users.users.${username}.extraGroups = [ "networkmanager" ];

  # network utilities
  environment.systemPackages = with pkgs; [
    traceroute
    dig
    mtr-gui
    mtr
    nmap
    zenmap
  ];
}
