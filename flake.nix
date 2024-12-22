{
  description = "Tayous NixOS system flake";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    #nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = {
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-xr,
    ...
  } @ inputs:
  let
    username = "tayou";
    system = "x86_64-linux";
    pkgsStable = import nixpkgs-stable {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    xr-pkgs = import nixpkgs-xr {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };

    specialArgs = {
      inherit username;
      inherit inputs;
      inherit system;
      inherit pkgs;
      inherit pkgsStable;
      inherit xr-pkgs;
    };

  in {
    nixosConfigurations = {
      # Main System
      nixosTayou = nixpkgs.lib.nixosSystem {
        inherit specialArgs;

        modules = [
          nixpkgs-xr.nixosModules.nixpkgs-xr
          ./system/configuration.nix
          ./system/hardware-configuration.nix
          ./starship/starship.nix
        ];
      };

      # Secondary System
      nixosTayouSecondary = nixpkgs.lib.nixosSystem {
        inherit specialArgs;

        modules = [
          nixpkgs-xr.nixosModules.nixpkgs-xr
          ./system/configuration.nix
          ./system/machine2/hardware-configuration.nix
          ./starship/starship.nix
        ];
      };
    };

  };
}
