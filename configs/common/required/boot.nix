{ pkgs, ... }:

{
  # if not using windows using UTC (registry tweak)
  #time.hardwareClockInLocalTime = true;

  # Bootloader.
  boot = {
    loader = {
      #systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;

      grub = {
        enable = true;
        device = "nodev";
        useOSProber = true;
        efiSupport = true;
        memtest86.enable = true;
        default = "saved";
        theme = (pkgs.sleek-grub-theme.override {
          withBanner = "Tayous GRUB2";
          withStyle = "bigSur";
        });

        extraEntries = ''
          menuentry "Reboot to BIOS Setup" {
            fwsetup
          }
        '';
      };
    };

#    kernelParams = [
#      "amd_pstate=active" # different AMD CPU frequency driver, should give better perf on modern AMD
#      "threadirqs" # Turns most hardware interrupt handlers into kernel threads. Can reduce latency spikes
#      "preempt=full" # Requests full kernel preemption, reducing worst-case latency by letting the kernel interrupt work more aggressively.
#      "amdgpu.ppfeaturemask=0xffffffff" # This unlocks a bunch of AMDGPU power-management features that are otherwise masked off.
#    ];

    # Use latest linux kernel
    kernelPackages = pkgs.linuxPackages_latest;
    #kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };
}
