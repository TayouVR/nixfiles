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
        #memtest86.enable = true;
        default = "saved";
        theme = (pkgs.sleek-grub-theme.override {
          withBanner = "Tayous GRUB2";
          withStyle = "bigSur";
        });
      };
    };

    # Use latest linux kernel
    kernelPackages = pkgs.linuxPackages_latest;
    #kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };
}
