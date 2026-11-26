{
  lib,
  config,
  ...
}:
let
  service = "arr";
  home-lab = config.my.home-lab;
  cfg = home-lab.${service};
  networking = config.my.networking;
  i2p_webinterface_port = 7070;
in
{
  options = {
    my.home-lab = {
      i2p = {
        enable = lib.mkEnableOption "enable i2p in arr container";
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
      };
      ${service} = {
        enable = lib.mkEnableOption "enable ${service}";
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
      };
    };
  };

  config = lib.mkIf cfg.enable {
    my.home-lab = {
      ${service} = {
        # port = 7070;
        # host = "192.168.100.2";
      };
      i2p = {
        port = i2p_webinterface_port;
        host = "192.168.100.2";
      };
    };

    networking = {
      nat = {
        internalInterfaces = [ "ve-${service}" ];
      };
    };

    containers.${service} = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.1";
      localAddress = "192.168.100.2";

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
          config,
          ...
        }:
        {
          networking = {
            useHostResolvConf = true;
            usePredictableInterfaceNames = true;

            firewall = {
              enable = true;
              allowedTCPPorts = [
                i2p_webinterface_port
                networking.i2p.port
              ];
              allowedUDPPorts = [
                i2p_webinterface_port
                networking.i2p.port
              ];
            };
          };

          services.i2pd = {
            enable = true;
            settings = {
              port = networking.i2p.port;

              http = {
                strictheaders = false;
                port = i2p_webinterface_port;
                address = "0.0.0.0"; # webinterface available outside container
              };
              sam = {
                enabled = true;
              };
            };
          };

          system.stateVersion = "25.05";
        };
    };
  };
}
