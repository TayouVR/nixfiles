{ ... }:
{
  config = {
    # Add the standard overlays option for more complex overlays
    nixpkgs.overlays = [
      (final: prev: {
        patched = {
          xrizer = prev.xrizer.overrideAttrs (oldAttrs: {
            src = final.fetchFromGitHub {
              owner = "openglfreak";
              repo = "xrizer";
              rev = "feat-tracker-list-update";
              sha256 = "sha256-XQk0nB+5R4LQGRtTvSjXy30cLjmSZqpvvLqV9LrNNJc=";
              # You can also use lib.fakeSha256 instead of the zeroes:
              # sha256 = lib.fakeSha256;
            };
            # If using patches
            # patches = [];
            # Keep this if checks still fail or are unwanted, otherwise remove it.
            doCheck = false;
            version = "${oldAttrs.version}-feat-tracker-list-update";
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