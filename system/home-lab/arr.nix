{
  lib,
  config,
  user,
  ...
}:
let
  service = "arr_stack";
  container_name = "arr";
  home-lab = config.my.home-lab;
  cfg = home-lab.${service};
  networking = config.my.networking;

  i2p_httpproxy_available = false;

  arr = {
    radarr = 7878;
    prowlarr = 9696;
    sonarr = 8989;
  };

  services = {
    i2p = 7070;
    qbittorrent = 8080;
  }
  // arr;
in
{
  options = {
    my.home-lab = {
      ${service} = {
        enable = lib.mkEnableOption "enable arr stack";
      };
    }
    // (lib.mapAttrs (name: _: {
      enable = lib.mkEnableOption "enable ${name} in arr container";
      auto-proxy = lib.mkEnableOption "automaticaly proxy";
      prefix = lib.mkOption {
        type = lib.types.str;
      };
      host = lib.mkOption {
        type = lib.types.str;
      };
      port = lib.mkOption {
        type = lib.types.int;
      };
      category = lib.mkOption {
        type = lib.types.str;
      };
    }) services);
  };

  config = lib.mkIf cfg.enable {
    my.home-lab = lib.mapAttrs (name: port: {
      enable = true;
      auto-proxy = true;
      prefix = "${name}";
      category = "arr";
      port = port;
      host = "192.168.100.2";
    }) services;

    networking = {
      nat = {
        internalInterfaces = [ "ve-${container_name}" ];
      };
    };

    containers.${container_name} = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.1";
      localAddress = "192.168.100.2";

      bindMounts = lib.mkMerge (
        lib.map
          (folder: {
            "${folder}".isReadOnly = false;
          })
          [
            home-lab.paths.movies.path
            home-lab.paths.series.path
            home-lab.paths.downloads.path
          ]
      );

      forwardPorts = [
        {
          containerPort = networking.i2p.port;
          hostPort = networking.i2p.port;
          protocol = "tcp";
        }
        {
          containerPort = networking.i2p.port;
          hostPort = networking.i2p.port;
          protocol = "udp";
        }
      ];

      config =
        {
          lib,
          ...
        }:
        let
          i2p_sam_port = 7656;
          i2p_httpproxy_port = 4444;
        in
        {
          networking = {
            useHostResolvConf = true;
            usePredictableInterfaceNames = true;

            firewall = {
              enable = true;
              allowedTCPPorts = [
                services.qbittorrent
                services.i2p
                networking.i2p.port
                (lib.mkIf i2p_httpproxy_available i2p_httpproxy_port)
              ];
              allowedUDPPorts = [
                networking.i2p.port
                (lib.mkIf i2p_httpproxy_available i2p_httpproxy_port)
              ];
            };

            proxy.default = "http://127.0.0.1:${lib.toString i2p_httpproxy_port}";
          };

          users.groups = {
            arr = {
              name = "arr";
              gid = 6969;
              members = lib.attrNames arr;
            };
          };

          services = lib.mkMerge [
            {
              i2pd = {
                enable = true;
                settings = {
                  port = networking.i2p.port;

                  http = {
                    strictheaders = false;
                    port = services.i2p;
                    address = "0.0.0.0"; # webinterface available outside container
                  };
                  httpproxy = {
                    port = i2p_httpproxy_port;
                    address = lib.mkIf i2p_httpproxy_available "0.0.0.0";
                  };
                  sam = {
                    enabled = true;
                    address = "127.0.0.1";
                    port = i2p_sam_port;
                  };
                };
              };
            }

            {
              qbittorrent = {
                enable = true;

                webuiPort = services.qbittorrent;
                group = "arr";

                serverConfig = {
                  LegalNotice.Accepted = true;

                  BitTorrent = {
                    Session = {
                      I2P = {
                        Enabled = true;
                        MixedMode = false;
                        PeXEnabled = true;
                        Port = i2p_sam_port;
                        Host = "127.0.0.1";
                      };
                      DefaultSavePath = home-lab.paths.downloads.path;
                      Interface = "lo";
                      InterfaceAddress = "127.0.0.1";
                      ProxyPeerConnections = true;
                      AnonymousModeEnabled = true;
                      Encryption = 0;
                    };
                  };

                  Meta = {
                    MigrationVersion = 8; # NOTE: needed otherwise options disappear
                  };

                  Network = {
                    Proxy = {
                      Type = "HTTP";
                      IP = "127.0.0.1";
                      Port = i2p_httpproxy_port;
                      AuthEnabled = false;
                      HostnameLookupEnabled = true;
                      Profiles.BitTorrent = true;
                    };
                  };

                  Preferences = {
                    General.Locale = "en";
                    WebUI = {
                      Username = "ivan";
                      Password_PBKDF2 = "rkz3LkSVdSmb2GY/5+E2pA==:gZHm+ZlvcaU9LqDjYk6sYiegym0qtwcIpDGKvhMcl1Xkx5QiOfhY8woKrbpyeL25RDNt3McdyvNm7Ggd4oR1Nw==";
                    };
                  };
                };
              };
            }

            (lib.mapAttrs (name: value: {
              enable = true;
              openFirewall = true;

              settings = {
                server = {
                  urlbase = "localhost";
                  bindaddress = "*";
                  port = value;
                  AllowedHosts = "";
                };
              };
            }) arr)
          ];

          system.stateVersion = "25.05";
        };
    };
  };
}
