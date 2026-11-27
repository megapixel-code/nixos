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
      baseDomain = lib.mkOption { type = lib.types.str; };
      paths =
        let
          mkPathOpt = opt_name: {
            ${opt_name} = {
              path = lib.mkOption { type = lib.types.path; };
              mode = lib.mkOption { type = lib.types.str; };
              user = lib.mkOption { type = lib.types.str; };
              group = lib.mkOption { type = lib.types.str; };
            };
          };
        in
        mkPathOpt "movies" // mkPathOpt "series" // mkPathOpt "downloads";
    };
  };

  # TODO: patch holes : sudo netstat -ntulp

  config =
    let
      cfg = config.my.home-lab;
    in
    lib.mkMerge [
      {
        my.home-lab = {
          enable = config.home-manager.users.${user}.my.module_home_lab.enable;
          baseDomain = "ivanchtp.duckdns.org";
        };
      }

      (lib.mkIf cfg.enable {
        my.home-lab = {
          fail2ban = {
            enable = true;
          };
          arr_stack = {
            enable = true;
          };

          nextcloud = {
            enable = true;
            auto-proxy = false;
            prefix = "cloud";
            category = "services";
          };
          vaultwarden = {
            enable = true;
            auto-proxy = true;
            prefix = "password";
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
            auto-proxy = true;
            prefix = "movies";
            category = "media";
          };
          searxng = {
            enable = true;
            auto-proxy = true;
            prefix = "search";
            category = "search";
          };
          pihole = {
            enable = true;
            auto-proxy = true;
            prefix = "dns";
            category = "search";
          };

          paths =
            let
              base_dir = "/data";
              arr_group_id = 6969;
            in
            {
              movies = {
                path = "${base_dir}/media/movies";
                mode = "0770";
                user = "${user}";
                group = lib.toString arr_group_id;
              };
              series = {
                path = "${base_dir}/media/series";
                mode = "0770";
                user = "${user}";
                group = lib.toString arr_group_id;
              };
              downloads = {
                path = "${base_dir}/media/downloads";
                mode = "0770";
                user = "${user}";
                group = lib.toString arr_group_id;
              };
              # TODO: add paths with other services
            };
        };

        # ensure dirs are present on the machine
        systemd.tmpfiles.settings."home-lab-paths" = lib.mapAttrs' (
          name: value:
          lib.nameValuePair "${value.path}" {
            d = {
              mode = value.mode;
              user = value.user;
              group = value.group;
            };
          }
        ) cfg.paths;

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
            "${cfg.baseDomain}" = {
              domain = "${cfg.baseDomain}";
              extraDomainNames = [ "*.${cfg.baseDomain}" ];
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
              is_set = value: (lib.typeOf value) == "set";
              home-lab_sub_attrs = builtins.filter (value: (is_set value)) (
                builtins.attrValues config.my.home-lab
              );
              all_auto_proxy = lib.filter (
                attr: if attr ? auto-proxy then attr.auto-proxy else false
              ) home-lab_sub_attrs;
            in
            lib.mkMerge [
              (lib.mkMerge (
                map (attr: {
                  "${attr.prefix}.${cfg.baseDomain}" = {
                    useACMEHost = cfg.baseDomain;
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
      })
    ];
}
