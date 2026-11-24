{
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  my.home-lab.fail2ban.enable = true; # TODO: feels odd to put here
}
