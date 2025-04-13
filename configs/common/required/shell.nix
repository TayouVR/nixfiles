{
  lib,
  pkgs,
  ...
}:

{
  environment.pathsToLink = [ "/share/zsh" ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    enableBashCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;

    interactiveShellInit = ''
      bindkey "^[[H"    beginning-of-line
      bindkey "^[[F"    end-of-line
      bindkey "^[[3~"   delete-char
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey "^[[3;5~" kill-word
      bindkey "^H"      backward-kill-word
    '';

    shellAliases = {
      rb = "sudo nixos-rebuild switch --flake $FLAKE_DIR --log-format internal-json -v |& ${lib.getExe pkgs.nix-output-monitor} --json";
      nix-conf = "$EDITOR $FLAKE_DIR";
    };

    histSize = 10000;
  };
}
