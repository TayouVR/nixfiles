{
  lib,
  lib',
  username,
  config,
  ...
}:

{
  sec."nixos/users/${username}".neededForUsers = true;

  users.mutableUsers = false;
  users.users.${username} = {
    isNormalUser = true;
    description = lib'.toUppercase username;
    hashedPasswordFile = config.sec."nixos/users/${username}".path;
    extraGroups = [ "wheel" ];

    openssh.authorizedKeys.keys = lib.lists.map (key: builtins.readFile key) (
      lib.filesystem.listFilesRecursive ../optional/passkeys/keys
    );
  };
}
