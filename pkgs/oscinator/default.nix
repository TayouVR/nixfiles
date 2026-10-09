{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  fontconfig,
  freetype,
  expat,
  libglvnd,
  libX11,
  libICE,
  libSM,
  libXi,
  libXrandr,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "oscinator";
  version = "1.0.2";

  src = fetchurl {
    url = "https://github.com/knah/Oscinator/releases/download/${finalAttrs.version}/Oscinator-linux-x64.tar.gz";
    hash = "sha256-kmy7SbFPcx3NIzoUon+AANoPb7t6nrBL9Zky4Z0F9hc=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    fontconfig
    freetype
    expat
    libglvnd
    libX11
    libICE
    libSM
    libXi
    libXrandr
  ];

  # don't strip the Oscinator binary: it's a .NET single-file bundle and
  # stripping/modifying it corrupts the embedded bundle. Dependencies are
  # provided via LD_LIBRARY_PATH in the wrapper instead of patchelfing.
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/oscinator
    cp Oscinator libHarfBuzzSharp.so libSkiaSharp.so $out/lib/oscinator/

    mkdir -p $out/bin
    makeWrapper $out/lib/oscinator/Oscinator $out/bin/oscinator \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "oscinator";
      exec = "oscinator";
      terminal = false;
      desktopName = "Oscinator";
      comment = "View and modify VRChat avatar parameters via OSC/OSCQuery";
      categories = [
        "Utility"
        "Application"
      ];
    })
  ];

  meta = {
    description = "Simple tool to view and modify avatar parameters exposed by VRChat via OSC/OSCQuery";
    homepage = "https://github.com/knah/Oscinator";
    downloadPage = "https://github.com/knah/Oscinator/releases";
    license = lib.licenses.mit;
    mainProgram = "oscinator";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
