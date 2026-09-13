{
  lib,
  user,
  config,
  pkgs-stable,
  ...
}:
let
  home-lab = config.my.home-lab;
  cfg = home-lab.nextcloud;
in
{
  options = {
    my.home-lab.nextcloud = {
      enable = lib.mkEnableOption "enable nextcloud";
      prefix = lib.mkOption {
        default = "cloud";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."nextcloud/password" = { };
    services.nextcloud = {
      enable = true;
      configureRedis = true; # caching
      https = true;
      hostName = "${cfg.prefix}.${home-lab.baseDomain}";
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
        useACMEHost = home-lab.baseDomain;
        forceSSL = true;
      };
    };
  };
}
