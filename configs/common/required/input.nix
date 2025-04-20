{
  lib,
  pkgs,
  config,
  username,
  ...
}:

let
  inherit (lib) mkOption mkIf types;

  cfg = config.tayouflake.keyboard;

  hasDesktop = config.tayouflake ? desktop;
in

{
  options.tayouflake.keyboard = {
    layout = mkOption {
      type = types.str;
      default = "de";
      example = "at";
      description = "Sets the xkb and tty keyboard layout";
    };

    variant = mkOption {
      type = types.str;
      default = "";
      example = "dvorak";
      description = "Sets the xkb keyboard layout variant";
    };
  };

  config = {
    users.users.${username}.extraGroups = [
      "input"
      "uinput"
    ];

    console.keyMap = cfg.layout;

    i18n.inputMethod = mkIf hasDesktop {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
        ];
        waylandFrontend =
          config.services.xserver.displayManager.gdm.wayland
          || true; # Always enable Wayland frontend for fcitx5
      };
    };

    services = mkIf hasDesktop {
      libinput.mouse.accelProfile = "flat";
      xserver.desktopManager.runXdgAutostartIfNone = true;
      xserver.xkb = { inherit (cfg) layout variant; };
    };
  };
}
