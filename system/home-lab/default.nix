{
  lib,
  config,
  user,
  ...
}:
{
  options = {
    my.home-lab = {
      baseDomain = lib.mkOption {
        default = "ivanchtp.duckdns.org";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf config.home-manager.users.${user}.my.module-home-lab.enable {
    services.fail2ban = {
      # TODO: better config
      enable = true;
      maxretry = 3;
      ignoreIP = [ "ivanchtp.duckdns.org" ]; # TODO: REMOVE
      bantime = "24h";
      bantime-increment = {
        enable = true;
        formula = "ban.Time * math.exp( ban.Count + 1 )";
        overalljails = true;
      };
    };

    # NOTE: this is used to update duckdns ip for the domain
    # sops.secrets."duckdns/domains" = { };
    # sops.secrets."duckdns/token" = { };
    # services.duckdns = {
    #   enable = true;
    #   domainsFile = config.sops.secrets."duckdns/domains".path;
    #   tokenFile = config.sops.secrets."duckdns/token".path;
    # };

    sops.secrets."duckdns/token" = { };
    sops.templates."acme.env" = {
      content = ''
        DUCKDNS_TOKEN=${config.sops.placeholder."duckdns/token"}
      '';
      owner = "acme";
    };
    security.acme = {
      acceptTerms = true;

      defaults = {
        email = "chainemegapixel+acme@gmail.com";

        dnsProvider = "duckdns";
        dnsPropagationCheck = false;
        environmentFile = config.sops.templates."acme.env".path;

        group = config.services.nginx.group;
        reloadServices = [ "nginx.service" ];
      };
      certs = {
        "${config.my.home-lab.baseDomain}" = {
          domain = "${config.my.home-lab.baseDomain}";
          extraDomainNames = [ "*.${config.my.home-lab.baseDomain}" ];
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    users.users.nginx.extraGroups = [ "acme" ];
    services.nginx = {
      enable = true;

      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedBrotliSettings = true;

      virtualHosts."${config.my.home-lab.baseDomain}" = {
        useACMEHost = config.my.home-lab.baseDomain;
        forceSSL = true;

        locations."/" = {
          return = "200 '<html><body>BALLS</body></html>'";
          extraConfig = ''
            default_type text/html;
          '';
        };
      };
    };
  };
}
