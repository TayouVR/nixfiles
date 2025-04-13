{...}:
{
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelPatches = [
    {
      name = "bigscreen beyond";
      patch = ../beyondKernel.patch;
    }
  ];

  # GPU driver
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
}