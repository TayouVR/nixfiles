{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        darkly = pkgs.callPackage ./darkly/package.nix {};
        klassy = pkgs.callPackage ./klassy/package.nix {};
      };
    };
}
