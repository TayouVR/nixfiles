{ pkgs, config, lib, ... }:
{
  config = {
    nixpkgs.overlays = [
      (final: prev: {
        patched = {
          monado = prev.monado.overrideAttrs (oldAttrs: {
#            src = final.fetchFromGitLab {
#              domain = "gitlab.freedesktop.org";
#              owner = "openglfreak";
#              repo = "monado";
#              rev = "dyndev";
#              sha256 = "sha256-PLFp4l6L3Pm0DhccOlJfO/1pwyfnhjGk1NCd0NM56Go=";
#              # You can also use lib.fakeSha256:
#              # sha256 = lib.fakeSha256;
#            };
#            patches = [
#              ./patching/patches/monado/9091-deadzones.patch # patch is outdated, needs changes for current monado - 2026-09-15
#            ];
#            version = "${oldAttrs.version}-dyndev";
#            # Add any other overrides needed for this specific version,
#            # for example, disabling checks if they fail:
#            doCheck = false;
          });
          blender = prev.blender.overrideAttrs (oldAttrs: {
            pythonPath = oldAttrs.pythonPath ++ (
            let
              pythonPackages = pkgs.python313Packages;
              customPythonPackages = import ./robust-weight-transfer-deps.nix {
                pkgs = pkgs; # Pass the current pkgs
                lib = lib;
                pythonPackages = pythonPackages;
              };

              libiglCustom = customPythonPackages.libigl;
              robustLaplacianCustom = customPythonPackages.robust-laplacian;
            in
            [
              libiglCustom
              robustLaplacianCustom
              pythonPackages.scipy
            ]);
            cudaSupport = config.tayouflake.graphics.driver == "nvidia";
#            patches = [
#              ./patching/patches/blender/undo-limit-begone.patch
#            ];
            #version = "${oldAttrs.version}-patched";
          });
          wayvr = prev.wayvr.overrideAttrs (oldAttrs: {
            postInstall = (oldAttrs.postInstall or "") + ''
              wrapProgram $out/bin/wayvr \
                --prefix PATH : "${lib.makeBinPath [ pkgs.bash ]}"
            '';
            nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ pkgs.makeWrapper ];
          });
        };
      })
    ];
  };
}
