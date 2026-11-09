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
  config = lib.mkIf config.my.module_mango.enable {
    home.pointerCursor = {
      enable = true;
      dotIcons.enable = false; # removes .icons folder in home dir (might break some apps?)
      package = cursorPackage;
      name = cursorName;
      size = cursorSize;
      x11.enable = true;
      gtk.enable = true;
    };
  };
}
