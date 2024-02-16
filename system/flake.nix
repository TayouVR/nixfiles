{
  description = "Tayous NixOS system flake";

  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
        inherit system;

        config = {
            allowUnfree = true;
        };
    };

  in {
    nixosConfigurations = {
      nixosTayou = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };

        modules = [
          ./configuration.nix
        ];
      };
    };

  };
}
