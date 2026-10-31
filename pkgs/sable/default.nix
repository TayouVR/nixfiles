{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "sable-next";
  name = "sable";
  version = "2.2.3";

  src = fetchurl {
    url = "https://git.sable.moe/SableClient/sable-next/releases/download/v${version}/sable-${version}-x86_64.AppImage";
    hash = "sha256-dxs09Eb/HUIjwAlzCNM7qsxMrdjuHDMOYsiHT5+tDSg=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # Tauri apps need the webkitgtk webview runtime in the FHS environment
  extraPkgs = pkgs: [ pkgs.webkitgtk_4_1 ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${name}.png -t $out/share/pixmaps
    # upstream desktop file runs `AppRun`, which only exists inside the AppDir;
    # point it at the wrapper binary instead
    install -m 444 -D ${appimageContents}/${name}-electron.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${name}-electron.desktop \
      --replace-fail "Exec=AppRun" "Exec=$out/bin/${pname}"
  '';

  meta = {
    description = "A better matrix client";
    homepage = "https://docs.sable.moe/";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = name;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}