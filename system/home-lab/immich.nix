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
    my.home-lab.immich = {
      port = config.services.immich.port;
      host = config.services.immich.host;
    };

    services.immich = {
      enable = true;
      # package = pkgs-stable.immich; TODO: uncomment on next stable release ( december 2026 )
      openFirewall = false;
    };
  };
}
