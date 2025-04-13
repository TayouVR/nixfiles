{ lib, username, ... }:

{
  networking.networkmanager.enable = true;

  networking.useDHCP = lib.mkDefault true;

  users.users.${username}.extraGroups = [ "networkmanager" ];
}
