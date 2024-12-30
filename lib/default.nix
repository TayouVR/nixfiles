{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./deps.nix
  ];

  _module.args.nLib = {
    # pkg -> attrs -> deriv
    overrideAppimageTools =
      pkg: finalAttrs:
      (pkg.override {
        appimageTools = pkgs.appimageTools // {
          wrapType2 = args: pkgs.appimageTools.wrapType2 (args // finalAttrs);
        };
      });

    # [ String ] -> deriv -> attrs
    mapDefaultForMimeTypes = mimeTypes: pkg: lib.genAttrs mimeTypes (_: "${lib.getName pkg}.desktop");

    # String -> String -> deriv
    mkProtonGeBin =
      version: hash:
      (pkgs.proton-ge-bin.overrideAttrs {
        inherit version;
        src = pkgs.fetchzip {
          url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
          inherit hash;
        };
      });

    # String -> String
    toUppercase =
      str:
      (lib.strings.toUpper (builtins.substring 0 1 str))
      + builtins.substring 1 (builtins.stringLength str) str;
  };
}
