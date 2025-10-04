{ pkgs, config, lib, ... }:
{
  config = {
    nixpkgs.overlays = [
      (final: prev: {
        patched = {
          # TODO: use local xrizer until fbt & skeletal input rebased on 0.3.0/latest main
#          xrizer = prev.xrizer.overrideAttrs (oldAttrs: {
#            src = final.fetchFromGitHub {
#              owner = "TayouVR";
#              repo = "xrizer";
#              # rev can be the branch, or a specific commit... possibly (todo: test)
#              rev = "experimental2";
#              # to get the latest hash from nix on build: "0000000000000000000000000000000000000000000000000000";
#              sha256 = "sha256-XAGMorn1sDb+b5nxihQ5Xzvb14eCQGN6q0WFymSNHOM=";
#              # You can also use lib.fakeSha256 instead of the zeroes:
#              # sha256 = lib.fakeSha256;
#            };
#            cargoHash = "";
#            # If using patches
##            patches = [
##              ./patching/patches/xrizer/69.patch
##              ./patching/patches/xrizer/82.patch
##            ];
#            # Keep this if checks still fail or are unwanted, otherwise remove it.
#            doCheck = false;
#            version = "${oldAttrs.version}-experimental2";
#          });
          monado = prev.monado.overrideAttrs (oldAttrs: {
#            src = final.fetchFromGitLab {
#              domain = "gitlab.freedesktop.org";
#              owner = "openglfreak";
#              repo = "monado";
#              rev = "dyndev";
#              sha256 = "sha256-dyHbIblR8r7vOZcZaSaXPO+XCeiD+s413UZ+Ok/4/6w=";
#              # You can also use lib.fakeSha256:
#              # sha256 = lib.fakeSha256;
#            };
            # TODO: cmake flag temporary until https://github.com/nix-community/nixpkgs-xr/issues/468 and https://github.com/NixOS/nixpkgs/issues/439075 fixed
            cmakeFlags = oldAttrs.cmakeFlags ++ [
              (lib.cmakeBool "XRT_HAVE_OPENCV" false)
              "-DBUILD_WITH_OPENCV=OFF"
            ];
            # patches = [
            # ];
            # version = "${oldAttrs.version}-dyndev";
            # Add any other overrides needed for this specific version,
            # for example, disabling checks if they fail:
            # doCheck = false;
          });
          blender = prev.blender.overrideAttrs (oldAttrs: {
            pythonPath = oldAttrs.pythonPath ++ (
            let
              customPythonPackages = import ./robust-weight-transfer-deps.nix {
                pkgs = pkgs; # Pass the current pkgs
                lib = lib;
                pythonPackages = pkgs.python311Packages;
              };

              libiglCustom = customPythonPackages.libigl;
              robustLaplacianCustom = customPythonPackages.robust-laplacian;
            in
            [
              libiglCustom
              robustLaplacianCustom
              pkgs.python311Packages.scipy
            ]);
            hipSupport = config.tayouflake.graphics.driver == "amd";
            cudaSupport = config.tayouflake.graphics.driver == "nvidia";
            #version = "${oldAttrs.version}-patched";
          });
        };
      })
    ];
  };
}
