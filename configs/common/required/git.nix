{ pkgs, ... }:

{
  hm.programs.git.enable = true;
  hm.programs.git.extraConfig = {
    core.autocrlf = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    config.init.defaultBranch = "main";
  };

  environment.systemPackages = [
    pkgs.gnupg
    pkgs.gitkraken # optional GUI git client (freemium)
    pkgs.sourcegit # optional GUI git client (FOSS)
  ];
}
