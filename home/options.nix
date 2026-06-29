{
  lib,
  ...
}:
{
  options = {
    # TODO: ?
    # user = lib.mkOption {
    #   type = lib.types.string;
    #   default = "ivan";
    # };

    my = {
      module-mango.enable = lib.mkEnableOption "enable mangowc";

      module-cursor.enable = lib.mkEnableOption "enable custom cursor";
      module-bluetooth.enable = lib.mkEnableOption "enable bluetooth";
      module-audio.enable = lib.mkEnableOption "enable audio";
      module-printing.enable = lib.mkEnableOption "enable printing";

      networking = {
        personal.enable = lib.mkEnableOption "enable networking for personal computers";
        servers.enable = lib.mkEnableOption "enable networking for servers";
      };
      pkgs = {
        apps.enable = lib.mkEnableOption "enable apps";
        editors.enable = lib.mkEnableOption "enable video/image/... editors";
        games.enable = lib.mkEnableOption "enable games";

        utilities = {
          system.enable = lib.mkEnableOption "enable system-utilities";
          user.enable = lib.mkEnableOption "enable user-utilities";
        };
      };
    };
  };
}
