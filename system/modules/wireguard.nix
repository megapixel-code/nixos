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
  is_server = config.home-manager.users.${user}.my.module-home-lab.enable;

  server_public_key = "PxdneU21LtdrvBL2qfEmFyYf2Ex5MO9KMHGR339/fVM=";
  personal_public_key = "V1RzEbcGpr7aKfq9qPz8NK2iwgsVp23kD2P2UnrULjE=";
  public_key = if is_server then personal_public_key else server_public_key;
  sops_private_key_name =
    if is_server then "wireguard/privateKeys/servers" else "wireguard/privateKeys/personal";

  wireguard_network = "10.0.0.0/24";
  wireguard_address_main = "10.0.0.1/32";
  wireguard_address_server = "10.0.0.69/32";
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
          address = [ (if is_server then wireguard_address_server else wireguard_address_main) ];
          privateKeyFile = config.sops.secrets.${sops_private_key_name}.path;
          peers = [
            {
              publicKey = public_key;
              allowedIPs = [
                (if is_server then wireguard_address_main else wireguard_address_server)

                # TODO: search terms: "NAT reflection/loopback" "hairpinning" "split DNS"
                # (lib.mkIf (!is_server) "192.168.1.69")
                (lib.mkIf (hostName == "nixos-school") "192.168.1.69")
              ];
              endpoint = lib.mkIf (!is_server) "wg-ivanchtp.duckdns.org:${lib.toString wireguard_port}";
            }
          ];
        };
      };
    }

    (lib.mkIf is_server {
      networking = {
        nat = {
          enable = true;
          enableIPv6 = true;
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
