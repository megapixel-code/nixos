{
  lib,
  config,
  user,
  ...
}:
{
  options = {
    my.home-lab = {
      enable = lib.mkEnableOption "enable home-lab";
      baseDomain = lib.mkOption {
        type = lib.types.str;
      };
    };
  };

  config =
    let
      is_set = value: (lib.typeOf value) == "set";
      home-lab_sub_attrs = builtins.filter (value: (is_set value)) (
        builtins.attrValues config.my.home-lab
      );
      home-lab = config.my.home-lab;
    in
    lib.mkIf config.home-manager.users.${user}.my.module-home-lab.enable {
      my.home-lab = {
        enable = true;
        baseDomain = "ivanchtp.duckdns.org";

        fail2ban = {
          enable = true;
        };

        nextcloud = {
          enable = true;
          auto-proxy = false;
          prefix = "cloud";
          category = "services";
        };
        immich = {
          enable = true;
          auto-proxy = true;
          prefix = "pictures";
          category = "media";
        };
        jellyfin = {
          enable = true;
          auto-proxy = false;
          prefix = "movies";
          category = "media";
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
          "${home-lab.baseDomain}" = {
            domain = "${home-lab.baseDomain}";
            extraDomainNames = [ "*.${home-lab.baseDomain}" ];
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

        virtualHosts =
          let
            all_auto_proxy = lib.filter (
              attr: if attr ? auto-proxy then attr.auto-proxy else false
            ) home-lab_sub_attrs;
          in
          lib.mkMerge [
            (lib.mkMerge (
              map (attr: {
                "${attr.prefix}.${home-lab.baseDomain}" = {
                  useACMEHost = home-lab.baseDomain;
                  forceSSL = true;

                  locations."/" = {
                    proxyPass = "http://${attr.host}:${lib.toString attr.port}";
                    proxyWebsockets = true;
                  };
                };
              }) all_auto_proxy
            ))
            {
              "${config.my.home-lab.baseDomain}" = {
                useACMEHost = config.my.home-lab.baseDomain;
                forceSSL = true;

                locations."/" = {
                  return =
                    let
                      all_categories = lib.uniqueStrings (builtins.catAttrs "category" home-lab_sub_attrs);
                      get_prefixes = attrs: builtins.catAttrs "prefix" attrs;
                      get_prefixes_category =
                        category:
                        get_prefixes (
                          builtins.filter (a: if a ? category then (a.category == category) else false) home-lab_sub_attrs
                        );

                      mkContent = (
                        prefixes: category:
                        ''
                          <div class="category">
                            <h1>
                              ${category}
                            </h1>
                            <table>
                        ''
                        + "${lib.concatStrings (
                          map (prefix: ''
                            <tr>
                              <td>
                                <a href="https://${prefix}.${config.my.home-lab.baseDomain}">
                                ${prefix}
                                </a>
                              </td>
                            </tr>
                          '') prefixes
                        )}"
                        + ''
                            </table>
                          </div>
                        ''
                      );

                      all_content = lib.concatStrings (
                        map (category: mkContent (get_prefixes_category category) category) all_categories
                      );
                    in
                    ''
                      200 '
                      <html>
                        <body>
                          ${all_content}
                        </body>
                      </html>
                      '
                    '';
                  extraConfig = ''
                    default_type text/html;
                  '';
                };
              };
            }
          ];
      };
    };
}
