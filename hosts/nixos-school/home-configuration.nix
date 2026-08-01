{
  lib,
  ...
}:
{
  imports = [
    ../personal-home-defaults.nix
  ];

  my.pkgs = {
    games.enable = lib.mkForce false;
  };
}
