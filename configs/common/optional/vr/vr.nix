{
  pkgs,
  inputs,
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

  programs.steam.extraCompatPackages = [ pkgs.proton-ge-rtsp-bin ];

  environment.systemPackages = with pkgs; [
    # index_camera_passthrough
    lighthouse-steamvr

    openal
  ];
}
