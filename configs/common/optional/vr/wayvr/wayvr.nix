{
  lib,
  pkgs,
  config,
  username,
  ...
}:

let
  yaml = pkgs.formats.yaml { };

  wayvrExtrasScript = pkgs.writeShellScript "wayvrExtrasScript.sh" ''
    # Define paths to binaries via Nix
    AWK="${pkgs.gawk}/bin/awk"
    GREP="${pkgs.gnugrep}/bin/grep"
    SLEEP="${pkgs.coreutils}/bin/sleep"
    AMD_SMI="${pkgs.rocmPackages.amdsmi}/bin/amd-smi"
    WAYVRCTL="${pkgs.wayvr}/bin/wayvrctl"

    #Checks if running script natively or with variable
    if [ $# -eq 0 ]; then
        #System Stats
        if [ -d $HOME/.config/wayvr/theme/gui/states/ ]; then
            rm -rf $HOME/.config/wayvr/theme/gui/states/*
            touch $HOME/.config/wayvr/theme/gui/states/perfStats.state;
        fi

        while :
        do
            DEBUG_MODE=0
            CPU_USAGE=$($AWK '{u=$2+$4; t=$2+$4+$5; if(NR==1){u1=u;t1=t} else printf "%.2f%%\n", int(($2+$4-u1)*100/(t-t1)*100)/100}' <($GREP 'cpu ' /proc/stat) <($SLEEP 1; $GREP 'cpu ' /proc/stat))
            RAM_USAGE=$($AWK '/MemTotal/{t=$2}/MemAvailable/{a=$2}END{u=(t-a)/1024/1024; printf "%.2fGB/%.2fGB\n", u, t/1024/1024}' /proc/meminfo)
            GPU_USAGE=$($AMD_SMI 2>/dev/null | $AWK 'NR==10 {match($0, /([0-9.]+) %/, a); print a[1] "%"; exit}')
            VRAM_USAGE=$($AMD_SMI 2>/dev/null | $AWK 'NR==10 {match($0, /([0-9]+)\/([0-9]+) MB/, a); printf "%.2fGB/%.2fGB\n", a[1]/1024, a[2]/1024; exit}')
            if [ $DEBUG_MODE -eq 0 ]
            then
                {
                    echo "panel-modify watch cpustat set-text \"CPU: $CPU_USAGE\""
                    echo "panel-modify watch ramstat set-text \"RAM: $RAM_USAGE\""
                    echo "panel-modify watch gpustat set-text \"GPU: $GPU_USAGE\""
                    echo "panel-modify watch vramstat set-text \"VRAM: $VRAM_USAGE\""
                } | $WAYVRCTL batch
            else
                echo "CPU: $CPU_USAGE"
                echo "RAM: $RAM_USAGE"
                echo "GPU: $GPU_USAGE"
                echo "VRAM: $VRAM_USAGE"
            fi
            $SLEEP 1
        done
    else
        set -e
        FILE="perfStats.state"
        if [ -f $HOME/.config/wayvr/theme/gui/states/$FILE ]; then
                $WAYVRCTL panel-modify watch "perfStats" set-visible 1;
                rm $HOME/.config/wayvr/theme/gui/states/$FILE;
        else
            $WAYVRCTL panel-modify watch "perfStats" set-visible 0;
            touch $HOME/.config/wayvr/theme/gui/states/$FILE;
        fi
    fi
  '';
in

{
  systemd.user.services.wayvr =
    lib.recursiveUpdate
      {
        description = "WayVR service";

        unitConfig.ConditionUser = "!root";

        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.wayvr} --openxr";
          ExecStartPost = "${wayvrExtrasScript}";
          Restart = "on-failure";
          Type = "simple";
        };

        environment.XR_RUNTIME_JSON = "${config.hm.xdg.configHome}/openxr/1/active_runtime.json";

        restartTriggers = [ pkgs.wayvr ];
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

  hm.xdg.configFile."wayvr/wayvr.yaml".source = yaml.generate "wayvr.yaml" {
    version = 1;
    run_compositor_at_start = false;

    auto_hide = true;
    auto_hide_delay = 750;

    keyboard_repeat_delay = 200;
    keyboard_repeat_rate = 50;

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
  };

  hm.xdg.configFile."wayvr/conf.d/font.yaml".source = yaml.generate "font.yaml" {
    primary_font = "Cascadia Cove:weight=150";
  };

  hm.xdg.configFile."wayvr/conf.d/skybox.yaml".source = yaml.generate "skybox.yaml" {
    use_skybox = true;
    #use_passthrough = false;

    # for a custom skybox texture
    skybox_texture = "/home/tayou/nix/resources/aurorasky.dds";
  };

  hm.xdg.configFile."wayvr/conf.d/clock.yaml".source = yaml.generate "clock.yaml" {
    timezones = [
      "Europe/London"
      "America/New_York"
      "America/Los_Angeles"
      "Asia/Tokyo"
    ];
    clock_12h = false;
  };

#  hm.xdg.configFile."wayvr/conf.d/theme.yaml".source = yaml.generate "clock.yaml" {
#    color_accent = "#008cff";
#    color_danger = "#ff3300";
#    color_faded = "#668299";
#  };

  hm.xdg.configFile."wayvr/openxr_actions.json5".source = ./wayvr_openxr_actions.json5;

  hm.xdg.configFile."wayvr/theme/gui/assets".source = ./assets;
  hm.xdg.configFile."wayvr/theme/gui/watch.xml".text = ''
    <layout>
        <theme>
            <var key="set_color" value="#cad3f5" />
            <var key="bgcolor" value="#181818d5" />
            <var key="buttoncolor" value="#282828d5" />

            <var key="clock0_color" value="#cad3f5" />
            <var key="clock0_size" value="46" />
            <var key="clock0_date_size" value="16" />
            <var key="clock0_dow_size" value="16" />
            <var key="clock_alt1_color" value="#8bd5ca" />
            <var key="clock_alt2_color" value="#b7bdf8" />
            <var key="clock_alt_size" value="24" />
            <var key="clock_alt_tz_size" value="14" />
        </theme>

        <macro name="decorative_rect"
               padding="8" color="~bgcolor"
               border="0" round="8" />

        <macro name="button_style"
               padding="8" round="8" color="~buttoncolor" border="0"
               align_items="center" justify_content="center" />

        <template name="Device">
            <rectangle macro="decorative_rect" padding_top="4" padding_bottom="4" align_items="center" gap="8">
                <sprite width="32" height="32" src_builtin="''${src}" />
                <label _source="battery" _device="''${idx}" size="24" weight="bold" />
            </rectangle>
        </template>

        <template name="Hmd">
            <Device idx="''${idx}" src="watch/hmd.svg" />
        </template>
        <template name="LeftHand">
            <Device idx="''${idx}" src="watch/controller_l.svg" />
        </template>
        <template name="RightHand">
            <Device idx="''${idx}" src="watch/controller_r.svg" />
        </template>
        <template name="Tracker">
            <Device idx="''${idx}" src="watch/track.svg" />
        </template>

        <template name="Overlay">
            <Button macro="button_style" id="overlay_''${idx}"
                    tooltip="WATCH.TOGGLE_FOR_CURRENT_SET" _press="::EditModeOverlayToggle ''${idx}"
                    align_items="center"
                    height="40">
                <sprite id="overlay_''${idx}_sprite" src_builtin="''${src}" width="32" height="32" />
                <label id="overlay_''${idx}_label" text="WLX-''${idx}" size="18" />
            </Button>
        </template>

        <template name="Set">
            <Button macro="button_style" id="set_''${idx}" _press="::SetToggle ''${idx}" tooltip="WATCH.SWITCH_TO_SET" tooltip_side="top">
                <sprite width="40" height="40" color="~set_color" src_builtin="watch/set2.svg" />
                <div position="absolute" margin_top="9">
                    <label text="''${display}" size="24" color="#00050F" weight="bold" />
                </div>
            </Button>
        </template>

        <!--
          [!!!!!!!!] Disclaimer [!!!!!!!!]
          Elements with id="norm_*" show in normal mode.
          Elements with id="edit_*" show in edit mode.
        -->
        <elements>
            <!-- padding="32" is required there (to make room for tooltips) -->
            <div padding="32" interactable="0" flex_direction="column" gap="8">
                <!-- Top elements (device battery levels) -->
                <div id="devices_root" interactable="0" gap="6" width="100%" max_width="600" flex_direction="row" flex_wrap="wrap">
                    <!-- Will populate tags at runtime -->
                    <!-- These are examples for uidev -->
                    <Hmd idx="0" />
                    <LeftHand idx="1" />
                    <RightHand idx="2" />
                    <Tracker idx="3" />
                </div>

                <!-- All other elements inside the container -->
                <div flex_direction="column" gap="8">
                    <div flex_direction="row" gap="4">
                        <rectangle macro="decorative_rect" flex_direction="row" id="norm_pane" gap="8">
                            <!-- Clock, date and various timezones -->
                            <div gap="8">
                                <div flex_direction="column">
                                    <label text="23:59:59" _source="clock" _display="%H:%M:%S" color="~clock0_color" size="~clock0_size" weight="bold" />
                                    <div padding="2" gap="2" flex_direction="column">
                                        <label text="22/2/2022" _source="clock" _display="date" color="~clock0_color" size="~clock0_date_size" weight="bold" />
                                        <label text="Tuesday" _source="clock" _display="dow" color="~clock0_color" size="~clock0_dow_size" weight="bold" />
                                    </div>
                                    <div flex_direction="row" gap="8">
                                        <label text="In VR since" />
                                        <label _source="timer" _format="%h:%m:%s" />
                                    </div>
                                    <div flex_direction="row" gap="8">
                                        <!-- Timezone names here are only placeholders. Set your timezones via ~/.config/wlxoverlay/conf.d -->
                                        <div flex_direction="column">
                                            <label text="Paris" _source="clock" _display="name" _timezone="0" color="~clock_alt1_color" size="~clock_alt_tz_size" weight="bold" />
                                            <label text="23:59" _source="clock" _display="time" _timezone="0" color="~clock_alt1_color" size="~clock_alt_size" weight="bold" />
                                        </div>
                                        <div flex_direction="column">
                                            <label text="New York" _source="clock" _display="name" _timezone="1" color="~clock_alt2_color" size="~clock_alt_tz_size" weight="bold" />
                                            <label text="23:59" _source="clock" _display="time" _timezone="1" color="~clock_alt2_color" size="~clock_alt_size" weight="bold" />
                                        </div>
                                    </div>
                                    <div flex_direction="row" gap="8">
                                        <!-- Timezone names here are only placeholders. Set your timezones via ~/.config/wlxoverlay/conf.d -->
                                        <div flex_direction="column">
                                            <label text="Paris" _source="clock" _display="name" _timezone="2" color="~clock_alt1_color" size="~clock_alt_tz_size" weight="bold" />
                                            <label text="23:59" _source="clock" _display="time" _timezone="2" color="~clock_alt1_color" size="~clock_alt_size" weight="bold" />
                                        </div>
                                        <div flex_direction="column">
                                            <label text="New York" _source="clock" _display="name" _timezone="3" color="~clock_alt2_color" size="~clock_alt_tz_size" weight="bold" />
                                            <label text="23:59" _source="clock" _display="time" _timezone="13" color="~clock_alt2_color" size="~clock_alt_size" weight="bold" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Four buttons -->
                            <div flex_direction="column" gap="8">
                                <div gap="8">
                                    <Button macro="button_style" _press="::NewMirror" tooltip="WATCH.MIRROR" tooltip_side="left">
                                        <sprite width="40" height="40" color="~set_color" src="edit/mirror.svg" />
                                    </Button>
                                    <Button macro="button_style" _press="::CleanupMirrors" tooltip="WATCH.CLEANUP_MIRRORS" tooltip_side="left">
                                        <sprite width="40" height="40" color="~set_color" src="watch/mirror-off.svg" />
                                    </Button>
                                    <Button macro="button_style" _press="::ShellExec ${lib.getExe' pkgs.pulseaudio "pactl"} set-sink-volume @DEFAULT_SINK@ +5%" tooltip="MEDIA.VOL_UP" tooltip_side="left">
                                        <sprite width="40" height="40" color="~set_color" src="/home/${ username }/.config/wayvr/theme/gui/assets/media/volup.svg" />
                                    </Button>
                                </div>
                                <div gap="8">
                                    <Button macro="button_style" _press="::PlayspaceRecenter" tooltip="WATCH.RECENTER" tooltip_side="left">
                                        <sprite width="40" height="40" color="~set_color" src="watch/recenter.svg" />
                                    </Button>
                                    <Button macro="button_style" _press="::PlayspaceFixFloor" tooltip="WATCH.FIX_FLOOR" tooltip_side="left">
                                        <sprite width="40" height="40" color="~set_color" src="watch/fix-floor.svg" />
                                    </Button>
                                    <Button macro="button_style" _press="::ShellExec ${lib.getExe' pkgs.pulseaudio "pactl"} set-sink-volume @DEFAULT_SINK@ -5%" tooltip="MEDIA.VOL_DOWN" tooltip_side="left">
                                        <sprite width="40" height="40" color="~set_color" src="/home/${ username }/.config/wayvr/theme/gui/assets/media/voldown.svg" />
                                    </Button>
                                </div>
                                <div gap="8">
                                    <Button macro="button_style" _press="::ShellExec ${lib.getExe pkgs.playerctl} previous" tooltip="MEDIA.PREVIOUS" tooltip_side="left">
                                        <sprite width="40" height="40" color="~set_color" src="/home/${ username }/.config/wayvr/theme/gui/assets/media/previous.svg" />
                                    </Button>
                                    <Button macro="button_style" _press="::ShellExec ${lib.getExe pkgs.playerctl} play-pause" tooltip="MEDIA.PAUSE_PLAY" tooltip_side="left">
                                        <sprite width="40" height="40" color="~set_color" src="/home/${ username }/.config/wayvr/theme/gui/assets/media/play.svg" />
                                    </Button>
                                    <Button macro="button_style" _press="::ShellExec ${lib.getExe pkgs.playerctl} next" tooltip="MEDIA.NEXT" tooltip_side="left">
                                        <sprite width="40" height="40" color="~set_color" src="/home/${ username }/.config/wayvr/theme/gui/assets/media/skip.svg" />
                                    </Button>
                                </div>
                            </div>
                        </rectangle>
                        <rectangle id="perfStats" macro="decorative_rect" flex_direction="row" gap="8" justify_content="space_evenly" min_width="100" display="none" >
                            <div flex_direction="column" gap="2">
                                <label id="cpustat" text="CPU: RUN"/>
                                <label id="ramstat" text="RAM: THE"/>
                                <label id="gpustat" text="GPU: SCRIPT!"/>
                                <label id="vramstat" text="VRAM: Meow~"/>
                            </div>
                        </rectangle>
                    </div>

                    <rectangle macro="decorative_rect" flex_direction="column" id="edit_pane" display="none" gap="8">
                        <div flex_direction="column" padding="4" align_items="center" justify_content="center">
                            <label translation="WATCH.EDIT_MODE_EXPLANATION" align="center" />
                        </div>
                        <div flex_direction="column" align_items="center" justify_content="center">
                            <div id="toolbox" gap="8" width="100%" max_width="400" flex_direction="row" flex_wrap="wrap">
                                <Button id="btn_keyboard" height="40" macro="button_style" tooltip="WATCH.TOGGLE_FOR_CURRENT_SET" _press="::OverlayToggle kbd" >
                                    <sprite src_builtin="watch/keyboard.svg" width="32" height="32" />
                                    <label translation="EDIT_MODE.KEYBOARD" size="18" />
                                </Button>
                                <!-- Src here may be changed, but maintain `OverlayCategory` order: Panel, Screen, Mirror, WayVR -->
                                <Overlay src="edit/panel.svg" idx="0" />
                                <Overlay src="edit/screen.svg" idx="1" />
                                <Overlay src="edit/mirror.svg" idx="2" />
                                <Overlay src="edit/wayvr.svg" idx="3" />
                                <!-- Will populate additional <Overlay> tags at runtime -->
                            </div>
                        </div>
                    </rectangle>

                    <!-- Bottom buttons -->
                    <div flex_direction="row" gap="4">
                        <div gap="4">
                            <Button id="btn_dashboard" macro="button_style" _press="::DashToggle" tooltip="WATCH.DASHBOARD" tooltip_side="top">
                                <sprite color="~color_text" width="40" height="40" src="watch/wayvr_dashboard_mono.svg" />
                            </Button>
                        </div>
                        <VerticalSeparator />
                        <div id="sets_root" gap="4">
                            <!-- Will populate tags at runtime -->
                            <!-- These are examples for uidev -->
                            <Set idx="0" display="1" />
                            <Set idx="1" display="2" />
                        </div>
                        <div id="panels_root" gap="4" display="none">
                            <!-- Will populate tags at runtime -->
                            <!-- These are examples for uidev -->
                            <Screen idx="0" display="H1" name="HDMI-A-1" />
                            <Screen idx="1" display="D2" name="DP-2"/>
                        </div>
                        <Button id="btn_edit_mode" macro="button_style" _press="::EditToggle" tooltip="WATCH.EDIT_MODE" tooltip_side="top">
                            <sprite color="~set_color" width="40" height="40" src="watch/edit.svg" />
                        </Button>
                    </div>
                </div>
            </div>
        </elements>
    </layout>
  '';

  environment.systemPackages = with pkgs; [
    wayvr
  ];
}
