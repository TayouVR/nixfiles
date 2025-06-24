{ pkgs, lib, ... }:
let
  gtk3-nocsd = pkgs.stdenv.mkDerivation {
    pname = "gtk3-nocsd";
    version = "3.0.8";

    src = pkgs.fetchFromGitHub {
      owner = "ZaWertun";
      repo = "gtk3-nocsd";
      rev = "v3.0.8";
      sha256 = "sha256-BOsQqxaVdC5O6EnB3KZinKSj0U5mCcX8HSjRmSBUFks=";
    };

    nativeBuildInputs = with pkgs; [
      pkg-config
    ];

    buildInputs = with pkgs; [
      gtk3
      gobject-introspection
    ];

    installPhase = ''
      mkdir -p $out/lib
      mkdir -p $out/bin
      cp libgtk3-nocsd.so.0 $out/lib/
      cp gtk3-nocsd $out/bin/
    '';
  };
in
{
  environment.sessionVariables = {
    GTK_CSD = "0";
    LD_PRELOAD = "${gtk3-nocsd}/lib/libgtk3-nocsd.so.0";
  };

  # Make the binary available in PATH
  environment.systemPackages = [ gtk3-nocsd ];
}