{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.tayouflake.audio = {
  };

  config = {
    # Enable sound with pipewire
    security.rtkit.enable = true;
    services = {
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;
      };
    };

    # Audio-related packages
    environment.systemPackages = with pkgs; [
      qpwgraph  # PipeWire graph manager
      easyeffects
    ];
  };
}
