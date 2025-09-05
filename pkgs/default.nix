{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];

  perSystem =
    { pkgs, ... }:
    {
      overlayAttrs = {
        local = {
          klassy = pkgs.callPackage ./klassy {};
          startvrc = pkgs.callPackage ./startvrc {};
          writeSystemdToggle = pkgs.callPackage ./writeSystemdToggle { };
          xrizer = pkgs.callPackage ./xrizer {};
        };
      };
    };
}
