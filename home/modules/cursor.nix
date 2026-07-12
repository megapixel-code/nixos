{
  pkgs,
  lib,
  config,
  ...
}:

let
  cursorPackage = pkgs.openzone-cursors;
  cursorName = "OpenZone_Black";
  cursorSize = 18;
in
{
  config = lib.mkIf config.my.module-cursor.enable {
    home.pointerCursor = {
      enable = true;
      package = cursorPackage;
      name = cursorName;
      size = cursorSize;
      x11.enable = true;
      gtk.enable = true;
    };

    gtk.cursorTheme = {
      package = cursorPackage;
      name = cursorName;
      size = cursorSize;
    };
  };
}
