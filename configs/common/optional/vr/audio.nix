{
  # expanded so i can compare it easily with the actual config
  # and understand it better
  services.pipewire.wireplumber.extraConfig."99-valve-index" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            # wpctl status -> wpctl inspect <id>
            "object.path" = "alsa:acp:HDMI:5:playback";
          }
        ];
        actions = {
          update-props = {
            "api.alsa.period-size" = 2048;
            "api.alsa.headroom" = 8192;
          };
        };
      }
    ];
  };
}
