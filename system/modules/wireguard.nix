{
  pkgs-stable,
  user,
  lib,
  config,
  ...
}:
let
  is_server = config.home-manager.users.${user}.my.module-home-lab.enable;

  wireguard_network = "192.168.2.69/24";
  wireguard_address_main = "192.168.2.1/32";
  wireguard_port = 51820;
in
{
  config = lib.mkMerge [
    {
      networking.useNetworkd = true;

      systemd.network = {
        enable = true;

        networks."50-wg0" = {
          matchConfig.Name = "wg0";
        };

        netdevs."50-wg0" = {
          netdevConfig = {
            Kind = "wireguard";
            Name = "wg0";
          };

          wireguardConfig = {
            ListenPort = wireguard_port;
            RouteTable = "main";
            FirewallMark = 42;
          };
        };
      };
    }

    (lib.mkIf is_server {
      # server config
      sops.secrets."wireguard/privateKeys/servers" = {
        mode = "640";
        owner = "root";
        group = "systemd-network";
      };

      networking = {
        nat = {
          enable = true;
          enableIPv6 = true;
          externalInterface = "eth0";
          internalInterfaces = [ "wg0" ];
        };
        firewall.allowedUDPPorts = [ wireguard_port ];
      };

      systemd.network = {
        networks."50-wg0" = {
          networkConfig = {
            IPv4Forwarding = true;
            IPv6Forwarding = true;
          };
          address = [
            wireguard_network
          ];
        };

        netdevs."50-wg0" = {
          wireguardConfig = {
            PrivateKeyFile = config.sops.secrets."wireguard/privateKeys/servers".path;
          };
          wireguardPeers = [
            {
              PublicKey = "V1RzEbcGpr7aKfq9qPz8NK2iwgsVp23kD2P2UnrULjE=";
              AllowedIPs = [ wireguard_network ];
            }
          ];
        };
      };
    })

    (lib.mkIf (!is_server) {
      # personal config

      sops.secrets."wireguard/privateKeys/personal" = {
        mode = "640";
        owner = "root";
        group = "systemd-network";
      };

      systemd.network = {
        networks."50-wg0" = {
          address = [
            wireguard_address_main
          ];
        };
        netdevs."50-wg0" = {
          wireguardConfig = {
            PrivateKeyFile = config.sops.secrets."wireguard/privateKeys/personal".path;
          };
          wireguardPeers = [
            {
              PublicKey = "PxdneU21LtdrvBL2qfEmFyYf2Ex5MO9KMHGR339/fVM=";
              AllowedIPs = [ "192.168.1.69/32" ];
              Endpoint = "wg-ivanchtp.duckdns.org:${lib.toString wireguard_port}";
            }
          ];
        };
      };

    })
  ];
}
