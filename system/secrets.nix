{
  config,
  user,
  ...
}:
{
  sops = {
    defaultSopsFile =
      if config.home-manager.users.${user}.my.module-home-lab.enable then
        ../secrets/home-lab.yaml
      else
        ../secrets/primary.yaml;

    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home-manager.users.${user}.xdg.configHome}/sops/age/keys.txt";
  };
}
