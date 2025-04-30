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
          darkly = pkgs.callPackage ./darkly {};
          klassy = pkgs.callPackage ./klassy {};
          startvrc = pkgs.callPackage ./startvrc {};
          writeSystemdToggle = pkgs.callPackage ./writeSystemdToggle { };
        };
      };
    };
}
