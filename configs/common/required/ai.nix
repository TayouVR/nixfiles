{
  lib,
  config,
  pkgs,
  ...
}:
let
  # ollamaPackage = if config.tayouflake.graphics.driver == "nvidia" then pkgs.ollama-cuda else pkgs.ollama;
  ollamaPackage = pkgs.ollama; # ollama package is already mapped to the gpu vendor by nixpkgs
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
        environmentVariables = {
          OLLAMA_CONTEXT_LENGTH = "512000";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      ollamaPackage
      opencode-desktop
    ];
  };
}
