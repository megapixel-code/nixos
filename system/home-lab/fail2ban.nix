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
      # TODO: better config
      enable = true;
      package = pkgs-stable.fail2ban;
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
    };
  };
}
