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
          klassy = pkgs.callPackage ./klassy {};
          startvrc = pkgs.callPackage ./startvrc {};
          writeSystemdToggle = pkgs.callPackage ./writeSystemdToggle {};
          xrizer = pkgs.callPackage ./xrizer {};
          vrcx = pkgs.callPackage ./vrcx/package.nix {};
        };
        watchmanPairingAssistant = inputs'.watchman-pairing-assistant.packages.default;
      };
    };
}
