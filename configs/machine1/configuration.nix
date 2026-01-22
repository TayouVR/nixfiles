# Machine-specific configuration for tayou-berlin
{
  pkgs,
  hm,
  ...
}:
let
  json = pkgs.formats.json { };
in
{
  # Enable envision program
  programs.envision.enable = true;

  # Machine-specific packages
  environment.systemPackages = with pkgs; [

    # Other
    qbittorrent
    parabolic
    yt-dlp

    qemu
    virt-manager
    virtiofsd

    picard

    podman
    podman-compose
    distrobox
  ];

  # allow podman to pull any image it wants. I can limit here where it can pull from.
  # docs: https://docs.podman.io/en/latest/markdown/podman-image-trust.1.html
  hm.xdg.configFile."containers/policy.json".source = json.generate "policy.json" {
    default = [
      {
        type = "insecureAcceptAnything";
      }
    ];
  };

  networking.extraHosts = "192.168.178.64 homeassistant";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
