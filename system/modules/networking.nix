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

        dns_ips = [
          server.ip
        ];

        inside_ip = "192.168.0.1";
        subnet = "192.168.0.0/24";
        pool = "192.168.0.2 - 192.168.0.254";
      };

      server = {
        interface = "eth0";
        ip = "192.168.0.69";
        mac_addr = "10:e7:c6:24:54:41";
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
          nameservers = router.dns_ips;

          defaultGateway = {
            address = "192.168.1.1";
            interface = router.outside_interface;
          };

          bridges.${router.bridge_name} = {
            interfaces = router.inside_interfaces;
          };

          interfaces = {
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
            forwardPorts =
              let
                wireguard_port = 51820; # TODO: use option config
                protocol = "udp";
              in
              [
                {
                  sourcePort = wireguard_port;
                  destination = "${server.ip}:${lib.toString wireguard_port}";
                  proto = protocol;
                }
              ];
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
                  reservations = [
                    {
                      hostname = "server";
                      hw-address = server.mac_addr;
                      ip-address = server.ip;
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
