{ pkgs, config, ... }:

{
  hm.xdg.configFile."openxr/1/active_runtime.json".source =
    "${config.services.wivrn.package}/share/openxr/1/openxr_wivrn.json";

  environment.systemPackages = [ pkgs.monado-vulkan-layers ];

  hardware.graphics.extraPackages = [ pkgs.monado-vulkan-layers ];

  services.wivrn = {
    enable = true;
    openFirewall = true;

    # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
    # will automatically read this and work with WiVRn (Note: This does not currently
    # apply for games run in Valve's Proton)
    defaultRuntime = true;
    autoStart = false;

    # Config for WiVRn (https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md)
    config = {
      enable = true;
      json.tcp_only = false;
    };
  };
}
