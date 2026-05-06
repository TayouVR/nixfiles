{
  lib,
  config,
  pkgs,
  ...
}:

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
      };
    };

    environment.systemPackages = with pkgs; [
      ollama
    ];
  };
}
