{
  lib,
  user,
  config,
  pkgs-stable,
  ...
}:
let
  service = "nextcloud";
  home-lab = config.my.home-lab;
  cfg = home-lab.${service};
in
{
  options = {
    my.home-lab.${service} = {
      enable = lib.mkEnableOption "enable ${service}";
      auto-proxy = lib.mkEnableOption "automaticaly proxy";
      prefix = lib.mkOption {
        type = lib.types.str;
      };
      host = lib.mkOption {
        type = lib.types.str;
      };
      port = lib.mkOption {
        type = lib.types.int;
      };
      category = lib.mkOption {
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.${service} = {
      enable = true;
      configureRedis = true; # caching
      https = true;
      hostName = "${cfg.prefix}.${home-lab.baseDomain}";
      package = pkgs-stable.nextcloud35;
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
      };
    };

    services.nginx.virtualHosts = {
      "${config.services.${service}.hostName}" = {
        useACMEHost = home-lab.baseDomain;
        forceSSL = true;
      };
    };
  };
}
