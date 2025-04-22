{
  pkgs,
  username,
  ...
}:

{
  config = {
    # Enable SANE scanning backend
    hardware.sane.enable = true;

    # Add scanner group to user
    users.users.${username}.extraGroups = [ "scanner" ];

    # Scanning-related packages
    environment.systemPackages = with pkgs; [
      # Scanning
      simple-scan
      kdePackages.skanpage # testing how this is
      kdePackages.skanlite # testing how this is
    ];
  };
}