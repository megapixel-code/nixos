{
  lib,
  config,
  pkgs-stable,
  ...
}:
let
  home-lab = config.my.home-lab;
  cfg = home-lab.searxng;
in
{
  options = {
    my.home-lab.searxng = {
      enable = lib.mkEnableOption "enable searxng";
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
    my.home-lab.searxng = {
      host = "localhost";
      port = 8888;
    };

    sops.secrets."searxng/key" = { };
    services.searx = {
      enable = true;
      redisCreateLocally = true;

      configureUwsgi = true;
      uwsgiConfig = {
        http = ":${lib.toString config.my.home-lab.searxng.port}";
        socket = "/run/searx/searx.sock";
        chmod-socket = "660";
      };

      settings = {
        general = {
          debug = false;
          donation_url = false;
          contact_url = false;
          privacypolicy_url = false;
          enable_metrics = false;
        };

        ui = {
          theme_args.simple_style = "auto";
          default_locale = "en";
        };

        search = {
          safe_search = 0;
          autocomplete = "duckduckgo";
        };

        server = {
          bind_address = config.my.home-lab.searxng.host;
          port = config.my.home-lab.searxng.port;
          secret_key = config.sops.secrets."searxng/key".path;
        };

        engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {
          # "duckduckgo".disabled = true;
          # "duckduckgo".weight = 0.5;
          # "duckduckgo".weight = 2;
        };

        enabled_plugins = [
          "Basic Calculator"
        ];
      };
    };
  };
}
