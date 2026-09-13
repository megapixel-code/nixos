{
  config,
  lib,
  ...
}:
let
  home-lab = config.my.home-lab;
  cfg = home-lab.fail2ban;
in
{
  options = {
    my.home-lab.fail2ban = {
      enable = lib.mkEnableOption "enable fail2ban";
    };
  };

  config = lib.mkIf cfg.enable {
    services.fail2ban = {
      # TODO: better config
      enable = true;
      maxretry = 3;
      bantime = "24h";
      bantime-increment = {
        enable = true;
        formula = "ban.Time * math.exp( ban.Count + 1 )";
        overalljails = true;
      };
    };
  };
}
