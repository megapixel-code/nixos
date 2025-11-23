{ pkgs, ... }:
let
  cursorPackage = pkgs.hackneyed;
  cursorName = "Hackneyed";
  cursorSize = 24;
in
{
  home.pointerCursor = {
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
}
