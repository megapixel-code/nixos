{
  lib,
  config,
  user,
  pkgs-stable,
  ...
}:
{
  config = lib.mkIf config.home-manager.users.${user}.my.module-home-lab.enable {
    services.immich = {
      enable = true;
      package = pkgs-stable.immich;
      port = 2283;
      openFirewall = false;
    };

    services.nginx.virtualHosts."pictures.${config.my.home-lab.baseDomain}" = {
      useACMEHost = config.my.home-lab.baseDomain;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://${config.services.immich.host}:${lib.toString config.services.immich.port}";
        proxyWebsockets = true;
      };
    };
  };
}
