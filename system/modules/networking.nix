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

    (lib.mkIf (config.home-manager.users.${user}.my.module_mango.enable) {
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

    (lib.mkIf config.home-manager.users.${user}.my.module_home_lab.enable {
      networking = {
        domain = "${config.my.home-lab.baseDomain}";
        usePredictableInterfaceNames = false;
        wireless.enable = false;
      };
    })

    (lib.mkIf (config.home-manager.users.${user}.my.module_router.enable) {
      boot.kernel.sysctl = {
        "net.ipv4.conf.all.forwarding" = true;
      };

      networking =
        let
          outside_interface = "eno1"; # builtin interface
          inside_interfaces = [
            "enp2s0f0"
            "enp2s0f1"
            "enp2s0f2"
            "enp2s0f3"
          ];
        in
        {
          usePredictableInterfaceNames = true;

          defaultGateway = {
            address = "192.168.1.1";
            interface = "enp3s0";
          };

          # TODO: dns server on homelab
          # nameservers = [
          #   "130.161.158.4"
          #   "130.161.33.17"
          # ];

          domain = config.my.home-lab.baseDomain;
          search = [ config.my.home-lab.baseDomain ];

          interfaces = {
            ${outside_interface} = {
              ipv4.addresses = [
                {
                  address = "192.168.1.68";
                  prefixLength = 24;
                }
              ];
            };

            enp2s0f0 = { };
            enp2s0f1 = { };
            enp2s0f2 = { };
            enp2s0f3 = { };
          };
        };
    })

  ];
}
