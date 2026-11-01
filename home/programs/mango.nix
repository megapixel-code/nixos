{
  pkgs,
  lib,
  config,
  hostName,
  ...
}:
{
  config = lib.mkIf config.my.module-mango.enable {
    xdg.configFile = {
      "mango/config.conf" = {
        force = true;
        text = ''
          source=~/.config/mango/main.conf
          source=~/.config/mango/hosts/${hostName}.conf
        '';
      };
    };
  };
}
