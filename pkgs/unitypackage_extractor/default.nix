{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

let
  tarsafe = python3Packages.buildPythonPackage rec {
    pname = "tarsafe";
    version = "0.0.6";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "beatsbears";
      repo = "tarsafe";
      rev = "3cadb99030306cf767279f910b91a56d720b4e78";
      hash = "sha256-Lmg6eMkESEOGYCQWHgveiBH3K83rjA8xRsfxVfvteRY=";
    };

    postPatch = ''
      rm pyproject.toml
    '';

    build-system = [
      python3Packages.setuptools
    ];

    doCheck = false;

    meta = {
      description = "A safe subclass of the TarFile class for interacting with tar files";
      homepage = "https://github.com/beatsbears/tarsafe";
      license = lib.licenses.mit;
    };
  };
in
python3Packages.buildPythonApplication rec {
  pname = "unitypackage_extractor";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Cobertos";
    repo = "unitypackage_extractor";
    rev = "abb09727d206cc6788a63a05d5c434eab19f07a5";
    hash = "sha256-uvSyIy8SOk0B/9RTDU35yafrQCYMOCUXtq0KPziun2M=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  propagatedBuildInputs = [
    tarsafe
  ];

  postInstall = ''
    mkdir -p $out/bin
    cat > $out/bin/unitypackage_extractor << 'EOF'
#!/usr/bin/env python3
import sys
from unitypackage_extractor.extractor import cli

if __name__ == "__main__":
    cli(sys.argv[1:])
EOF
    chmod +x $out/bin/unitypackage_extractor

    cat > $out/bin/unitypackage-extract-here << EOF
#!/bin/sh
for file in "\$@"; do
  dir="\$(dirname "\$file")"
  "$out/bin/unitypackage_extractor" "\$file" "\$dir"
done
EOF
    chmod +x $out/bin/unitypackage-extract-here

    cat > $out/bin/unitypackage-extract-folder << EOF
#!/bin/sh
for file in "\$@"; do
  dir="\$(dirname "\$file")"
  base="\$(basename "\$file" .unitypackage)"
  "$out/bin/unitypackage_extractor" "\$file" "\$dir/\$base"
done
EOF
    chmod +x $out/bin/unitypackage-extract-folder

    mkdir -p $out/share/mime/packages
    cat > $out/share/mime/packages/unitypackage.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="application/x-unitypackage">
    <comment>Unity Package</comment>
    <glob pattern="*.unitypackage"/>
    <sub-class-of type="application/gzip"/>
  </mime-type>
</mime-info>
EOF

    mkdir -p $out/share/kio/servicemenus
    cat > $out/share/kio/servicemenus/unitypackage_extractor.desktop << EOF
[Desktop Entry]
Type=Service
MimeType=application/x-unitypackage;
Actions=unpackHere;unpackSubfolder;
X-KDE-Priority=TopLevel

[Desktop Action unpackHere]
Name=Unpack Unity Package Here
Icon=package-x-generic
Exec=$out/bin/unitypackage-extract-here %F

[Desktop Action unpackSubfolder]
Name=Unpack Unity Package to Folder
Icon=package-x-generic
Exec=$out/bin/unitypackage-extract-folder %F
EOF
  '';

  doCheck = false;

  meta = {
    description = "Extractor for .unitypackage files";
    homepage = "https://github.com/Cobertos/unitypackage_extractor";
    license = lib.licenses.mit;
    mainProgram = "unitypackage_extractor";
  };
}
