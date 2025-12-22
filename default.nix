{
  lib,
  config,
  inputs,
  pkgs-unstable,
  home-manager,
  ...
}:

{
  imports = [
    home-manager.nixosModules.home-manager
    ./system/configuration.nix
  ];

  # make home-manager as a module of nixos
  # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
  home-manager = {
    useUserPackages = true; # Packages install to /etc/profiles
    useGlobalPkgs = true; # Use global package definitions
    backupFileExtension = "backup"; # backup file instead of overriding it

    users.ivan = import ./home/home.nix; # path of the home

    extraSpecialArgs = { inherit inputs; }; # to pass arguments to home.nix
  };
}
