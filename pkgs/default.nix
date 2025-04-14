{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        darkly = pkgs.callPackage ./darkly {};
        klassy = pkgs.callPackage ./klassy {};
        startvrc = pkgs.callPackage ./startvrc {};
      };
    };
}
