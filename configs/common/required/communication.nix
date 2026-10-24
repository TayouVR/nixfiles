{
  pkgs,
  ...
}:
let
  withGermanLang =
    pkg:
    pkgs.symlinkJoin {
      name = pkg.pname or pkg.name;
      paths = [ pkg ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        for bin in $out/bin/*; do
          wrapProgram "$bin" \
            --set LANG de_DE.UTF-8
        done
      '';
    };
in
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
      # ladybird # broken
      servo
      tor-browser

      # Email
      thunderbird

      # telephony (SIP Phone Calls)
      twinkle
      #jitsi # dropped due to old gtk2 libs

      # Chat and messaging
      (withGermanLang (discord.override { withVencord = true; }))
      (withGermanLang vesktop)
      (withGermanLang equibop)
      telegram-desktop
      jami
      cinny-desktop
      sable # fork of cinny
      local.sablenext
      #kdePackages.neochat # - build failure because of olm dependency
      element-desktop
      fluffychat
      beeper
      signal-desktop
      mumble

      # File sharing
      localsend
    ];

    networking.firewall = {
      allowedTCPPorts = [ 53317 ];
      allowedUDPPorts = [ 53317 ];
    };
  };
}
