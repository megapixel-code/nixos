{
  lib,
  config,
  ...
}:
let
  home-lab = config.my.home-lab;
  cfg = home-lab.jellyfin;
in
{
  options = {
    my.home-lab.jellyfin = {
      enable = lib.mkEnableOption "enable jellyfin";
      auto-proxy = lib.mkEnableOption "automaticaly proxy";
      prefix = lib.mkOption {
        type = lib.types.str;
      };
      category = lib.mkOption {
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable { };
}
