{
  description = "My nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap-flake.url = "github:xremap/nix-flake";
    import-tree.url = "github:vic/import-tree";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      sops-nix,
      import-tree,
      ...
    }:
    let
      system = "x86_64-linux";
      user = "ivan";
      pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${system};
      pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
      my_lib = import ./lib {
        inherit
          user
          system
          inputs
          ;
      };

      allPersonalHostNames = [
        "nixos-main"
        "nixos-school"
      ];
      allServerHostNames = [
        "server"
      ];
    in
    {
      nixosConfigurations =
        let
          inherit (nixpkgs) lib; # dont use "nixpkgs.lib", just use "lib"
          hostNames = allPersonalHostNames ++ allServerHostNames;
          sharedModules = [
            ./system/main.nix
            sops-nix.nixosModules.sops
          ];
        in
        lib.pipe hostNames [
          (map (
            hostName:
            lib.nameValuePair hostName (
              let
                sharedSpecialArgs = {
                  inherit inputs;
                  inherit my_lib;
                  inherit user;
                  inherit hostName;
                  inherit allServerHostNames;
                  inherit allPersonalHostNames;
                  inherit import-tree;
                };
              in
              lib.nixosSystem {
                specialArgs = lib.mergeAttrsList [
                  sharedSpecialArgs
                  {
                    inherit pkgs-stable;
                    inherit pkgs-unstable;
                    inherit home-manager;
                  }
                ];
                modules = sharedModules ++ [
                  { networking.hostName = hostName; } # set the hostname
                  (./. + "/hosts/${hostName}/configuration.nix") # to get a absolute path

                  home-manager.nixosModules.home-manager
                  {
                    # make home-manager as a module of nixos
                    # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
                    home-manager = {
                      useUserPackages = true; # Packages install to /etc/profiles
                      useGlobalPkgs = true; # Use global package definitions
                      backupFileExtension = "backup"; # backup file instead of overriding it

                      users.${user} = import (./. + "/hosts/${hostName}/home-configuration.nix");
                      sharedModules = [
                        inputs.sops-nix.homeManagerModules.sops
                        ./home/home.nix
                      ];

                      # to pass arguments to home.nix
                      extraSpecialArgs = lib.mergeAttrsList [
                        sharedSpecialArgs
                        {
                          # rest of special args
                        }
                      ];
                    };
                  }
                ];
              }
            )
          ))
          lib.listToAttrs
        ];

      # equivalent to something like this :
      # ${hostName} = nixpkgs.lib.nixosSystem {
      #   ...
      # };
      # ...
    };
}
