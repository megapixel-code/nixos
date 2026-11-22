{
  lib,
  config,
  user,
  pkgs-stable,
  ...
}:
{
  options.my.networking = with lib.types; {
    public_ip = lib.mkOption { type = str; };
    router = {
      ip = lib.mkOption { type = str; };
      subnet = lib.mkOption { type = str; };
      pool = lib.mkOption { type = str; };

      dns_ips = lib.mkOption { type = listOf str; };

      outside_interface = lib.mkOption { type = str; }; # builtin interface
      inside_interfaces = lib.mkOption { type = listOf str; };
      bridge_name = lib.mkOption { type = str; };
    };
    server = {
      ip = lib.mkOption { type = str; };
      mac_addr = lib.mkOption { type = str; };
    };
    wireguard = {
      network = lib.mkOption { type = str; };
      prefix_length = lib.mkOption { type = ints.between 0 32; };
      subnet = lib.mkOption { type = str; };
      port = lib.mkOption { type = port; };
      interface = lib.mkOption { type = str; };
    };
  };

  config =
    let
      cfg = config.my.networking;
    in
    lib.mkMerge [
      {
        my.networking =
          let
            mkSubnet =
              network: prefix:
              lib.concatStringsSep "/" [
                network
                (lib.toString prefix)
              ];
          in
          {
            public_ip = "90.127.113.99";
            router = {
              ip = "192.168.0.1";
              subnet = mkSubnet "192.168.0.0" 24;
              pool = "192.168.0.2 - 192.168.0.254";

              dns_ips = [
                cfg.server.ip
              ];

              outside_interface = "eno1"; # builtin interface
              inside_interfaces = [
                "enp2s0f0"
                "enp2s0f1"
                "enp2s0f2"
                "enp2s0f3"
              ];
              bridge_name = "br0";
            };
            server = {
              ip = "192.168.0.69";
              mac_addr = "10:e7:c6:24:54:41";
            };
            wireguard = {
              network = "10.0.0.0";
              prefix_length = 16;
              subnet = mkSubnet cfg.wireguard.network cfg.wireguard.prefix_length;
              port = 51820;
              interface = "wg0";
            };
          };

        networking = {
          firewall.enable = true;
          nameservers = cfg.router.dns_ips;
        };
      }

      (lib.mkIf (config.home-manager.users.${user}.my.module_mango.enable) {
        users.users.${user} = {
          extraGroups = [
            "networkmanager"
          ];
        };

        networking = {
          dhcpcd.extraConfig = "nohook resolv.conf"; # ignore dhcp dns recommendation
          networkmanager = {
            enable = true;
            dns = "none"; # networkmanager will not modify resolv.conf
            wifi.powersave = false;
          };
          hosts = {
            ${cfg.router.ip} = [ "router" ];
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

          defaultGateway = {
            address = "192.168.1.1";
            interface = cfg.router.outside_interface;
          };

          bridges.${cfg.router.bridge_name} = {
            interfaces = cfg.router.inside_interfaces;
          };

          interfaces = {
            ${cfg.router.bridge_name} = {
              ipv4.addresses = [
                {
                  address = cfg.router.ip;
                  prefixLength = 24;
                }
              ];
            };
          };

          nat = {
            enable = true;
            externalInterface = cfg.router.outside_interface;
            internalInterfaces = [ cfg.router.bridge_name ];

            dmzHost = config.my.networking.server.ip;
            forwardPorts = [
              {
                loopbackIPs = [ cfg.public_ip ];
                sourcePort = cfg.wireguard.port;
                destination = "${cfg.server.ip}:${lib.toString cfg.wireguard.port}";
                proto = "udp";
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
                interfaces = [ (cfg.router.bridge_name + "/" + cfg.router.ip) ];
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
                      pool = cfg.router.pool;
                    }
                  ];
                  interface = cfg.router.bridge_name;
                  subnet = cfg.router.subnet;
                  option-data = [
                    {
                      name = "routers";
                      data = cfg.router.ip;
                    }
                    {
                      name = "domain-name-servers";
                      data = lib.concatStringsSep ", " cfg.router.dns_ips;
                    }
                  ];
                  reservations = [
                    {
                      hostname = "server";
                      hw-address = cfg.server.mac_addr;
                      ip-address = cfg.server.ip;
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
