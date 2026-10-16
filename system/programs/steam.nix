{
  lib,
  pkgs,
  user,
  config,
  ...
}:
{
  config = lib.mkIf config.home-manager.users.${user}.my.pkgs.games.enable {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          HOME = "${config.home-manager.users.${user}.xdg.dataHome}/Steam";
        };
      };
      # extest.enable = true;
    };
  };
}
