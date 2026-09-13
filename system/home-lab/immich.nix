{
  lib,
  config,
  pkgs-stable,
  ...
}:
let
  home-lab = config.my.home-lab;
  cfg = home-lab.immich;
in
{
  options = {
    my.home-lab.immich = {
      enable = lib.mkEnableOption "enable immich";
      auto-proxy = lib.mkEnableOption "automaticaly proxy";
      prefix = lib.mkOption {
        type = lib.types.str;
      };
      category = lib.mkOption {
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.immich = {
      enable = true;
      # package = pkgs-stable.immich; TODO: uncomment on next stable release ( december 2026 )
      port = 2283;
      openFirewall = false;
    };

    services.nginx.virtualHosts = {
      "${cfg.prefix}.${home-lab.baseDomain}" = {
        useACMEHost = home-lab.baseDomain;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://${config.services.immich.host}:${lib.toString config.services.immich.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
