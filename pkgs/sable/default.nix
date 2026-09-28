{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "sable-next";
  version = "0.0.2";

  src = fetchurl {
    url = "https://git.sable.moe/SableClient/sable-next/releases/download/nightly-${version}-nightly.260928062504.10c8b1b1666e/sable-next-${version}-nightly.260928062504.10c8b1b1666e-linux-x86_64.AppImage";
    hash = "sha256-252BOEbBkkzcjKN8b7NkXCk5Ju5bPhT80h6hMpqr/nE=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # Tauri apps need the webkitgtk webview runtime in the FHS environment
  extraPkgs = pkgs: [ pkgs.webkitgtk_4_1 ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    install -m 444 -D ${appimageContents}/${pname}.png -t $out/share/pixmaps
  '';

  meta = {
    description = "A better matrix client";
    homepage = "https://docs.sable.moe/";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}