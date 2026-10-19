{
  lib,
  config,
  pkgs-stable,
  ...
}:
let
  home-lab = config.my.home-lab;
  cfg = home-lab.vaultwarden;
in
{
  options = {
    my.home-lab.vaultwarden = {
      enable = lib.mkEnableOption "enable vaultwarden";
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
    my.home-lab.vaultwarden = {
      host = config.services.vaultwarden.config.ROCKET_ADDRESS;
      port = config.services.vaultwarden.config.ROCKET_PORT;
    };

    services.vaultwarden = {
      enable = true;
      package = pkgs-stable.vaultwarden;
      config = {
        ROCKET_PORT = 8222;
        ROCKET_ADDRESS = "127.0.0.1";
      };
    };

    services.nginx = {
      upstreams.vaultwarden.servers."${cfg.host}:${lib.toString cfg.port}" = { };
    };
  };
}
