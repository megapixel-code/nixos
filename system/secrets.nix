{
  config,
  user,
  hostName,
  ...
}:
{
  sops = {
    defaultSopsFile =
      {
        "server" = ../secrets/home-lab.yaml;
        "router" = ../secrets/router.yaml;
        "nixos-main" = ../secrets/primary.yaml;
        "nixos-school" = ../secrets/primary.yaml;
      }
      ."${hostName}";

    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home-manager.users.${user}.xdg.configHome}/sops/age/keys.txt";
  };
}
