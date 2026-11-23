{
  lib,
  config,
  pkgs-stable,
  ...
}:
let
  service = "pihole";
  home-lab = config.my.home-lab;
  cfg = home-lab.${service};
in
{
  options = {
    my.home-lab.${service} = {
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

  config =
    let
      home_lab_ip = "192.168.0.69";
    in
    lib.mkIf cfg.enable {
      my.home-lab.${service} = {
        port = 3000;
        host = "127.0.0.1";
      };

      services.pihole-web = {
        enable = true;
        package = pkgs-stable.pihole-web;
        ports = [ (lib.toString cfg.port) ];
        hostName = cfg.host;
      };

      services.pihole-ftl = {
        enable = true;
        package = pkgs-stable.pihole-ftl;
        piholePackage = pkgs-stable.pihole;
        openFirewallDNS = true;

        settings = {
          dns = {
            # NOTE: https://sebsauvage.net/wiki/doku.php?id=dns-alternatifs
            upstreams = [
              # fdn
              "80.67.169.12"
              "80.67.169.40"

              # DNSForge.de
              "138.199.149.249"
              "78.47.71.194"

              # DNS4All.eu
              "194.0.5.3"
              "194.0.5.64"

              # LibreDNS.gr
              "88.198.92.222"
              "192.71.166.92"

              # QuadNine
              "9.9.9.10"
            ];
            piholePTR = "HOSTNAME";
            hosts = [
              (lib.concatStringsSep " " [
                home_lab_ip
                home-lab.baseDomain
              ])
            ];
            listeningMode = "ALL";
            optimizer = 43200; # 12h
          };

        };

        lists =
          let
            blocked_lists = [
              "https://ublockorigin.github.io/uAssets/filters/privacy.min.txt"
              "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/tif.txt"
              "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.plus.txt"
              "http://sbc.io/hosts/hosts"
              "https://big.oisd.nl/"
              "https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt"
            ];
          in
          lib.map (list: {
            enabled = true;
            url = list;
            type = "block";
          }) blocked_lists;
      };
    };
}
