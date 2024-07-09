{
  description = "Tayous NixOS system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    #nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = {
    nixpkgs,
    nixpkgs-xr,
    ...
  } @ inputs:
  let
    username = "tayou";
    system = "x86_64-linux";

    specialArgs = {
      inherit username;
      inherit inputs;
      inherit system;
    };
    pkgs = import nixpkgs {
      inherit system;

      config = {
        allowUnfree = true;
      };
    };

  in {
    nixosConfigurations = {
      # Main System
      nixosTayou = nixpkgs.lib.nixosSystem {
        inherit specialArgs;

        modules = [
          nixpkgs-xr.nixosModules.nixpkgs-xr
          ./system/configuration.nix
          ./starship/starship.nix
        ];
      };

      # Secondary System
      nixosTayouSecondary = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };

        modules = [
          nixpkgs-xr.nixosModules.nixpkgs-xr
          ./system/configuration.nix
          ./starship/starship.nix
        ];
      };
    };

  };
}
