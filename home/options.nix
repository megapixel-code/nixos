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

      module_ssh.config = lib.mkOption {
        type = lib.types.enum [
          "server"
          "personal"
          "none"
        ];
        description = "type of ssh config";
      };
      module_wireguard.config = lib.mkOption {
        type = lib.types.enum [
          "server"
          "personal"
          "none"
        ];
        description = "type of wireguard config";
      };

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

      select = hostnames: (lib.any (x: x == hostName) hostnames);
    in
    {
      my = {
        module_mango.enable = select main;

        module_home_lab.enable = select server;
        module_router.enable = select router;

        module_bluetooth.enable = select main;
        module_audio.enable = select main;
        module_printing.enable = select main;

        battery_dependent = select nixos-school;
        module_ssh.config =
          if (select main) then
            "personal"
          else if (select (router ++ server)) then
            "server"
          else
            "none";
        module_wireguard.config =
          if (select main) then
            "personal"
          else if (select server) then
            "server"
          else
            "none";

        pkgs = {
          apps.enable = select main;
          editors.enable = select main;
          games.enable = select nixos-main;

          utilities = {
            system.enable = select all;
            user.enable = select main;
          };
        };
      };
    };
}
