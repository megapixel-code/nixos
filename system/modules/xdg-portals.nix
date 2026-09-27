{
  pkgs,
  ...
}:
{
  # portal config :
  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;

      wlr = {
        enable = true;
      };

      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        xdg-desktop-portal-termfilechooser
      ];

      config = {
        # pattern :
        # {name} -> "{name}-" -> {name}-portals.conf file
        # common -> empty -> portals.conf file
        # located at /etc/xdg/xdg-desktop-portal/{name}-portals.conf
        mango = {
          default = [
            "gtk"
          ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          "org.freedesktop.impl.portal.Inhibit" = [ "none" ];

          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ]; # NOTE: config is located in xdg-desktop.nix
        };
      };
    };
  };
}
