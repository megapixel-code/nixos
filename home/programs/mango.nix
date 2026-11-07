{
  lib,
  config,
  hostName,
  ...
}:
{
  config = lib.mkIf config.my.module_mango.enable {
    xdg.configFile = {
      "mango/config.conf" = {
        force = true;
        text = ''
          source=~/.config/mango/main.toml
          source=~/.config/mango/hosts/${hostName}.toml
        '';
      };
    };
  };
}
