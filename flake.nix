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
    in
    {
      nixosConfigurations = {
        nixos-main = nixpkgs.lib.nixosSystem {
          modules = [ ./hosts/nixos-main/hardware-configuration.nix ];
        };
        nixos-school = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
            inherit home-manager;
          };

          modules = [
            ./hosts/nixos-school/hardware-configuration.nix # TODO:
            ./system/configuration.nix

            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true; # Packages install to /etc/profiles
                useGlobalPkgs = true; # Use global package definitions
                backupFileExtension = "backup"; # backup file instead of overriding it

                users.ivan = import ./home/home.nix; # path of the home

                extraSpecialArgs = { inherit inputs; }; # to pass arguments to home.nix
              };
            }
          ];
        };

        # "*" = nixpkgs.lib.nixosSystem {
        #   specialArgs = {
        #     inherit inputs;
        #     inherit pkgs-unstable;
        #   };

        #   modules = [
        #     ./system/configuration.nix

        #     # make home-manager as a module of nixos
        #     # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
        #     home-manager.nixosModules.home-manager
        #     {
        #       home-manager = {
        #         useUserPackages = true; # Packages install to /etc/profiles
        #         useGlobalPkgs = true; # Use global package definitions
        #         backupFileExtension = "backup"; # backup file instead of overriding it

        #         users.ivan = import ./home/home.nix; # path of the home

        #         extraSpecialArgs = { inherit inputs; }; # to pass arguments to home.nix
        #       };
        #     }
        #   ];
        # };
      };
    };
}
