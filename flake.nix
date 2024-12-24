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
  };

  outputs =
    inputs@{
      flake-parts,
      ...
    }:

    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./lib
        #./pkgs
        #./modules

        ./configs/machine1
        ./configs/machine2
      ];

      systems = [
        "x86_64-linux"
      ];
    };
}
