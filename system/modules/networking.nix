{
  lib,
  config,
  user,
  pkgs-stable,
  ...
}:
{
  config =
    let
      router_outside_interface = "eno1"; # builtin interface
      router_inside_interfaces = [
        "enp2s0f0"
        "enp2s0f1"
        "enp2s0f2"
        "enp2s0f3"
      ];
      bridge_name = "br0";
    in
    lib.mkMerge [
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
          # "net.ipv6.conf.all.forwarding" = false;
        };

        networking = {
          usePredictableInterfaceNames = true;
          dhcpcd.enable = false;

          defaultGateway = {
            address = "192.168.1.1";
            interface = router_outside_interface;
          };

          # TODO: dns server on homelab
          # nameservers = [
          #   "130.161.158.4"
          #   "130.161.33.17"
          # ];

          # domain = config.my.home-lab.baseDomain;
          # search = [ config.my.home-lab.baseDomain ];

          bridges.${bridge_name} = {
            interfaces = router_inside_interfaces;
          };

          interfaces = {
            ${router_outside_interface} = {
              ipv4.addresses = [
                {
                  address = "192.168.1.60";
                  prefixLength = 24;
                }
              ];
            };
            ${bridge_name} = {
              ipv4.addresses = [
                {
                  address = "192.168.0.1";
                  prefixLength = 24;
                }
              ];
            };
          };

          nat = {
            enable = true;
            externalInterface = router_outside_interface;
            internalInterfaces = [ bridge_name ];
          };
        };

        services.kea = {
          package = pkgs-stable.kea;
          dhcp4 = {
            enable = true;

            settings = {
              interfaces-config = {
                interfaces = [ (bridge_name + "/" + "192.168.0.1") ];
              };

              loggers = [
                {
                  name = "kea-dhcp4";
                  severity = "INFO";
                  debuglevel = 99;
                  output_options = [ { output = "stdout"; } ];
                }
              ];

              subnet4 = [

                {
                  id = 1;
                  pools = [
                    {
                      pool = "192.168.0.2 - 192.168.0.254";
                    }
                  ];
                  interface = bridge_name;
                  subnet = "192.168.0.0/24";
                  option-data = [
                    {
                      name = "routers";
                      data = "192.168.0.1";
                    }
                    {
                      name = "domain-name-servers";
                      data = "1.1.1.1,9.9.9.9";
                    }
                  ];
                }

              ];

            };
          };
        };

      })

    ];
}
