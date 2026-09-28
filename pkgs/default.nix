{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];

  perSystem =
    { pkgs, inputs', ... }:
    {
      overlayAttrs = {
        local = {
          startvrc = pkgs.callPackage ./startvrc {};
          writeSystemdToggle = pkgs.callPackage ./writeSystemdToggle {};
          xrizer = pkgs.callPackage ./xrizer {};
          vrcx = pkgs.callPackage ./vrcx/package.nix {};
          cbftp = pkgs.cbftp.overrideAttrs (old: {
            version = "1301";
            src = pkgs.fetchurl {
              url = "https://cbftp.glftpd.io/cbftp-r1301.tar.gz";
              hash = "sha256-jdI820Mbb1Okfr2LR4h9szBPb9/u1mTmJ/+cUnInd6o=";
            };
          });
          # give unity a lower priority so it doesn't lag as much
          unityhub = pkgs.unityhub.overrideAttrs (old: {
            postInstall = (old.postInstall or "") + ''
              mkdir -p $out/bin

              # Wrap the unityhub executable
              mv $out/bin/unityhub $out/bin/unityhub.real
              cat > $out/bin/unityhub << 'EOF'
              #!/bin/sh
              exec systemd-run --scope --slice=user-background.slice \
                nice -n 10 $out/bin/unityhub.real "$@"
              EOF
              chmod +x $out/bin/unityhub
            '';
          });
        };
        watchmanPairingAssistant = inputs'.watchman-pairing-assistant.packages.default;
        kdePackages = pkgs.kdePackages.overrideScope (
          kdeFinal: kdePrev: {
            plasma-login-manager =
              kdePrev.plasma-login-manager.overrideAttrs (oldAttrs: {
                patches = (oldAttrs.patches or [ ]) ++ [
                  ./0000-just-dont-timeout.patch
                ];
              });
          }
        );
      };
    };
}
