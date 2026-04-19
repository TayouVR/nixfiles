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
    # Bigscreen Beyond
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0101", MODE="0660", GROUP="video"
    # Bigscreen Bigeye
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0202", MODE="0660", GROUP="video"
    # Bigscreen Beyond Audio Strap
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0105", MODE="0660", GROUP="video"
    # Bigscreen Beyond Firmware Mode?
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="4004", MODE="0660", GROUP="video"
  '';
}
