{
  user,
  lib,
  config,
  pkgs,
  hostName,
  ...
}:
let
  cfg = config.my.networking;
  config_type = config.home-manager.users.${user}.my.module_wireguard.config;
  sops_private_key_name = "wireguard/privateKeys/${hostName}";

  mkAdress = ip: "${ip}/32";
  fixPeer = peer: peer // { address = mkAdress peer.ip; };
  mkPeers = peers: lib.mapAttrs (name: peer: fixPeer peer) peers;

  personal_peers = mkPeers {
    "nixos-main" = {
      ip = "10.0.0.1";
      public_key = "V1RzEbcGpr7aKfq9qPz8NK2iwgsVp23kD2P2UnrULjE=";
    };
    "nixos-school" = {
      ip = "10.0.0.2";
      public_key = "p6WoUqksQ7FHiKolxYlCIrOHGjEsv/EXDY4TeU12fng=";
    };

    "phone" = {
      ip = "10.0.1.1";
      public_key = "HLPDgwEgd/Ye+bDCXF7EnI/9qmqIlrkd2BWm5O3RfCA=";
    };
  };
  server = fixPeer {
    ip = "10.0.0.69";
    public_key = "PxdneU21LtdrvBL2qfEmFyYf2Ex5MO9KMHGR339/fVM=";
  };
in
{
  config = lib.mkIf (config_type != "none") (
    lib.mkMerge [
      {
        sops.secrets.${sops_private_key_name} = {
          mode = "640";
          owner = "root";
          group = "systemd-network";
        };

        networking.wg-quick.interfaces = {
          ${cfg.wireguard.interface} = {
            address = [
              (
                if (config_type == "server") then
                  server.address
                else if (config_type == "personal") then
                  personal_peers.${hostName}.address
                else
                  lib.throw "should not happen"
              )
            ];
            privateKeyFile = config.sops.secrets.${sops_private_key_name}.path;

            peers =
              if (config_type == "server") then
                lib.map (peer: {
                  publicKey = peer.public_key;
                  allowedIPs = [
                    peer.address
                  ];
                }) (lib.attrValues personal_peers)
              else if (config_type == "personal") then
                [
                  {
                    publicKey = server.public_key;
                    allowedIPs = [
                      server.address
                      cfg.server.ip
                      "0.0.0.0/0"
                      "::/0"
                    ];
                    endpoint = "90.127.113.99:${lib.toString cfg.wireguard.port}";
                  }
                ]
              else
                lib.throw "should not happen";
          };
        };
      }

      (lib.mkIf (config_type == "server") {
        networking.hosts = lib.mapAttrs' (
          hostname: attrs: lib.nameValuePair (attrs.ip) [ ("wg-" + hostname) ]
        ) personal_peers;

        networking = {
          firewall.allowedUDPPorts = [ cfg.wireguard.port ];

          nat = {
            enable = true;
            enableIPv6 = false;
            externalInterface = "eth0";
            internalInterfaces = [ cfg.wireguard.interface ];
          };

          wg-quick.interfaces = {
            ${cfg.wireguard.interface} = {
              listenPort = cfg.wireguard.port;

              postUp = ''
                ${pkgs.iptables}/bin/iptables -A FORWARD -i ${cfg.wireguard.interface} -j ACCEPT
                ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${cfg.wireguard.subnet} -o eth0 -j MASQUERADE
              '';
              preDown = ''
                ${pkgs.iptables}/bin/iptables -D FORWARD -i ${cfg.wireguard.interface} -j ACCEPT
                ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${cfg.wireguard.subnet} -o eth0 -j MASQUERADE
              '';
            };
          };
        };
      })
    ]
  );
}
