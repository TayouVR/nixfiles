{ lib, config, ... }:

let
  inherit (lib) mkOption types;

  cfg = config.tayouflake.localization;

  characterSet = builtins.elemAt (lib.strings.splitString "." cfg.locale) 1;
  posixLocalePredicate = lang: (builtins.match "^[a-z]{2}_[A-Z]{2}$" lang) != null;
in

{
  options.tayouflake.localization = {
    timezone = mkOption {
      type = types.str;
      default = "Europe/Berlin";
      example = "Europe/Berlin";
      description = "The IANA timezone of the system";
    };

    language = mkOption {
      type = types.either types.str (types.listOf types.str);
      default = "en_US";
      example = lib.literalExpression ''[ "de_DE" "en" ]'';
      description = ''
        The language preference order to set for messages.
        Sets {option}`i18n.extraLocaleSettings.LANGUAGE` and {option}`i18n.extraLocaleSettings.LC_MESSAGES`
      '';
    };
  };

  config = {

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "de";
      variant = "";
    };

    # Configure console keymap
    console.keyMap = "de";

    time.timeZone = cfg.timezone;

    i18n = {
      defaultLocale = "en_US.UTF-8";

      extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
        LC_ALL = "en_US.UTF-8";
      };
    };

    environment.sessionVariables = config.i18n.extraLocaleSettings // {
      LANGUAGE = lib.mkForce (
        if builtins.isString cfg.language then
          cfg.language
        else
          lib.strings.concatStrings (lib.strings.intersperse ":" cfg.language)
      );
    };

  };
}
