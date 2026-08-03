{
  config,
  pkgs,
  user,
  lib,
  my_lib,
  ...
}:
{
  config = lib.mkIf config.home-manager.users.${user}.my.pkgs.utilities.system.enable {

    # # run `bat --help` to get a list of all possible configuration options.
    #
    # # Syntax mappings: map a certain filename pattern to a language.
    # #   Example 1: use the C++ syntax for Arduino .ino files
    # #   Example 2: Use ".gitignore"-style highlighting for ".ignore" files
    # # --map-syntax "*.ino:C++"
    # # --map-syntax ".ignore:Git Ignore"
    # # map-syntax = [
    # #   "*.ino:C++"
    # #   ".ignore:Git Ignore"
    # # ];

    environment.systemPackages = [
      (my_lib.makeWrapper {
        package = pkgs.bat;
        package_exec = "bat";
        script =
          let
            config = pkgs.writeText "config" ''
              --color=always
              --style=auto,+header-filesize
              --tabs=3
              --theme=base16
            '';
          in
          ''
            export BAT_CONFIG_PATH=${config}
          '';
      })
    ];
  };
}
