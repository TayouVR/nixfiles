{
  pkgs,
  ...
}:
{
  config = {
    # libolm is insecure, but is needed as dep for many matrix clients.
    # remove this exception and look at build log to see more details
    # this exception didn't work... I don't need neochat that much I guess lol
#    nixpkgs.config.permittedInsecurePackages = [
#      "olm-3.2.16"
#    ];

    # Communication and social media packages
    environment.systemPackages = with pkgs; [
      # Web browsers
      firefox
      chromium
      kdePackages.falkon

      # Email
      thunderbird

      # Chat and messaging
      discord
      vesktop
      telegram-desktop
      jami-client-qt
      cinny-desktop
      #kdePackages.neochat
      element-desktop

      # File sharing
      localsend
    ];
  };
}
