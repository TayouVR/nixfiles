{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];

  perSystem =
    { pkgs, inputs', ... }:
    let
      millennium = pkgs.callPackage ./millennium/millennium.nix {
        inherit (inputs) millennium-src luajit-src;
      };
    in
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
          millennium-steam = pkgs.callPackage ./millennium/steam.nix {
            inherit millennium;
          };
        };
        watchmanPairingAssistant = inputs'.watchman-pairing-assistant.packages.default;
      };
    };
}
