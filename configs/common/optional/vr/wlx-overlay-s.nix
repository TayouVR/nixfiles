{
  lib,
  pkgs,
  config,
  ...
}:

let
  yaml = pkgs.formats.yaml { };
in

{
  systemd.user.services.wlx-overlay-s =
    lib.recursiveUpdate
      {
        description = "wlx-overlay-s service";

        unitConfig.ConditionUser = "!root";

        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.wlx-overlay-s} --openxr";
          Restart = "on-failure";
          Type = "simple";
        };

        environment.XR_RUNTIME_JSON = "${config.hm.xdg.configHome}/openxr/1/active_runtime.json";

        restartTriggers = [ pkgs.wlx-overlay-s ];
      }
      (
        lib.optionalAttrs config.services.monado.enable {
          environment.LIBMONADO_PATH = "${config.services.monado.package}/lib/libmonado.so";

          after = [ "monado.service" ];
          bindsTo = [ "monado.service" ];
          wantedBy = [ "monado.service" ];
          requires = [
            "monado.socket"
            "graphical-session.target"
          ];
        }
      );

  hm.xdg.configFile."wlxoverlay/wayvr.yaml".source = yaml.generate "wayvr.yaml" {
    version = 1;
    run_compositor_at_start = false;

    auto_hide = true;
    auto_hide_delay = 750;

    keyboard_repeat_delay = 200;
    keyboard_repeat_rate = 50;

    dashboard = {
      exec = lib.getExe pkgs.wayvr-dashboard;
      env = [ "GDK_BACKEND=wayland" ];
    };

    displays = {
      watch = {
        width = 600;
        height = 400;
        scale = 0.5;
        attach_to = "HandRight";
        pos = [
          0.0
          0.0
          0.125
        ];
        rotation = {
          axis = [
            1.0
            0.0
            0.0
          ];
          angle = 45.0;
        };
      };

    };

    catalogs.default_catalog.apps = [
      {
        name = "Btop";
        target_display = "watch";
        exec = lib.getExe pkgs.alacritty;
        args = "-e ${lib.getExe pkgs.btop}";
      }
      {
        name = "Vesktop";
        target_display = "disp2";
        exec = lib.getExe pkgs.vesktop;
      }
      {
        name = "Firefox";
        target_display = "disp1";
        exec = lib.getExe pkgs.firefox;
      }
    ];
  };

  hm.xdg.configFile."wlxoverlay/conf.d/font.yaml".source = yaml.generate "font.yaml" {
    primary_font = "Cascadia Cove:weight=150";
  };

  hm.xdg.configFile."wlxoverlay/conf.d/skybox.yaml".source = yaml.generate "skybox.yaml" {
    use_skybox = true;
    #use_passthrough = false;

    # for a custom skybox texture
    skybox_texture = "/home/tayou/nix/resources/aurorasky.dds";
  };

  hm.xdg.configFile."wlxoverlay/conf.d/clock.yaml".source = yaml.generate "clock.yaml" {
    timezones = [
      "Europe/Berlin"
    ];
    clock_12h = false;
  };

  hm.xdg.configFile."wlxoverlay/openxr_actions.json5".source = ./wlx_openxr_actions.json5;

  hm.xdg.configFile."wlxoverlay/icons.dds".source = ./icons.dds;

  hm.xdg.configFile."wlxoverlay/watch.yaml".source = yaml.generate "watch.yaml" {
    width = 0.1;

    size = [
      300
      264
    ];

    elements = [
      # Settings
      {
        bg_color = "#24273a";
        corner_radius = 20;
        rect = [
          0
          0
          300
          150
        ];
        type = "Panel";
      }
      {
        bg_color = "#24273a";
        click_up = [
          {
            action = "ShowUi";
            target = "settings";
            type = "Window";
          }
          {
            action = "Destroy";
            target = "settings";
            type = "Window";
          }
        ];
        corner_radius = 4;
        fg_color = "#24273a";
        font_size = 15;
        rect = [
          232
          42
          32
          32
        ];
        text = "";
        type = "Button";
      }
      {
        rect = [
          231
          42
          32
          32
        ];
        sprite = "icons.dds";
        sprite_st = [
          0.25
          0.25
          0
          0.5
        ];
        type = "Sprite";
      }
      # Wayvr dashboard
      {
        bg_color = "#24273a";
        click_up = [
          {
            action = "ToggleDashboard";
            type = "WayVR";
          }
        ];
        corner_radius = 4;
        fg_color = "#24273a";
        font_size = 15;
        rect = [
          267
          230
          32
          32
        ];
        text = "";
        type = "Button";
      }
      {
        rect = [
          267
          230
          32
          32
        ];
        sprite = "icons.dds";
        sprite_st = [
          0.25
          0.25
          0
          0
        ];
        type = "Sprite";
      }
      # Keyboard
      {
        bg_color = "#24273a";
        click_up = [
          {
            action = "ToggleVisible";
            target = "kbd";
            type = "Overlay";
          }
        ];
        corner_radius = 4;
        fg_color = "#24273a";
        font_size = 15;
        long_click_up = [
          {
            action = "Reset";
            target = "kbd";
            type = "Overlay";
          }
        ];
        middle_up = [
          {
            action = "ToggleInteraction";
            target = "kbd";
            type = "Overlay";
          }
        ];
        rect = [
          200
          42
          32
          32
        ];
        right_up = [
          {
            action = "ToggleImmovable";
            target = "kbd";
            type = "Overlay";
          }
        ];
        scroll_down = [
          {
            action.Opacity.delta = -0.025;
            target = "kbd";
            type = "Overlay";
          }
        ];
        scroll_up = [
          {
            action.Opacity.delta = 0.025;
            target = "kbd";
            type = "Overlay";
          }
        ];
        text = "";
        type = "Button";
      }
      {
        rect = [
          200
          42
          32
          32
        ];
        sprite = "icons.dds";
        sprite_st = [
          0.25
          0.25
          0.25
          0.5
        ];
        type = "Sprite";
      }
      # Exit button
      {
        bg_color = "#24273a";
        click_down = [
          {
            command = [
              "systemctl"
              "--user"
              "stop"
              "monado.service"
            ];
            type = "Exec";
          }
        ];
        corner_radius = 20;
        fg_color = "#24273a";
        font_size = 13;
        rect = [
          270
          0
          30
          30
        ];
        text = "";
        type = "Button";
      }
      {
        rect = [
          270
          0
          30
          30
        ];
        sprite = "icons.dds";
        sprite_st = [
          0.25
          0.25
          0.5
          0.5
        ];
        type = "Sprite";
      }
      # Overlay list
      {
        bg_color = "#1e2030";
        click_up = "ToggleVisible";
        corner_radius = 4;
        fg_color = "#cad3f5";
        font_size = 15;
        layout = "Horizontal";
        long_click_up = "Reset";
        middle_up = "ToggleInteraction";
        rect = [
          0
          152
          300
          38
        ];
        right_up = "ToggleImmovable";
        scroll_down.Opacity.delta = -0.025;
        scroll_up.Opacity.delta = 0.025;
        type = "OverlayList";
      }
      # Wayvr applications
      {
        bg_color = "#e590c4";
        catalog_name = "default_catalog";
        corner_radius = 4;
        fg_color = "#24273a";
        font_size = 15;
        rect = [
          0
          192
          300
          36
        ];
        type = "WayVRLauncher";
      }
      # Wayvr displays
      {
        bg_color = "#e590c4";
        corner_radius = 4;
        fg_color = "#24273a";
        font_size = 15;
        rect = [
          0
          228
          263
          36
        ];
        type = "WayVRDisplayList";
      }
      # Date - hour:minute
      {
        corner_radius = 4;
        fg_color = "#cad3f5";
        font_size = 46;
        format = "%H:%M";
        rect = [
          8
          80
          200
          50
        ];
        source = "Clock";
        type = "Label";
      }
      # Date - locale date rep
      {
        corner_radius = 4;
        fg_color = "#cad3f5";
        font_size = 14;
        format = "%x";
        rect = [
          10
          119
          200
          20
        ];
        source = "Clock";
        type = "Label";
      }
      # Date - day name
      {
        corner_radius = 4;
        fg_color = "#cad3f5";
        font_size = 14;
        format = "%A";
        rect = [
          10
          139
          200
          50
        ];
        source = "Clock";
        type = "Label";
      }
      # Battery list
      {
        corner_radius = 4;
        fg_color = "#8bd5ca";
        fg_color_charging = "#6080A0";
        fg_color_low = "#ff7785";
        font_size = 16;
        layout = "Horizontal";
        low_threshold = 33;
        num_devices = 9;
        rect = [
          0
          5
          400
          30
        ];
        type = "BatteryList";
      }
      # Volume down
      {
        bg_color = "#5BCEFA";
        click_down = [
          {
            command = [
              (lib.getExe' pkgs.pulseaudio "pactl")
              "set-sink-volume"
              "@DEFAULT_SINK@"
              "-5%"
            ];
            type = "Exec";
          }
        ];
        corner_radius = 4;
        fg_color = "#24273a";
        font_size = 13;
        rect = [
          110
          108
          32
          32
        ];
        text = "";
        type = "Button";
      }
      {
        rect = [
          114
          112
          24
          24
        ];
        sprite = "icons.dds";
        sprite_st = [
          0.25
          0.25
          0.25
          0
        ];
        type = "Sprite";
      }
      # Media previous
      {
        bg_color = "#F5A9B8";
        click_down = [
          {
            command = [
              (lib.getExe pkgs.playerctl)
              "previous"
            ];
            type = "Exec";
          }
        ];
        corner_radius = 4;
        fg_color = "#24273a";
        font_size = 13;
        rect = [
          146
          108
          32
          32
        ];
        text = "";
        type = "Button";
      }
      {
        rect = [
          150
          112
          24
          24
        ];
        sprite = "icons.dds";
        sprite_st = [
          0.25
          0.25
          0
          0.25
        ];
        type = "Sprite";
      }
      # Media play/pause
      {
        bg_color = "#FFFFFF";
        click_down = [
          {
            command = [
              (lib.getExe pkgs.playerctl)
              "play-pause"
            ];
            type = "Exec";
          }
        ];
        corner_radius = 4;
        fg_color = "#24273a";
        font_size = 13;
        rect = [
          182
          108
          32
          32
        ];
        text = "";
        type = "Button";
      }
      {
        rect = [
          186
          112
          24
          24
        ];
        sprite = "icons.dds";
        sprite_st = [
          0.25
          0.25
          0.25
          0.25
        ];
        type = "Sprite";
      }
      # Media next
      {
        bg_color = "#F5A9B8";
        click_down = [
          {
            command = [
              (lib.getExe pkgs.playerctl)
              "next"
            ];
            type = "Exec";
          }
        ];
        corner_radius = 4;
        fg_color = "#24273a";
        font_size = 13;
        rect = [
          218
          108
          32
          32
        ];
        text = "";
        type = "Button";
      }
      {
        rect = [
          222
          112
          24
          24
        ];
        sprite = "icons.dds";
        sprite_st = [
          0.25
          0.25
          0.5
          0.25
        ];
        type = "Sprite";
      }
      # Vol up
      {
        bg_color = "#5BCEFA";
        click_down = [
          {
            command = [
              (lib.getExe' pkgs.pulseaudio "pactl")
              "set-sink-volume"
              "@DEFAULT_SINK@"
              "+5%"
            ];
            type = "Exec";
          }
        ];
        corner_radius = 4;
        fg_color = "#24273a";
        font_size = 13;
        rect = [
          254
          108
          32
          32
        ];
        text = "";
        type = "Button";
      }
      {
        rect = [
          258
          112
          24
          24
        ];
        sprite = "icons.dds";
        sprite_st = [
          0.25
          0.25
          0.5
          0
        ];
        type = "Sprite";
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    wlx-overlay-s
    wayvr-dashboard
  ];
}
