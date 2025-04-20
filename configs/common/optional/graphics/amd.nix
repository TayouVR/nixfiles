{ pkgs, config, lib, ... }:
{
  config = lib.mkIf (config.tayouflake.graphics.driver == "amd") {
    boot.initrd.kernelModules = [ "amdgpu" ];
    boot.kernelPatches = [
      {
        name = "bigscreen beyond";
        patch = ./beyondKernel.patch;
      }
      { # see https://wiki.nixos.org/wiki/VR#Applying_as_a_NixOS_kernel_patch
        name = "amdgpu-ignore-ctx-privileges";
        patch = pkgs.fetchpatch {
          name = "cap_sys_nice_begone.patch";
          url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
          hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
        };
      }
    ];

    # GPU driver
    services.xserver.videoDrivers = [ "amdgpu" ];
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
  };
}
