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
      router = {
        outside_interface = "eno1"; # builtin interface
        inside_interfaces = [
          "enp2s0f0"
          "enp2s0f1"
          "enp2s0f2"
          "enp2s0f3"
        ];
        bridge_name = "br0";

        # TODO: dns server on homelab
        dns_ips = [
          "1.1.1.1"
          "9.9.9.9"
        ];

        outside_ip = "192.168.1.60";
        inside_ip = "192.168.0.1";
        subnet = "192.168.0.0/24";
        pool = "192.168.0.2 - 192.168.0.254";
      };
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
          hosts = {
            ${router.inside_ip} = [ "router" ];
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
            interface = router.outside_interface;
          };

          nameservers = router.dns_ips;

          # domain = config.my.home-lab.baseDomain;
          # search = [ config.my.home-lab.baseDomain ];

          bridges.${router.bridge_name} = {
            interfaces = router.inside_interfaces;
          };

          interfaces = {
            ${router.outside_interface} = {
              ipv4.addresses = [
                {
                  address = router.outside_ip;
                  prefixLength = 24;
                }
              ];
            };
            ${router.bridge_name} = {
              ipv4.addresses = [
                {
                  address = router.inside_ip;
                  prefixLength = 24;
                }
              ];
            };
          };

          nat = {
            enable = true;
            externalInterface = router.outside_interface;
            internalInterfaces = [ router.bridge_name ];
          };
        };

        services.kea = {
          package = pkgs-stable.kea;
          dhcp4 = {
            enable = true;

            settings = {
              interfaces-config = {
                interfaces = [ (router.bridge_name + "/" + router.inside_ip) ];
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
                      pool = router.pool;
                    }
                  ];
                  interface = router.bridge_name;
                  subnet = router.subnet;
                  option-data = [
                    {
                      name = "routers";
                      data = router.inside_ip;
                    }
                    {
                      name = "domain-name-servers";
                      data = lib.concatStringsSep "," router.dns_ips;
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
