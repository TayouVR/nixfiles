{ lib, config, ... }:

let
  inherit (lib) types;
  inherit (lib.options) mkOption;
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) mapAttrs;
  inherit (config.lib.file) mkOutOfStoreSymlink;

  cfg = config.home.symlinks;
in

{
  options.home.symlinks = mkOption {
    type = types.attrsOf types.str;
    default = { };
    example = lib.literalExpression ''
      {
        ".local/share/Steam/steamapps" = "/mnt/storage/Steam/steamapps";
      }
    '';
    description = ''
      An attribute set of the target directory mapped to an out-of-store directory.
    '';
  };

  config = mkIf (cfg != { }) {
    home.file = mapAttrs (_: value: { source = mkOutOfStoreSymlink value; }) cfg;
  };
}
