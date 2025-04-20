{
  lib,
  username,
  ...
}:

{
  users.users.${username} = {
    isNormalUser = true;
    description = "Tayou";
    extraGroups = [ "wheel" ];
  };
}
