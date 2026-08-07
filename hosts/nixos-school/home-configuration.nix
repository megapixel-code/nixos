{
  lib,
  ...
}:
{
  imports = [
    ../personal-home-defaults.nix
  ];

  my = {
    battery_dependent = lib.mkForce true;
    pkgs = {
      games.enable = lib.mkForce false;
    };
  };
}
