{
  description = "My nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
      mkSpecialArgs = {
        inherit inputs;
        inherit pkgs-unstable;
        inherit home-manager;
      };
    in
    {
      nixosConfigurations = {
        nixos-main = nixpkgs.lib.nixosSystem {
          specialArgs = mkSpecialArgs;
          modules = [
            ./hosts/nixos-main/hardware-configuration.nix
            ./default.nix
          ];
        };

        nixos-school = nixpkgs.lib.nixosSystem {
          specialArgs = mkSpecialArgs;
          modules = [
            ./hosts/nixos-school/hardware-configuration.nix
            ./default.nix
          ];
        };
      };
    };
}
