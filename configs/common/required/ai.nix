{
  lib,
  config,
  pkgs,
  ...
}:
let
  ollamaPackage = if config.tayouflake.graphics.driver == "nvidia" then pkgs.ollama-cuda else pkgs.ollama;
in
{
  options.tayouflake.ai = {
    enable = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable AI Tools.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf (config.tayouflake.ai.enable) {
    services = {
      open-webui = {
        enable = true;
        openFirewall = true;
      };
      ollama = {
        enable = true;
        package = ollamaPackage;
      };
    };

    environment.systemPackages = with pkgs; [
      ollamaPackage
      opencode-desktop
    ];
  };
}
