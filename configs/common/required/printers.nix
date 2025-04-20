{
  pkgs,
  username,
  ...
}:

{
  config = {
    # Enable CUPS printing service
    services.printing.enable = true;
    
    # Configure printing defaults
    services.printing.extraConf = ''
      DefaultEncryption Never
    '';

    # Enable Avahi for network discovery
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Add lp group to user
    users.users.${username}.extraGroups = [ "lp" ];
  };
}