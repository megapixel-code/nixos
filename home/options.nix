{
  lib,
  hostName,
  ...
}:
{
  options = {
    my = {
      module_mango.enable = lib.mkEnableOption "enable mangowc";

      module_home_lab.enable = lib.mkEnableOption "enable home-lab";
      module_router.enable = lib.mkEnableOption "enable router";

      module_bluetooth.enable = lib.mkEnableOption "enable bluetooth";
      module_audio.enable = lib.mkEnableOption "enable audio";
      module_printing.enable = lib.mkEnableOption "enable printing";

      battery_dependent = lib.mkEnableOption "device is battery dependent";

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

  config =
    let
      server = [ "server" ];
      router = [ "router" ];
      nixos-main = [ "nixos-main" ];
      nixos-school = [ "nixos-school" ];

      main = (nixos-main ++ nixos-school);
      all = (main ++ server ++ router);

      activate = hostnames: (lib.any (x: x == hostName) hostnames);
    in
    {
      my = {
        module_mango.enable = activate main;

        module_home_lab.enable = activate server;
        module_router.enable = activate router;

        module_bluetooth.enable = activate main;
        module_audio.enable = activate main;
        module_printing.enable = activate main;

        battery_dependent = activate nixos-school;

        pkgs = {
          apps.enable = activate main;
          editors.enable = activate main;
          games.enable = activate nixos-main;

          utilities = {
            system.enable = activate all;
            user.enable = activate main;
          };
        };
      };
    };
}
