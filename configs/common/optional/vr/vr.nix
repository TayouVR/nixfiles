{
  pkgs,
  inputs,
  username,
  ...
}:

{
  imports = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
  ];

  nixpkgs.xr.enable = true;

  hm.home.file.".alsoftrc".text = ''
    hrtf = true
  '';

  programs.steam.extraCompatPackages = [
    pkgs.proton-ge-rtsp-bin
    pkgs.proton-ge-bin
  ];

  environment.systemPackages = with pkgs; [
    # index_camera_passthrough
    lighthouse-steamvr
    watchmanPairingAssistant

    openal
  ];

  users.users.${username}.extraGroups = [ "video" ];

  # Beyond udev rule
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0101", MODE="0666", GROUP="video"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0202", MODE="0666", GROUP="video"
  '';
}
