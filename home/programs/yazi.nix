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
      nushell # sudo
      gnutar # compress
      zip # compress
      rar # compress
      _7zip-zstd # compress
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
      inherit sudo;
    };
  };
}
