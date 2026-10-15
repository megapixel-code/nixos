{
  lib,
  config,
  user,
  ...
}:
{

  config = lib.mkMerge [
    {
      networking.firewall.enable = true;
    }

    (lib.mkIf config.home-manager.users.${user}.my.module-home-lab.enable {
      networking = {
        domain = "${config.my.home-lab.baseDomain}";
        usePredictableInterfaceNames = false;
        wireless.enable = false;
      };
    })

    (lib.mkIf (!config.home-manager.users.${user}.my.module-home-lab.enable) {
      users.users.${user} = {
        extraGroups = [
          "networkmanager"
        ];
      };

      networking = {
        networkmanager = {
          enable = true;
          wifi.powersave = false;
        };
      };
    })
  ];
}
