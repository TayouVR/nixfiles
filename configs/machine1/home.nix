{
  config,
  pkgs,
  inputs,
  username,
  xr-pkgs,
  packages,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  environment.systemPackages = [
    pkgs.home-manager
  ];

  xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.monado}/share/openxr/1/openxr_monado.json";
}