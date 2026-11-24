{
  config,
  lib,
  pkgs-stable,
  ...
}:
let
  service = "fail2ban";
  home-lab = config.my.home-lab;
  cfg = home-lab.${service};
in
{
  options = {
    my.home-lab.${service} = {
      enable = lib.mkEnableOption "enable ${service}";
    };
  };

  config = lib.mkIf cfg.enable {
    services.${service} = {
      enable = true;
      # package = pkgs-stable.fail2ban; FIXME: breaks services with "readonly db" error
      maxretry = 3;
      ignoreIP = [
        config.my.networking.wireguard.subnet
      ];
      bantime = "24h";
      bantime-increment = {
        enable = true;
        formula = "ban.Time * math.exp( float( ban.Count + 1 ) )";
        overalljails = true;
      };

      jails =
        let
          mkJail = log_path: filter_name: {
            ${filter_name}.settings = {
              enabled = true;
              filter = filter_name;
              logpath = log_path;
              backend = "auto";
              maxretry = 3;
              findtime = 3600;
            };
          };
          mkNginxJail = filter_name: mkJail "/var/log/nginx/access.log" filter_name;
          mkNginxJails = filters: lib.mkMerge (lib.map mkNginxJail filters);
        in
        lib.mkMerge [
          (lib.mkIf (config.services.nginx.enable == true) (mkNginxJails [
            "nginx-bad-request"
            "nginx-botsearch"
            "nginx-error-common"
            "nginx-forbidden"
            "nginx-http-auth"
            "nginx-limit-req"
          ]))
          {
            # max 5 failures in 600 sec
            # "nginx-bad-request".settings = {
            #   enabled = true;
            #   filter = "nginx-bad-request";
            #   logpath = "/var/log/nginx/access.log";
            #   backend = "auto";
            #   maxretry = 5;
            #   findtime = 600;
            # };
          }
        ];
    };
  };
}
