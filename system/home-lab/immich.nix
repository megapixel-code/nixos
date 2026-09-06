{
  lib,
  config,
  user,
  pkgs-stable,
  ...
}:
{
  options = {
    my.home-lab = {
      immich = {
        prefix = lib.mkOption {
          default = "pictures";
          type = lib.types.str;
        };
      };

      nextcloud = {
        prefix = lib.mkOption {
          default = "cloud";
          type = lib.types.str;
        };
      };
    };
  };

  config = lib.mkIf config.home-manager.users.${user}.my.module-home-lab.enable {
    services.immich = {
      enable = true;
      package = pkgs-stable.immich;
      port = 2283;
      openFirewall = false;
    };
    services.nginx.virtualHosts = {
      "pictures.${config.my.home-lab.baseDomain}" = {
        useACMEHost = config.my.home-lab.baseDomain;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://${config.services.immich.host}:${lib.toString config.services.immich.port}";
          proxyWebsockets = true;
        };
      };
    };

    sops.secrets."nextcloud/password" = { };
    services.nextcloud = {
      enable = true;
      configureRedis = true; # caching
      https = true;
      hostName = "cloud.${config.my.home-lab.baseDomain}";
      package = pkgs-stable.nextcloud34;
      database.createLocally = true;

      autoUpdateApps.enable = true;
      extraAppsEnable = true;
      extraApps = with config.services.nextcloud.package.packages.apps; {
        inherit
          calendar
          contacts
          notes
          ;
      };

      settings = {
        maintenance_window_start = 1;
        default_phone_region = "FR";
        log_type = "systemd";
        serverid = 0;
      };

      config = {
        dbtype = "pgsql";
        adminuser = "${user}";
        adminpassFile = config.sops.secrets."nextcloud/password".path;
      };
    };
    services.nginx.virtualHosts = {
      "${config.services.nextcloud.hostName}" = {
        useACMEHost = config.my.home-lab.baseDomain;
        forceSSL = true;
      };
    };
  };
}
