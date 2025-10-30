{ pkgs, ... }:

{
  hm.programs.git.enable = true;
  hm.programs.git.settings = {
    core.autocrlf = "input";
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    config.init.defaultBranch = "main";
  };

  environment.systemPackages = with pkgs; [
    gnupg
    gitkraken # optional GUI git client (freemium)
    sourcegit # optional GUI git client (FOSS)
    gh
  ];
}
