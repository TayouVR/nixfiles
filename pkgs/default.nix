{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];

  perSystem =
    { pkgs, inputs', ... }:
    {
      overlayAttrs = {
        local = {
          klassy = pkgs.callPackage ./klassy {};
          startvrc = pkgs.callPackage ./startvrc {};
          writeSystemdToggle = pkgs.callPackage ./writeSystemdToggle {};
          xrizer = pkgs.callPackage ./xrizer {};
          vrcx = pkgs.callPackage ./vrcx/package.nix {};
          # qidi-studio = pkgs.callPackage ./qidi-studio/package.nix {};

          # qidi studio isn't packaged on nixpkgs, but its a fork of orca-slicer
          qidi-studio = pkgs.bambu-studio.overrideAttrs (oldAttrs: rec {
            pname = "qidi-studio";
            version = "2.04.00.70"; # Use the specific version you need
            src = pkgs.fetchFromGitHub {
              owner = "QIDITECH";
              repo = "QIDIStudio";
              rev = "v${version}";
              hash = "sha256-FttNMa+HzJLewou4bdGpKTC7BThJszqW90W6RMDfHZQ=";
            };

            patches = builtins.filter (patch:
              let
                # Convert path to string (e.g., "/nix/store/...-patch-name.patch")
                # or get the name if it's a fetchpatch result
                name = if builtins.isAttrs patch then patch.name else baseNameOf (toString patch);
              in
                # Exclude both the opencv patch and potentially the update nag patch
                ! (builtins.elem name [
                  "dont-link-opencv-world-bambu.patch"
                  "no-cereal.patch"
                ])
            ) (oldAttrs.patches or []);

            prePatch = ''
              sed -i 's|nlopt_cxx|nlopt|g' cmake/modules/FindNLopt.cmake
              sed -i 's|"libnoise/noise.h"|"noise/noise.h"|' src/libslic3r/PerimeterGenerator.cpp
            '';
          });
        };
        watchmanPairingAssistant = inputs'.watchman-pairing-assistant.packages.default;
      };
    };
}
