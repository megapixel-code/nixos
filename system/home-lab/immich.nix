{
  lib,
  config,
  pkgs-stable,
  ...
}:
let
  service = "immich";
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
    my.home-lab.${service} = {
      port = config.services.immich.port;
      host = config.services.immich.host;
    };

    services.${service} = {
      enable = true;
      # package = pkgs-stable.immich; TODO: uncomment on next stable release ( december 2026 )
      host = "127.0.0.1";
      openFirewall = false;
    };
  };
}
