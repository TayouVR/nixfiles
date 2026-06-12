{
  description = "Tayous NixOS system flake";

  inputs = {
    #nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-xr = {
      url = "github:nix-community/nixpkgs-xr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-conf-editor = {
      url = "github:snowfallorg/nixos-conf-editor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    watchman-pairing-assistant = {
      url = "github:TayouVR/watchman-pairing-assistant";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # for millenium. Upstream keeps breaking for some reason
    millennium-src = {
      url = "github:SteamClientHomebrew/Millennium/f8ec21d14e0f2536f099cd06dd099e39fd04cda7";
      flake = false;
    };
    luajit-src = {
      url = "github:SteamClientHomebrew/LuaJIT/v2.1";
      flake = false;
    };
  };


  outputs =
    inputs@{
      flake-parts,
      ...
    }:

    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./lib
        ./pkgs
        #./modules
        ./homeModules

        ./configs/machine1
        ./configs/machine2
      ];

      systems = [
        "x86_64-linux"
      ];
    };
}
