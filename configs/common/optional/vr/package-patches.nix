{ ... }:
{
  config = {
    # Add the standard overlays option for more complex overlays
    nixpkgs.overlays = [
      (final: prev: {
        patched = {
          xrizer = prev.xrizer.overrideAttrs (oldAttrs: {
            src = final.fetchFromGitHub {
              owner = "RinLovesYou";
              repo = "xrizer";
              # rev can be the branch, or a specific commit... possibly (todo: test)
              rev = "experimental2";
              # to get the latest hash from nix on build: "0000000000000000000000000000000000000000000000000000";
              sha256 = "sha256-12M7rkTMbIwNY56Jc36nC08owVSPOr1eBu0xpJxikdw=";
              # You can also use lib.fakeSha256 instead of the zeroes:
              # sha256 = lib.fakeSha256;
            };
            # If using patches
#            patches = [
#              ./patching/patches/xrizer/69.patch
#              ./patching/patches/xrizer/82.patch
#            ];
            # Keep this if checks still fail or are unwanted, otherwise remove it.
            doCheck = false;
            version = "${oldAttrs.version}-experimental2";
          });
          monado = prev.monado.overrideAttrs (oldAttrs: {
            src = final.fetchFromGitLab {
              domain = "gitlab.freedesktop.org";
              owner = "openglfreak";
              repo = "monado";
              rev = "dyndev";
              sha256 = "sha256-esI5Ne6tZe8mZ2rTC7npA2QtPsvfD/DLFjM6BMNg400=";
              # You can also use lib.fakeSha256:
              # sha256 = lib.fakeSha256;
            };
            patches = [
              ./patching/patches/monado/0000-dsteamvr_lh-Fix-haptic-pulse-being-set-to-1-Hz-w.patch
            ];
            version = "${oldAttrs.version}-dyndev";
            # Add any other overrides needed for this specific version,
            # for example, disabling checks if they fail:
            # doCheck = false;
          });
        };
      })
    ];
  };
}