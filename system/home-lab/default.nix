{
  lib,
  config,
  user,
  ...
}:
{
  options = {
    my.home-lab = {
      baseDomain = "home-lab";
    };
  };

  config = lib.mkIf config.home-manager.users.${user}.my.module-home-lab.enable {
    services.immich = {
      enable = true;
      port = 2283;
      host = "0.0.0.0";
      openFirewall = true;
    };
  };
}
