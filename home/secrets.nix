{
  config,
  ...
}:
{
  sops = {
    defaultSopsFile =
      if config.my.module-home-lab.enable then ../secrets/home-lab.yaml else ../secrets/primary.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
  };
}
