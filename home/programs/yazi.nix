{
  pkgs,
  ...
}:
{
  programs.yazi = {
    enable = true;

    extraPackages = with pkgs; [
      udisks # dependency of mount plugin
      util-linux # dependency of mount plugin
      trash-cli # dependency of restore plugin
      git
      dragon-drop # drag and drop
    ];

    plugins = with pkgs.yaziPlugins; {
      inherit wl-clipboard;
      inherit chmod;
      inherit restore;
      inherit compress;
      inherit full-border;
      inherit yatline;
      inherit git;
      inherit mount;
    };
  };
}
