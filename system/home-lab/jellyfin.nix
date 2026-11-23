{
  lib,
  config,
  pkgs-stable,
  ...
}:
let
  service = "jellyfin";
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
      host = "127.0.0.1";
      port = 8096;
    };

    services.${service} = {
      enable = true;
      openFirewall = false;
      package = pkgs-stable.jellyfin;
    };
  };
}
