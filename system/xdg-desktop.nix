{
  pkgs,
  ...
}:

{
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      xdg-desktop-portal-termfilechooser
    ];

    config = {
      # executable file found by following the instructions in here:
      # /nix/store/...{store version}.../sw/lib/systemd/user
      # config files here:
      # /nix/store/...{store version}.../etc/xdg/xdg-desktop-portal

      # pattern :
      # {name} -> "{name}-" -> {name}-portals.conf file

      # common -> empty -> portals.conf file
      common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        "org.freedesktop.impl.portal.Inhibit" = [ "none" ];

        "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
      };

      # wlroots -> "wlroots-" -> wlroots-portals.conf file
      wlroots = {
      };
    };
  };
}
