{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];

  perSystem =
    { pkgs, inputs', ... }:
    {
      overlayAttrs = {
        # alcom broke upstream, fixed in https://github.com/NixOS/nixpkgs/pull/585045
        # backport of upstream PR until this lands in unstable.
        alcom = pkgs.alcom.overrideAttrs (old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.aws-lc ];
        });
        vrc-get = pkgs.vrc-get.overrideAttrs (old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.aws-lc ];
        });
        local = {
          startvrc = pkgs.callPackage ./startvrc {};
          writeSystemdToggle = pkgs.callPackage ./writeSystemdToggle {};
          xrizer = pkgs.callPackage ./xrizer {};
          vrcx = pkgs.callPackage ./vrcx/package.nix {};
          oscinator = pkgs.callPackage ./oscinator {};
          cbftp = pkgs.cbftp.overrideAttrs (old: {
            version = "1301";
            src = pkgs.fetchurl {
              url = "https://cbftp.glftpd.io/cbftp-r1301.tar.gz";
              hash = "sha256-jdI820Mbb1Okfr2LR4h9szBPb9/u1mTmJ/+cUnInd6o=";
            };
          });
          sablenext = pkgs.callPackage ./sable {};
          unitypackage_extractor = pkgs.callPackage ./unitypackage_extractor {};
          # give unity a lower priority so it doesn't lag as much
          unityhub = pkgs.unityhub.overrideAttrs (old: {
            postInstall = (old.postInstall or "") + ''
              mkdir -p $out/bin
              rm -f $out/bin/unityhub
              cat > $out/bin/unityhub <<EOF
              #!${pkgs.runtimeShell}
              exec systemd-run --scope --slice=user-background.slice \
                nice -n 10 $out/opt/unityhub/unityhub "\$@"
              EOF
              chmod +x $out/bin/unityhub
            '';
          });
        };
        watchmanPairingAssistant = inputs'.watchman-pairing-assistant.packages.default;
        miband-heartrate-gui = inputs'.miband-heartrate.packages.miband-heartrate-gui;
        miband-heartrate-cli = inputs'.miband-heartrate.packages.miband-heartrate-cli;
        kdePackages = pkgs.kdePackages.overrideScope (
          kdeFinal: kdePrev: {
            plasma-login-manager =
              kdePrev.plasma-login-manager.overrideAttrs (oldAttrs: {
                patches = (oldAttrs.patches or [ ]) ++ [
                  ./0000-just-dont-timeout.patch
                ];
              });
            # Keep pinned launchers as applications:<menuId> instead of the
            # resolved absolute path to a wrapper-internal binary (e.g. NixOS
            # makeWrapper/makeBinaryWrapper apps like gitcomet), which goes
            # stale on updates and bypasses the wrapper's env. See KDE bug 505066.
            plasma-workspace =
              kdePrev.plasma-workspace.overrideAttrs (oldAttrs: {
                patches = (oldAttrs.patches or [ ]) ++ [
                  ./0001-launchertasksmodel-prefer-menuid.patch
                ];
              });
          }
        );
      };
    };
}
