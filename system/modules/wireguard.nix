{
  pkgs-stable,
  user,
  lib,
  config,
  pkgs,
  hostName,
  ...
}:
let
  is_server = config.home-manager.users.${user}.my.module_home_lab.enable;

  sops_private_key_name = "wireguard/privateKeys/${hostName}";

  personnal_peers = {
    "nixos-main" = {
      address = "10.0.0.1/32";
      public_key = "V1RzEbcGpr7aKfq9qPz8NK2iwgsVp23kD2P2UnrULjE=";
    };
    "nixos-school" = {
      address = "10.0.0.2/32";
      public_key = "p6WoUqksQ7FHiKolxYlCIrOHGjEsv/EXDY4TeU12fng=";
    };

    "phone" = {
      address = "10.0.1.1/32";
      public_key = "HLPDgwEgd/Ye+bDCXF7EnI/9qmqIlrkd2BWm5O3RfCA=";
    };
  };
  server_address = "10.0.0.69/32";
  server_public_key = "PxdneU21LtdrvBL2qfEmFyYf2Ex5MO9KMHGR339/fVM=";

  wireguard_network = "10.0.0.0/24";
  wireguard_port = 51820;
  wireguard_interface = "wg0";
in
{

  config = lib.mkMerge [
    {
      sops.secrets.${sops_private_key_name} = {
        mode = "640";
        owner = "root";
        group = "systemd-network";
      };

      networking.wg-quick.interfaces = {
        ${wireguard_interface} = {
          address = [ (if is_server then server_address else personnal_peers.${hostName}.address) ];
          privateKeyFile = config.sops.secrets.${sops_private_key_name}.path;

          peers =
            if is_server then
              lib.map (peer: {
                publicKey = peer.public_key;
                allowedIPs = [
                  peer.address
                ];
              }) (lib.attrValues personnal_peers)
            else
              [
                {
                  publicKey = server_public_key;
                  allowedIPs = [
                    server_address

                    # TODO: search terms: "NAT reflection/loopback" "hairpinning" "split DNS"
                    # (lib.mkIf (!is_server) "192.168.1.69")
                    (lib.mkIf (hostName == "nixos-school") "192.168.1.69")
                  ];
                  endpoint = "wg-ivanchtp.duckdns.org:${lib.toString wireguard_port}";
                }
              ];
        };
      };
    }

    (lib.mkIf is_server {
      networking = {
        nat = {
          enable = true;
          enableIPv6 = false;
          externalInterface = "eth0";
          internalInterfaces = [ wireguard_interface ];
        };

        firewall.allowedUDPPorts = [ wireguard_port ];

        wg-quick.interfaces = {
          ${wireguard_interface} = {
            listenPort = wireguard_port;

            postUp = ''
              ${pkgs.iptables}/bin/iptables -A FORWARD -i ${wireguard_interface} -j ACCEPT
              ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${wireguard_network} -o eth0 -j MASQUERADE
              ${pkgs.iptables}/bin/ip6tables -A FORWARD -i ${wireguard_interface} -j ACCEPT
              ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE
            '';
            preDown = ''
              ${pkgs.iptables}/bin/iptables -D FORWARD -i ${wireguard_interface} -j ACCEPT
              ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${wireguard_network} -o eth0 -j MASQUERADE
              ${pkgs.iptables}/bin/ip6tables -D FORWARD -i ${wireguard_interface} -j ACCEPT
              ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE
            '';
          };
        };
      };
    })
  ];
}
