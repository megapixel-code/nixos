{
  pkgs,
  user,
  config,
  ...
}:
let
  trash_cleanup_name = "trash-cleanup";
in
{
  systemd.timers.${trash_cleanup_name} = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
      AccuracySec = "1h";
      Unit = "${trash_cleanup_name}.service";
    };
  };

  systemd.services.${trash_cleanup_name} = {
    script = ''
      ${pkgs.findutils}/bin/find "${
        config.home-manager.users.${user}.xdg.dataHome
      }/Trash" -atime +100 -delete
      ${pkgs.coreutils}/bin/echo "INFO: trashed files older than 100 days"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = user;
    };
  };

}
