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
      # FIXME: remove when portals are fixed: https://github.com/flatpak/xdg-desktop-portal/pull/2027
      # dont forget to remove above also ^
      "mango/config.conf" = {
        force = true;
        text = ''
          source=~/.config/mango/main.conf
          source=~/.config/mango/hosts/${hostName}.conf

          exec-once=${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal
        '';
      };
    };
  };
}
