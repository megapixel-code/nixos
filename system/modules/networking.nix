{
  lib,
  config,
  user,
  hostName,
  allPersonalHostNames,
  allServerHostNames,
  ...
}:
{
  config = lib.mkMerge [
    (lib.mkIf config.home-manager.users.${user}.my.networking.personal.enable {
      users.users.${user} = {
        extraGroups = [
          "networkmanager"
        ];
      };

      networking = {
        networkmanager = {
          enable = true;
          wifi.powersave = false;
        };
        # wireless.iwd.enable = true;  # needed for using impala network manager
      };

      # NOTE: taken from https://github.com/NixOS/nixpkgs/blob/ed142ab1b3a092c4d149245d0c4126a5d7ea00b0/nixos/modules/config/networking.nix#L175
      sops.secrets."networking/localHostsIp/router" = { };
      sops.templates."hosts" = {
        content =
          let
            cfg = config.networking;
            hostNames = # Note: The FQDN (canonical hostname) has to come first:
              lib.optional (cfg.hostName != "" && cfg.domain != null) "${cfg.hostName}.${cfg.domain}"
              ++ lib.optional (cfg.hostName != "") cfg.hostName; # Then the hostname (without the domain)
            strHostNames = lib.concatStringsSep " " hostNames;
          in
          ''
            127.0.0.1 localhost
            ${lib.optionalString cfg.enableIPv6 "::1 localhost"}
            127.0.0.2 ${strHostNames}
            ${config.sops.placeholder."networking/localHostsIp/router"} router
          '';
        path = "/etc/hosts";
        mode = "440";
        group = "wheel";
      };

      sops.secrets."ssh/publicKeys/personal" = { };
      sops.templates."id_ed25519.pub" = {
        content = ''
          ${config.sops.placeholder."ssh/publicKeys/personal"} ${user}@${hostName}
        '';
        path = "/home/${user}/.ssh/id_ed25519.pub";
        mode = "440";
        group = "wheel";
      };
      sops.secrets."ssh/privateKeys/personal" = {
        path = "/home/${user}/.ssh/id_ed25519";
        mode = "440";
        group = "wheel";
      };
      sops.secrets."ssh/publicKeys/servers" = { };
      sops.templates."known_hosts" = {
        content =
          let
            oneToString = (
              ServerHostName:
              lib.concatStringsSep " " [
                ServerHostName
                "${config.sops.placeholder."ssh/publicKeys/servers"}"
              ]
              + "\n"
            );
            allToString = lib.concatStrings (map oneToString allServerHostNames);
          in
          ''
            ${allToString}
          '';
        path = "/home/${user}/.ssh/known_hosts";
        mode = "440";
        group = "wheel";
      };

      services.openssh = {
        enable = false;
      };
    })

    (lib.mkIf config.home-manager.users.${user}.my.networking.servers.enable {
      networking = {
        domain = "${config.my.home-lab.baseDomain}";
        usePredictableInterfaceNames = false;
        wireless.enable = false;

        firewall = {
          enable = true;
        };
      };

      sops.secrets."ssh/privateKeys/servers" = { };
      services.openssh = {
        enable = true;
        openFirewall = true;
        # generateHostKeys = false; # opt seems to not exist
        hostKeys = [ ]; # unset this opt to not generate keys

        # added in the config in /etc/ssh/sshd_config
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          HostKey = config.sops.secrets."ssh/privateKeys/servers".path;
        };
      };

      sops.secrets."ssh/publicKeys/personal" = { };
      sops.templates."${user}" = {
        content =
          let
            oneToString = (
              personalHostName:
              lib.concatStringsSep " " [
                "${config.sops.placeholder."ssh/publicKeys/personal"}"
                "${user}@${personalHostName}"
              ]
              + "\n"
            );
            allToString = lib.concatStrings (map oneToString allPersonalHostNames);
          in
          ''
            ${allToString}
          '';
        path = "/etc/ssh/authorized_keys.d/${user}";
        mode = "440";
        group = "wheel";
      };
    })
  ];
}
